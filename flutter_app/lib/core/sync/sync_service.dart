import 'dart:async';
import 'dart:convert';
import 'package:offline_sync_pro/data/local/local_database.dart';
import 'package:offline_sync_pro/data/remote/api_client.dart';
import 'package:offline_sync_pro/domain/models/record.dart';

class SyncService {
  final LocalDatabase database;
  final ApiClient apiClient;
  bool _isSyncing = false;
  Timer? _syncTimer;

  SyncService({
    required this.database,
    required this.apiClient,
  });

  // Iniciar sincronização automática periódica
  void startAutoSync({Duration interval = const Duration(seconds: 30)}) {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(interval, (_) => sync());
  }

  // Parar sincronização automática
  void stopAutoSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  // Sincronizar manualmente
  Future<SyncResult> sync() async {
    if (_isSyncing) {
      return SyncResult(
          success: false, message: 'Sincronização já em andamento');
    }

    _isSyncing = true;

    try {
      // 1. Push: Enviar registros pendentes
      final pushResult = await _pushPendingRecords();

      // 2. Pull: Buscar atualizações do servidor
      final pullResult = await _pullServerRecords();

      _isSyncing = false;

      return SyncResult(
        success: true,
        pushed: pushResult.pushed,
        conflicts: pushResult.conflicts,
        pulled: pullResult.pulled,
      );
    } catch (e) {
      _isSyncing = false;
      return SyncResult(
        success: false,
        message: 'Erro na sincronização: $e',
      );
    }
  }

  Future<PushResult> _pushPendingRecords() async {
    final pendingRecords = await database.getPendingRecords();

    if (pendingRecords.isEmpty) {
      return PushResult(pushed: 0, conflicts: 0);
    }

    try {
      final recordsToPush = pendingRecords.map((record) {
        // Tentar fazer parse do JSON, se falhar usar como string
        dynamic data;
        try {
          data = jsonDecode(record.data);
        } catch (e) {
          data = record.data;
        }

        return {
          'uuid': record.uuid,
          'data': data,
          'version': record.version,
          'deleted_at': record.deletedAt,
        };
      }).toList();

      final response = await apiClient.pushRecords(recordsToPush);

      int pushed = 0;
      int conflicts = 0;

      // Atualizar status dos registros sincronizados
      if (response['synced'] != null) {
        for (var synced in response['synced']) {
          await database.updateSyncStatus(synced['uuid'], SyncStatus.synced);
          pushed++;
        }
      }

      // Marcar conflitos
      if (response['conflicts'] != null) {
        for (var conflict in response['conflicts']) {
          await database.updateSyncStatus(
              conflict['uuid'], SyncStatus.conflict);
          conflicts++;
        }
      }

      // Marcar erros
      if (response['errors'] != null) {
        for (var error in response['errors']) {
          await database.updateSyncStatus(error['uuid'], SyncStatus.error);
        }
      }

      return PushResult(pushed: pushed, conflicts: conflicts);
    } catch (e) {
      // Em caso de erro, marcar todos como error
      for (var record in pendingRecords) {
        await database.updateSyncStatus(record.uuid, SyncStatus.error);
      }
      rethrow;
    }
  }

  Future<PullResult> _pullServerRecords() async {
    try {
      // Buscar o último timestamp de atualização local
      final allRecords = await database.getAllRecords();
      String since = '1970-01-01T00:00:00.000Z';

      if (allRecords.isNotEmpty) {
        final latest = allRecords
            .map((r) => DateTime.parse(r.updatedAt))
            .reduce((a, b) => a.isAfter(b) ? a : b);
        since = latest.toIso8601String();
      }

      final response = await apiClient.pullRecords(since);
      final serverRecords = response['records'] as List;

      int pulled = 0;

      for (var serverRecord in serverRecords) {
        final localRecord =
            await database.getRecordByUuid(serverRecord['uuid']);

        if (localRecord == null) {
          // Novo record do servidor
          final dataString = serverRecord['data'] is String
              ? serverRecord['data']
              : jsonEncode(serverRecord['data']);

          final newRecord = Record(
            uuid: serverRecord['uuid'],
            data: dataString,
            version: serverRecord['version'],
            syncStatus: SyncStatus.synced,
            updatedAt: serverRecord['updated_at'],
            deletedAt: serverRecord['deleted_at'],
          );
          await database.insertRecord(newRecord);
          pulled++;
        } else if (localRecord.syncStatus == SyncStatus.synced) {
          // Atualizar apenas se estiver sincronizado (evitar sobrescrever pendentes)
          if (localRecord.version < serverRecord['version']) {
            final dataString = serverRecord['data'] is String
                ? serverRecord['data']
                : jsonEncode(serverRecord['data']);

            final updatedRecord = Record(
              id: localRecord.id,
              uuid: serverRecord['uuid'],
              data: dataString,
              version: serverRecord['version'],
              syncStatus: SyncStatus.synced,
              updatedAt: serverRecord['updated_at'],
              deletedAt: serverRecord['deleted_at'],
            );
            await database.updateRecordFromServer(updatedRecord);
            pulled++;
          }
        }
      }

      return PullResult(pulled: pulled);
    } catch (e) {
      rethrow;
    }
  }

  bool get isSyncing => _isSyncing;
}

class SyncResult {
  final bool success;
  final String? message;
  final int pushed;
  final int conflicts;
  final int pulled;

  SyncResult({
    required this.success,
    this.message,
    this.pushed = 0,
    this.conflicts = 0,
    this.pulled = 0,
  });
}

class PushResult {
  final int pushed;
  final int conflicts;

  PushResult({required this.pushed, required this.conflicts});
}

class PullResult {
  final int pulled;

  PullResult({required this.pulled});
}

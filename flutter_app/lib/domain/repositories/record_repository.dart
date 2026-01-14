import 'package:uuid/uuid.dart';
import 'package:offline_sync_pro/data/local/local_database.dart';
import 'package:offline_sync_pro/core/sync/sync_service.dart';
import 'package:offline_sync_pro/domain/models/record.dart';

class RecordRepository {
  final LocalDatabase database;
  final SyncService syncService;
  final _uuid = const Uuid();

  RecordRepository({
    required this.database,
    required this.syncService,
  });

  Future<List<Record>> getAllRecords() async {
    return await database.getAllRecords();
  }

  Future<Record> createRecord(String data) async {
    final now = DateTime.now().toIso8601String();
    final record = Record(
      uuid: _uuid.v4(),
      data: data,
      version: 1,
      syncStatus: SyncStatus.pending,
      updatedAt: now,
    );

    await database.insertRecord(record);
    
    // Tentar sincronizar em background
    syncService.sync().catchError((e) {
      // Erro silencioso - o record já está salvo localmente
      return SyncResult(success: false, message: e.toString());
    });

    return record;
  }

  Future<Record> updateRecord(Record record) async {
    final now = DateTime.now().toIso8601String();
    final updatedRecord = record.copyWith(
      version: record.version + 1,
      syncStatus: SyncStatus.pending,
      updatedAt: now,
    );

    await database.updateRecord(updatedRecord);
    
    // Tentar sincronizar em background
    syncService.sync().catchError((e) {
      // Erro silencioso
      return SyncResult(success: false, message: e.toString());
    });

    return updatedRecord;
  }

  Future<void> deleteRecord(String uuid) async {
    await database.deleteRecord(uuid);
    
    // Tentar sincronizar em background
    syncService.sync().catchError((e) {
      // Erro silencioso
      return SyncResult(success: false, message: e.toString());
    });
  }

  Future<SyncResult> sync() async {
    return await syncService.sync();
  }
}

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:offline_sync_pro/domain/models/record.dart';

class LocalDatabase {
  static final LocalDatabase _instance = LocalDatabase._internal();
  static Database? _database;

  factory LocalDatabase() => _instance;
  LocalDatabase._internal();

  static Future<Database> get instance async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'offline_sync.db');

      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
      );
    } catch (e) {
      // Se falhar (ex: web), lançar erro claro
      throw Exception('SQLite não está disponível nesta plataforma. Use Android/iOS para funcionalidades offline completas.');
    }
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid TEXT UNIQUE NOT NULL,
        data TEXT NOT NULL,
        version INTEGER NOT NULL DEFAULT 1,
        sync_status TEXT NOT NULL DEFAULT 'pending',
        updated_at TEXT NOT NULL,
        deleted_at TEXT
      )
    ''');

    await db.execute('CREATE INDEX idx_records_uuid ON records(uuid)');
    await db.execute('CREATE INDEX idx_records_sync_status ON records(sync_status)');
    await db.execute('CREATE INDEX idx_records_updated_at ON records(updated_at)');
  }

  // CRUD Operations
  Future<int> insertRecord(Record record) async {
    try {
      final db = await instance;
      return await db.insert(
        'records',
        record.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      // Web não suporta SQLite
      throw Exception('SQLite não disponível. Use Android/iOS para funcionalidades offline.');
    }
  }

  Future<List<Record>> getAllRecords() async {
    try {
      final db = await instance;
      final maps = await db.query(
        'records',
        where: 'deleted_at IS NULL',
        orderBy: 'updated_at DESC',
      );
      return maps.map((map) => Record.fromMap(map)).toList();
    } catch (e) {
      // Web não suporta SQLite - retornar lista vazia
      return [];
    }
  }

  Future<Record?> getRecordByUuid(String uuid) async {
    try {
      final db = await instance;
      final maps = await db.query(
        'records',
        where: 'uuid = ?',
        whereArgs: [uuid],
        limit: 1,
      );
      if (maps.isEmpty) return null;
      return Record.fromMap(maps.first);
    } catch (e) {
      return null;
    }
  }

  Future<int> updateRecord(Record record) async {
    try {
      final db = await instance;
      return await db.update(
        'records',
        record.toMap(),
        where: 'uuid = ?',
        whereArgs: [record.uuid],
      );
    } catch (e) {
      return 0;
    }
  }

  Future<int> deleteRecord(String uuid) async {
    try {
      final db = await instance;
      final now = DateTime.now().toIso8601String();
      return await db.update(
        'records',
        {
          'deleted_at': now,
          'sync_status': 'pending',
          'updated_at': now,
        },
        where: 'uuid = ?',
        whereArgs: [uuid],
      );
    } catch (e) {
      return 0;
    }
  }

  // Sync Operations
  Future<List<Record>> getPendingRecords() async {
    try {
      final db = await instance;
      final maps = await db.query(
        'records',
        where: 'sync_status = ?',
        whereArgs: ['pending'],
        orderBy: 'updated_at ASC',
      );
      return maps.map((map) => Record.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<int> updateSyncStatus(String uuid, SyncStatus status) async {
    try {
      final db = await instance;
      return await db.update(
        'records',
        {
          'sync_status': status.name,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'uuid = ?',
        whereArgs: [uuid],
      );
    } catch (e) {
      return 0;
    }
  }

  Future<int> updateRecordFromServer(Record record) async {
    try {
      final db = await instance;
      return await db.update(
        'records',
        {
          'data': record.data,
          'version': record.version,
          'sync_status': 'synced',
          'updated_at': record.updatedAt,
          'deleted_at': record.deletedAt,
        },
        where: 'uuid = ?',
        whereArgs: [record.uuid],
      );
    } catch (e) {
      return 0;
    }
  }

  Future<void> close() async {
    final db = await instance;
    await db.close();
  }
}

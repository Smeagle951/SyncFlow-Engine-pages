enum SyncStatus {
  pending,
  synced,
  conflict,
  error,
}

class Record {
  final int? id;
  final String uuid;
  final String data;
  final int version;
  final SyncStatus syncStatus;
  final String updatedAt;
  final String? deletedAt;

  Record({
    this.id,
    required this.uuid,
    required this.data,
    required this.version,
    required this.syncStatus,
    required this.updatedAt,
    this.deletedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uuid': uuid,
      'data': data,
      'version': version,
      'sync_status': syncStatus.name,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }

  factory Record.fromMap(Map<String, dynamic> map) {
    return Record(
      id: map['id'] as int?,
      uuid: map['uuid'] as String,
      data: map['data'] as String,
      version: map['version'] as int,
      syncStatus: SyncStatus.values.firstWhere(
        (e) => e.name == map['sync_status'],
        orElse: () => SyncStatus.pending,
      ),
      updatedAt: map['updated_at'] as String,
      deletedAt: map['deleted_at'] as String?,
    );
  }

  Record copyWith({
    int? id,
    String? uuid,
    String? data,
    int? version,
    SyncStatus? syncStatus,
    String? updatedAt,
    String? deletedAt,
  }) {
    return Record(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      data: data ?? this.data,
      version: version ?? this.version,
      syncStatus: syncStatus ?? this.syncStatus,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  bool get isDeleted => deletedAt != null;
}

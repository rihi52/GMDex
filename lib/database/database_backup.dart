import 'dart:convert';

import 'package:gmdex/database/database.dart';

const databaseBackupFormat = 'gmdex-database-backup';
const databaseBackupVersion = 1;
const maxDatabaseBackupSizeBytes = 256 * 1024 * 1024;

const _insertTableOrder = [
  'legendary_groups',
  'players',
  'creatures',
  'encounters',
  'creature_actions',
  'creature_traits',
  'creature_spellcastings',
  'creature_spells',
  'spells',
  'creature_saves',
  'creature_skills',
  'creature_senses',
  'creature_languages',
  'creature_environments',
  'legendary_group_entries',
  'notes',
  'encounter_creatures',
  'encounter_players',
];

class DatabaseBackupImportResult {
  const DatabaseBackupImportResult({
    required this.playerCount,
    required this.encounterCount,
    this.cancelled = false,
  });

  final int playerCount;
  final int encounterCount;
  final bool cancelled;
}

class DatabaseBackupOlderThanCurrentException implements Exception {
  const DatabaseBackupOlderThanCurrentException({
    required this.currentDatabaseAt,
    required this.pendingBackupAt,
  });

  final DateTime currentDatabaseAt;
  final DateTime pendingBackupAt;

  @override
  String toString() =>
      'The backup is older than the current database and requires confirmation.';
}

/// Encodes every application table as portable JSON while retaining row IDs.
Future<String> exportDatabaseBackupJson(
  AppDatabase db, {
  DateTime? exportedAt,
}) async {
  final exportTime = (exportedAt ?? DateTime.now()).toUtc();
  final tables = <String, List<Map<String, Object?>>>{};
  await db.transaction(() async {
    for (final table in db.allTables) {
      final name = table.actualTableName;
      final rows = await db.customSelect('SELECT * FROM "$name"').get();
      tables[name] = [for (final row in rows) _encodeRow(row.data)];
    }
  });

  final json = const JsonEncoder.withIndent('  ').convert({
    'format': databaseBackupFormat,
    'version': databaseBackupVersion,
    'databaseSchemaVersion': db.schemaVersion,
    'exportedAt': exportTime.toIso8601String(),
    'tables': tables,
  });
  if (utf8.encode(json).length > maxDatabaseBackupSizeBytes) {
    throw const FormatException('Database backups must be 256 MiB or smaller.');
  }
  return json;
}

/// Replaces all database data from a validated GMDex backup in one transaction.
Future<DatabaseBackupImportResult> importDatabaseBackupJson(
  AppDatabase db,
  String jsonContent, {
  Future<bool> Function(DateTime current, DateTime pending)? confirmOlderBackup,
}) async {
  if (utf8.encode(jsonContent).length > maxDatabaseBackupSizeBytes) {
    throw const FormatException('Database backups must be 256 MiB or smaller.');
  }

  final decoded = jsonDecode(jsonContent);
  if (decoded is! Map<String, dynamic> ||
      decoded['format'] != databaseBackupFormat ||
      decoded['version'] != databaseBackupVersion) {
    throw const FormatException(
      'This is not a supported GMDex database backup.',
    );
  }

  final exportedAt = _decodeExportedAt(decoded['exportedAt']);

  final schemaVersion = decoded['databaseSchemaVersion'];
  if (schemaVersion is! int ||
      schemaVersion < 1 ||
      schemaVersion > db.schemaVersion) {
    throw FormatException(
      'Backup database schema version is unsupported: $schemaVersion.',
    );
  }

  final rawTables = decoded['tables'];
  if (rawTables is! Map<String, dynamic>) {
    throw const FormatException(
      'Database backup must contain a "tables" object.',
    );
  }

  final tableNames = {for (final table in db.allTables) table.actualTableName};
  final unknownTables = rawTables.keys.toSet().difference(tableNames);
  if (unknownTables.isNotEmpty) {
    throw FormatException(
      'Database backup contains unsupported tables: '
      '${unknownTables.join(', ')}.',
    );
  }

  if (schemaVersion == db.schemaVersion &&
      !rawTables.keys.toSet().containsAll(tableNames)) {
    throw const FormatException(
      'Database backup is missing one or more tables.',
    );
  }

  final tableRows = <String, List<Map<String, Object?>>>{};
  for (final tableName in rawTables.keys) {
    final rawRows = rawTables[tableName];
    if (rawRows is! List) {
      throw FormatException('Table "$tableName" must contain an array.');
    }

    final columnNames = await db
        .customSelect('PRAGMA table_info("$tableName")')
        .map((row) => row.read<String>('name'))
        .get();
    final columns = columnNames.toSet();
    var rows = [
      for (var index = 0; index < rawRows.length; index++)
        _decodeRow(
          rawRows[index],
          tableName: tableName,
          rowIndex: index,
          validColumns: columns,
        ),
    ];
    if (tableName == 'spells') {
      final preferredByName = <String, Map<String, Object?>>{};
      for (final row in rows) {
        final name = row['name'];
        if (name is! String) continue;

        final previous = preferredByName[name];
        final source = row['source'];
        final previousSource = previous?['source'];
        final rowId = row['id'];
        final previousId = previous?['id'];
        final rowWins =
            previous == null ||
            (previousSource == 'SRD' && source != 'SRD') ||
            (previousSource != 'SRD' &&
                source != 'SRD' &&
                rowId is int &&
                previousId is int &&
                rowId > previousId);
        if (rowWins) preferredByName[name] = row;
      }
      rows = preferredByName.values.toList();
    }
    tableRows[tableName] = rows;
  }

  final currentTableNames = tableNames;
  if (_insertTableOrder.length != currentTableNames.length ||
      !_insertTableOrder.toSet().containsAll(currentTableNames)) {
    throw StateError(
      'Database backup table order must be updated for the current schema.',
    );
  }

  if (exportedAt != null) {
    final currentDatabaseAt = await db.getDatabaseCreatedAt();
    if (exportedAt.isBefore(currentDatabaseAt)) {
      if (confirmOlderBackup == null) {
        throw DatabaseBackupOlderThanCurrentException(
          currentDatabaseAt: currentDatabaseAt,
          pendingBackupAt: exportedAt,
        );
      }
      final confirmed = await confirmOlderBackup(currentDatabaseAt, exportedAt);
      if (!confirmed) {
        return DatabaseBackupImportResult(
          playerCount: tableRows['players']?.length ?? 0,
          encounterCount: tableRows['encounters']?.length ?? 0,
          cancelled: true,
        );
      }
    }
  }

  await db.transaction(() async {
    for (final table in db.allTables.toList().reversed) {
      await db.delete(table).go();
    }
    await db.customStatement('DELETE FROM sqlite_sequence');

    for (final tableName in _insertTableOrder) {
      for (final row in tableRows[tableName] ?? const []) {
        if (row.isEmpty) continue;
        final columns = row.keys.toList();
        final placeholders = List.filled(columns.length, '?').join(', ');
        final quotedColumns = columns.map((column) => '"$column"').join(', ');
        final values = columns.map((column) => row[column]).toList();
        await db.customStatement(
          'INSERT INTO "$tableName" ($quotedColumns) '
          'VALUES ($placeholders)',
          values,
        );
      }
    }
    await db.recordDatabaseImport(exportedAt);
  });

  return DatabaseBackupImportResult(
    playerCount: tableRows['players']?.length ?? 0,
    encounterCount: tableRows['encounters']?.length ?? 0,
  );
}

DateTime? _decodeExportedAt(Object? value) {
  if (value == null) return null;
  if (value is! String) {
    throw const FormatException(
      'Database backup "exportedAt" must be an ISO-8601 string.',
    );
  }
  try {
    return DateTime.parse(value).toUtc();
  } on FormatException {
    throw const FormatException(
      'Database backup "exportedAt" must be a valid ISO-8601 date/time.',
    );
  }
}

Map<String, Object?> _encodeRow(Map<String, Object?> row) => {
  for (final entry in row.entries)
    entry.key: entry.key.endsWith('_at') && entry.value is int
        ? DateTime.fromMillisecondsSinceEpoch(
            entry.value! as int,
            isUtc: true,
          ).toIso8601String()
        : entry.value,
};

Map<String, Object?> _decodeRow(
  Object? rawRow, {
  required String tableName,
  required int rowIndex,
  required Set<String> validColumns,
}) {
  if (rawRow is! Map<String, dynamic>) {
    throw FormatException(
      'Row $rowIndex in "$tableName" must be a JSON object.',
    );
  }

  final unknownColumns = rawRow.keys.toSet().difference(validColumns);
  if (unknownColumns.isNotEmpty) {
    throw FormatException(
      'Row $rowIndex in "$tableName" contains unsupported columns: '
      '${unknownColumns.join(', ')}.',
    );
  }

  return {
    for (final entry in rawRow.entries)
      entry.key: _decodeValue(
        entry.key,
        entry.value,
        tableName: tableName,
        rowIndex: rowIndex,
      ),
  };
}

Object? _decodeValue(
  String column,
  Object? value, {
  required String tableName,
  required int rowIndex,
}) {
  if (column.endsWith('_at')) {
    if (value is! String) {
      throw FormatException(
        'Date column "$column" in "$tableName" row $rowIndex '
        'must be an ISO-8601 string.',
      );
    }
    try {
      return DateTime.parse(value).toUtc().millisecondsSinceEpoch;
    } on FormatException {
      throw FormatException(
        'Date column "$column" in "$tableName" row $rowIndex '
        'must be a valid ISO-8601 string.',
      );
    }
  }
  if (value == null || value is String || value is int) return value;
  if (value is bool) return value ? 1 : 0;
  throw FormatException(
    'Unsupported value in "$tableName" row $rowIndex, column "$column".',
  );
}

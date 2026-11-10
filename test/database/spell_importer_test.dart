import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmdex/database/database.dart';
import 'package:gmdex/database/database_backup.dart';
import 'package:gmdex/database/spell_importer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test(
    'creates the spell catalog when upgrading a version 15 database',
    () async {
      await db.close();
      db = AppDatabase(
        NativeDatabase.memory(
          setup: (sqliteDb) => sqliteDb.execute('PRAGMA user_version = 15'),
        ),
      );

      expect(await db.select(db.spells).get(), isEmpty);
      expect(db.schemaVersion, 18);
    },
  );

  test('deduplicates old spell rows during the version 16 upgrade', () async {
    await db.close();
    db = AppDatabase(
      NativeDatabase.memory(
        setup: (sqliteDb) {
          sqliteDb.execute('''
            CREATE TABLE spells (
              id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              source TEXT NOT NULL,
              level INTEGER NOT NULL,
              school TEXT NOT NULL,
              data TEXT NOT NULL
            )
          ''');
          sqliteDb.execute('''
            CREATE UNIQUE INDEX idx_spell_name_source
            ON spells (name, source)
          ''');
          sqliteDb.execute('''
            INSERT INTO spells (name, source, level, school, data)
            VALUES
              ('Shared Spell', 'SRD', 1, 'E', '{"entries":["SRD"]}'),
              ('Shared Spell', 'PHB', 2, 'A', '{"entries":["PHB"]}')
          ''');
          sqliteDb.execute('PRAGMA user_version = 16');
        },
      ),
    );

    final spells = await db.select(db.spells).get();
    expect(spells, hasLength(1));
    expect(spells.single.source, 'PHB');
    expect(jsonDecode(spells.single.data)['entries'], ['PHB']);
    expect(spells.single.notes, isNull);
  });

  test(
    'imports the bundled spell definitions with their full source data',
    () async {
      final imported = await importSpells(db);
      final rows = await db.select(db.spells).get();
      final acidSplash = rows.singleWhere(
        (spell) => spell.name == 'Acid Splash',
      );
      final data = jsonDecode(acidSplash.data) as Map<String, dynamic>;

      expect(imported, 319);
      expect(rows, hasLength(319));
      expect(acidSplash.source, 'SRD');
      expect(acidSplash.level, 0);
      expect(acidSplash.school, 'C');
      expect(data['entries'], isNotEmpty);
      expect(data['components']['v'], isTrue);
    },
  );

  test('adds spell notes during the version 17 upgrade', () async {
    await db.close();
    db = AppDatabase(
      NativeDatabase.memory(
        setup: (sqliteDb) {
          sqliteDb.execute('''
            CREATE TABLE spells (
              id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              source TEXT NOT NULL,
              level INTEGER NOT NULL,
              school TEXT NOT NULL,
              data TEXT NOT NULL
            )
          ''');
          sqliteDb.execute('''
            CREATE UNIQUE INDEX idx_spell_name ON spells (name)
          ''');
          sqliteDb.execute('PRAGMA user_version = 17');
        },
      ),
    );

    expect(await db.select(db.spells).get(), isEmpty);
    expect(db.schemaVersion, 18);
  });

  test(
    'imports PHB and TCE data and preserves it in database backups',
    () async {
      const phb = '''
        {"spell":[{"name":"PHB Spell","source":"PHB","level":1,"school":"A",
          "entries":["PHB definition."]}]}
      ''';
      const tce = '''
        {"spell":[{"name":"TCE Spell","source":"TCE","level":2,"school":"E",
          "hasFluff":true,"entries":["TCE definition."]}]}
      ''';
      await importSpellsJson(db, phb);
      await importSpellsJson(db, tce);

      final rows = await db.select(db.spells).get();
      expect(rows, hasLength(2));
      expect(rows.where((spell) => spell.source == 'PHB'), hasLength(1));
      expect(rows.where((spell) => spell.source == 'TCE'), hasLength(1));

      final decoded =
          jsonDecode(await exportDatabaseBackupJson(db))
              as Map<String, dynamic>;
      final spells =
          (decoded['tables'] as Map<String, dynamic>)['spells']
              as List<dynamic>;
      expect(spells, hasLength(2));
      expect(
        jsonDecode(
          (spells.firstWhere((spell) => spell['source'] == 'TCE')
                  as Map<String, dynamic>)['data']
              as String,
        ),
        isA<Map<String, dynamic>>(),
      );
      expect(
        jsonDecode(
          (spells.firstWhere((spell) => spell['source'] == 'TCE')
                  as Map<String, dynamic>)['data']
              as String,
        )['hasFluff'],
        isTrue,
      );

      await importDatabaseBackupJson(db, jsonEncode(decoded));
      expect(await db.select(db.spells).get(), hasLength(2));
    },
  );

  test(
    'non-SRD definitions replace SRD and survive later SRD seeding',
    () async {
      const phb = '''
      {"spell":[{"name":"Shared Spell","source":"PHB","level":2,
        "school":"A","entries":["PHB definition."]}]}
    ''';
      const srd = '''
      {"spell":[{"name":"Shared Spell","source":"SRD","level":1,
        "school":"E","entries":["SRD definition."]}]}
    ''';

      await importSpellsJson(db, srd);
      var spells = await db.select(db.spells).get();
      expect(spells, hasLength(1));
      expect(spells.single.source, 'SRD');
      expect(jsonDecode(spells.single.data)['entries'], ['SRD definition.']);

      await importSpellsJson(db, phb);
      await importSpellsJson(db, srd);
      spells = await db.select(db.spells).get();
      expect(spells, hasLength(1));
      expect(spells.single.source, 'PHB');
      expect(jsonDecode(spells.single.data)['entries'], ['PHB definition.']);
    },
  );

  test(
    'rejects invalid spell records without partially importing them',
    () async {
      const json = '''
      {"spell":[
        {"name":"Valid","source":"SRD","level":1,"school":"A"},
        {"name":"Invalid"}
      ]}
    ''';

      await expectLater(
        importSpellsJson(db, json),
        throwsA(isA<FormatException>()),
      );
      expect(await db.select(db.spells).get(), isEmpty);
    },
  );
}

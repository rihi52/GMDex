import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmdex/database/database.dart';
import 'package:gmdex/database/database_backup.dart';
import 'package:gmdex/database/encounter_writer.dart';
import 'package:gmdex/database/spell_importer.dart';
import 'package:gmdex/database/spell_writer.dart';
import 'package:gmdex/models/combat.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('round-trips the entire database in a portable JSON backup', () async {
    final playerId = await db
        .into(db.players)
        .insert(
          PlayersCompanion.insert(
            pName: 'Ravi',
            pClass: 'Rogue',
            pLevel: const Value(5),
            pHitPoints: const Value(38),
            pArmorClass: const Value(15),
            pOriginalCampaign: const Value('Finndalin'),
            pNotes: const Value('Scout'),
          ),
        );
    final creatureId = await db
        .into(db.creatures)
        .insert(
          CreaturesCompanion.insert(
            name: 'Goblin',
            source: const Value('Test'),
            armorClass: const Value(13),
            armorClassType: const Value('plus PB (natural armor)'),
            hitPoints: const Value(7),
            hitPointFormula: const Value('+ seven times their level'),
            challengeRating: const Value('1/4'),
          ),
        );
    await db
        .into(db.notes)
        .insert(
          NotesCompanion.insert(creatureId: creatureId, body: 'Tracks nearby'),
        );
    await saveEncounter(
      db,
      Encounter(
        name: 'Ambush',
        currentTurnIndex: 1,
        hasStarted: true,
        encounterNotes: 'At dusk',
        combatants: [
          Combatant(
            name: 'Ravi',
            isPlayer: true,
            playerId: playerId,
            maxHitPoints: 38,
            currentHitPoints: 31,
            initiative: 14,
            quantity: 1,
          ),
          Combatant(
            name: 'Goblin',
            isPlayer: false,
            creatureId: creatureId,
            maxHitPoints: 7,
            currentHitPoints: 5,
            initiative: 12,
            quantity: 1,
            isPoisoned: true,
          ),
        ],
      ),
    );

    final json = await exportDatabaseBackupJson(db);
    final decoded = jsonDecode(json) as Map<String, dynamic>;
    expect(decoded['format'], databaseBackupFormat);
    expect(decoded['version'], databaseBackupVersion);
    expect(DateTime.parse(decoded['exportedAt'] as String).isUtc, isTrue);
    final tables = decoded['tables'] as Map<String, dynamic>;
    expect(tables, isNot(contains('database_metadata')));
    expect((tables['notes'] as List).single['created_at'], isA<String>());
    final backedUpCreature =
        (tables['creatures'] as List).single as Map<String, dynamic>;
    expect(backedUpCreature['id'], creatureId);
    expect(backedUpCreature['armor_class'], 13);
    expect(backedUpCreature['armor_class_type'], 'plus PB (natural armor)');
    expect(backedUpCreature['hit_points'], 7);
    expect(backedUpCreature['hit_point_formula'], '+ seven times their level');

    await db
        .into(db.players)
        .insert(PlayersCompanion.insert(pName: 'Temporary', pClass: 'Wizard'));

    final result = await importDatabaseBackupJson(db, json);

    expect(result.playerCount, 1);
    expect(result.encounterCount, 1);
    final players = await db.select(db.players).get();
    expect(players, hasLength(1));
    expect(players.single.pName, 'Ravi');
    expect(players.single.pNotes, 'Scout');
    expect((await db.select(db.creatures).get()).single.name, 'Goblin');
    final restoredCreature = (await db.select(db.creatures).get()).single;
    expect(restoredCreature.armorClass, 13);
    expect(restoredCreature.armorClassType, 'plus PB (natural armor)');
    expect(restoredCreature.hitPoints, 7);
    expect(restoredCreature.hitPointFormula, '+ seven times their level');
    expect((await db.select(db.notes).get()).single.body, 'Tracks nearby');

    final encounters = await db.select(db.encounters).get();
    expect(encounters.single.name, 'Ambush');
    expect(encounters.single.hasStarted, isTrue);
    expect(encounters.single.notes, 'At dusk');
    final encounterPlayers = await db.select(db.encounterPlayers).get();
    expect(encounterPlayers.single.currentHitpoints, 31);
    expect(encounterPlayers.single.isTurn, isFalse);
    final encounterCreatures = await db.select(db.encounterCreatures).get();
    expect(encounterCreatures.single.currentHitpoints, 5);
    expect(encounterCreatures.single.isPoisoned, isTrue);
    expect(encounterCreatures.single.isTurn, isTrue);
  });

  test('requires confirmation before replacing a newer database', () async {
    await db
        .into(db.players)
        .insert(PlayersCompanion.insert(pName: 'Keep me', pClass: 'Bard'));
    final decoded =
        jsonDecode(await exportDatabaseBackupJson(db)) as Map<String, dynamic>;
    final pendingAt = DateTime.utc(2000);
    decoded['exportedAt'] = pendingAt.toIso8601String();
    final json = jsonEncode(decoded);
    final currentAt = await db.getDatabaseCreatedAt();

    await expectLater(
      importDatabaseBackupJson(db, json),
      throwsA(isA<DatabaseBackupOlderThanCurrentException>()),
    );

    final cancelled = await importDatabaseBackupJson(
      db,
      json,
      confirmOlderBackup: (current, pending) async {
        expect(current, currentAt);
        expect(pending, pendingAt);
        return false;
      },
    );
    expect(cancelled.cancelled, isTrue);
    expect((await db.select(db.players).get()).single.pName, 'Keep me');

    final imported = await importDatabaseBackupJson(
      db,
      json,
      confirmOlderBackup: (_, _) async => true,
    );
    expect(imported.cancelled, isFalse);
    expect(await db.getDatabaseCreatedAt(), pendingAt);
    final importedAt = await db
        .customSelect(
          "SELECT value FROM database_metadata WHERE key = 'last_imported_at'",
        )
        .getSingle();
    expect(DateTime.parse(importedAt.read<String>('value')).isUtc, isTrue);
  });

  test('imports older backups without exportedAt for compatibility', () async {
    final decoded =
        jsonDecode(await exportDatabaseBackupJson(db)) as Map<String, dynamic>
          ..remove('exportedAt');

    final result = await importDatabaseBackupJson(db, jsonEncode(decoded));

    expect(result.cancelled, isFalse);
    expect(await db.getDatabaseCreatedAt(), isNotNull);
  });

  test('round-trips spell catalog data and accepts older backups', () async {
    const spellJson = '''
      {
        "spell": [{
          "name": "Example Spell",
          "source": "SRD",
          "level": 1,
          "school": "A",
          "entries": ["Full spell description."]
        }]
      }
    ''';
    await importSpellsJson(db, spellJson);
    final spell = await db.select(db.spells).getSingle();
    await saveSpellNotes(db, spell.id, '  Find this in the tower.  ');

    final decoded =
        jsonDecode(await exportDatabaseBackupJson(db)) as Map<String, dynamic>;
    final tables = decoded['tables'] as Map<String, dynamic>;
    final backedUpSpells = tables['spells'] as List<dynamic>;
    expect(backedUpSpells, hasLength(1));
    expect(
      jsonDecode(backedUpSpells.single['data'] as String),
      jsonDecode(spellJson)['spell'][0],
    );
    expect(backedUpSpells.single['notes'], 'Find this in the tower.');

    await importDatabaseBackupJson(db, jsonEncode(decoded));
    expect(
      (await db.select(db.spells).getSingle()).notes,
      'Find this in the tower.',
    );

    final oldBackup = Map<String, dynamic>.from(decoded)
      ..['databaseSchemaVersion'] = db.schemaVersion - 1;
    final oldTables = Map<String, dynamic>.from(tables)..remove('spells');
    oldBackup['tables'] = oldTables;
    final result = await importDatabaseBackupJson(db, jsonEncode(oldBackup));

    expect(result.playerCount, 0);
    expect(await db.select(db.spells).get(), isEmpty);
  });

  test('restores legacy duplicate spell rows with non-SRD priority', () async {
    const spellJson = '''
      {"spell":[{"name":"Shared Spell","source":"SRD","level":1,
        "school":"E","entries":["SRD version."]}]}
    ''';
    await importSpellsJson(db, spellJson);

    final decoded =
        jsonDecode(await exportDatabaseBackupJson(db)) as Map<String, dynamic>;
    decoded['databaseSchemaVersion'] = 16;
    final tables = decoded['tables'] as Map<String, dynamic>;
    final spells = tables['spells'] as List<dynamic>;
    final phbSpell = Map<String, dynamic>.from(spells.single as Map)
      ..['id'] = 2
      ..['source'] = 'PHB'
      ..['data'] = jsonEncode({
        'name': 'Shared Spell',
        'source': 'PHB',
        'level': 2,
        'school': 'A',
        'entries': ['PHB version.'],
      });
    spells.add(phbSpell);

    await importDatabaseBackupJson(db, jsonEncode(decoded));

    final restored = await db.select(db.spells).getSingle();
    expect(restored.source, 'PHB');
    expect(jsonDecode(restored.data)['entries'], ['PHB version.']);
  });

  test(
    'rolls back the replacement when a backup contains invalid rows',
    () async {
      await db
          .into(db.players)
          .insert(PlayersCompanion.insert(pName: 'Keep me', pClass: 'Bard'));
      final decoded =
          jsonDecode(await exportDatabaseBackupJson(db))
              as Map<String, dynamic>;
      final tables = decoded['tables'] as Map<String, dynamic>;
      final players = tables['players'] as List<dynamic>;
      players.add(Map<String, dynamic>.from(players.single as Map));

      await expectLater(
        importDatabaseBackupJson(db, jsonEncode(decoded)),
        throwsA(anything),
      );

      final playersAfterFailure = await db.select(db.players).get();
      expect(playersAfterFailure, hasLength(1));
      expect(playersAfterFailure.single.pName, 'Keep me');
    },
  );
}

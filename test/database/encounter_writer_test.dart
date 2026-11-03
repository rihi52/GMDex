import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmdex/database/database.dart';
import 'package:gmdex/database/encounter_writer.dart';
import 'package:gmdex/models/combat.dart';

void main() {
  late AppDatabase db;
  late int playerId;
  late int creatureId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    playerId = await db
        .into(db.players)
        .insert(PlayersCompanion.insert(pName: 'Ravi', pClass: 'Rogue'));
    creatureId = await db
        .into(db.creatures)
        .insert(
          CreaturesCompanion.insert(name: 'Goblin', hitPoints: const Value(7)),
        );
  });

  tearDown(() async {
    await db.close();
  });

  test('saves encounter details and player and creature combatants', () async {
    final encounter = Encounter(
      name: 'Goblin ambush',
      currentTurnIndex: 0,
      encounterNotes: 'At the bridge',
      combatants: [
        Combatant(
          name: 'Ravi',
          isPlayer: true,
          currentHitPoints: 20,
          maxHitPoints: 20,
          initiative: 12,
          quantity: 1,
          playerId: playerId,
          isBlinded: true,
          exhaustionLevel: 2,
          isPoisoned: true,
        ),
        Combatant(
          name: 'Goblin Captain',
          isPlayer: false,
          currentHitPoints: 7,
          maxHitPoints: 7,
          initiative: 8,
          quantity: 2,
          creatureId: creatureId,
          isCharmed: true,
          exhaustionLevel: 3,
          isRestrained: true,
          isUnmasked: true,
        ),
      ],
    );

    final encounterId = await saveEncounter(db, encounter);
    final savedEncounter = await (db.select(
      db.encounters,
    )..where((row) => row.id.equals(encounterId))).getSingle();
    final savedPlayer = await db.select(db.encounterPlayers).getSingle();
    final savedCreatures = await db.select(db.encounterCreatures).get();

    expect(savedEncounter.name, 'Goblin ambush');
    expect(savedEncounter.notes, 'At the bridge');
    expect(savedPlayer.encounterId, encounterId);
    expect(savedPlayer.playerId, playerId);
    expect(savedPlayer.initiative, 12);
    expect(savedPlayer.quantity, 1);
    expect(savedPlayer.currentHitpoints, 20);
    expect(savedPlayer.isBlinded, isTrue);
    expect(savedPlayer.exhaustionLevel, 2);
    expect(savedPlayer.isPoisoned, isTrue);
    expect(savedCreatures, hasLength(2));
    for (final savedCreature in savedCreatures) {
      expect(savedCreature.encounterId, encounterId);
      expect(savedCreature.creatureId, creatureId);
      expect(savedCreature.initiative, 8);
      expect(savedCreature.currentHitpoints, 7);
      expect(savedCreature.isCharmed, isTrue);
      expect(savedCreature.exhaustionLevel, 3);
      expect(savedCreature.isRestrained, isTrue);
      expect(savedCreature.isUnmasked, isTrue);
      expect(savedCreature.nameOverride, 'Goblin Captain');
    }

    final loaded = await loadEncounter(db, encounterId);
    final loadedPlayer = loaded!.combatants.singleWhere((c) => c.isPlayer);
    final loadedCreatures = loaded.combatants.where((c) => !c.isPlayer);
    expect(loadedPlayer.isBlinded, isTrue);
    expect(loadedPlayer.exhaustionLevel, 2);
    expect(loadedPlayer.isPoisoned, isTrue);
    for (final creature in loadedCreatures) {
      expect(creature.isCharmed, isTrue);
      expect(creature.exhaustionLevel, 3);
      expect(creature.isRestrained, isTrue);
      expect(creature.isUnmasked, isTrue);
      expect(creature.name, 'Goblin Captain');
    }
    expect(
      (await (db.select(
        db.creatures,
      )..where((row) => row.id.equals(creatureId))).getSingle()).name,
      'Goblin',
    );
  });

  test('saves and recalculates total and adjusted encounter XP', () async {
    await (db.update(db.players)
          ..where((player) => player.pId.equals(playerId)))
        .write(PlayersCompanion(pLevel: const Value(5)));
    await (db.update(db.creatures)
          ..where((creature) => creature.id.equals(creatureId)))
        .write(CreaturesCompanion(challengeRating: const Value('1/4')));

    final encounter = Encounter(
      name: 'XP tracking',
      currentTurnIndex: 0,
      combatants: [
        Combatant(
          name: 'Ravi',
          isPlayer: true,
          maxHitPoints: 20,
          initiative: 12,
          quantity: 1,
          playerId: playerId,
        ),
        Combatant(
          name: 'Goblin',
          isPlayer: false,
          maxHitPoints: 7,
          initiative: 8,
          quantity: 1,
          creatureId: creatureId,
        ),
      ],
    );

    final id = await saveEncounter(db, encounter);
    var saved = await (db.select(
      db.encounters,
    )..where((row) => row.id.equals(id))).getSingle();
    expect(saved.totalXp, 50);
    expect(saved.adjustedXp, 75);

    await (db.update(db.creatures)
          ..where((creature) => creature.id.equals(creatureId)))
        .write(CreaturesCompanion(xpOverride: const Value(100)));
    await saveEncounter(db, encounter, existingId: id);

    saved = await (db.select(
      db.encounters,
    )..where((row) => row.id.equals(id))).getSingle();
    expect(saved.totalXp, 100);
    expect(saved.adjustedXp, 150);
  });

  test('saves and restores the active combatant turn', () async {
    final encounterId = await saveEncounter(
      db,
      Encounter(
        name: 'Turn tracking',
        currentTurnIndex: 1,
        combatants: [
          Combatant(
            name: 'Ravi',
            isPlayer: true,
            currentHitPoints: 20,
            maxHitPoints: 20,
            initiative: 12,
            quantity: 1,
            playerId: playerId,
          ),
          Combatant(
            name: 'Goblin',
            isPlayer: false,
            currentHitPoints: 7,
            maxHitPoints: 7,
            initiative: 8,
            quantity: 2,
            creatureId: creatureId,
          ),
        ],
      ),
    );

    final savedPlayer = await db.select(db.encounterPlayers).getSingle();
    final savedCreatures = await db.select(db.encounterCreatures).get();
    expect(savedPlayer.isTurn, isFalse);
    expect(savedCreatures.map((creature) => creature.isTurn), [true, false]);

    final loaded = await loadEncounter(db, encounterId);
    expect(loaded!.currentTurnIndex, 1);
    expect(loaded.combatants.map((combatant) => combatant.isTurn), [
      false,
      true,
      false,
    ]);
  });

  test('loads and updates a saved encounter and its combatants', () async {
    final id = await saveEncounter(
      db,
      Encounter(
        name: 'Before',
        currentTurnIndex: 0,
        encounterNotes: 'Original notes',
        combatants: [
          Combatant(
            name: 'Ravi',
            isPlayer: true,
            currentHitPoints: 20,
            maxHitPoints: 20,
            initiative: 12,
            quantity: 1,
            playerId: playerId,
          ),
        ],
      ),
    );

    final loaded = await loadEncounter(db, id);
    expect(loaded, isNotNull);
    expect(loaded!.id, id);
    expect(loaded.name, 'Before');
    expect(loaded.encounterNotes, 'Original notes');
    expect(loaded.combatants.single.name, 'Ravi');
    expect(loaded.combatants.single.initiative, 12);

    await saveEncounter(
      db,
      Encounter(
        id: id,
        name: 'After',
        currentTurnIndex: 0,
        encounterNotes: 'Updated notes',
        combatants: [
          Combatant(
            name: 'Goblin',
            isPlayer: false,
            currentHitPoints: 7,
            maxHitPoints: 7,
            initiative: 8,
            quantity: 2,
            creatureId: creatureId,
          ),
        ],
      ),
      existingId: id,
    );

    final updated = await (db.select(
      db.encounters,
    )..where((row) => row.id.equals(id))).getSingle();
    expect(updated.name, 'After');
    expect(updated.notes, 'Updated notes');
    expect(await db.select(db.encounterPlayers).get(), isEmpty);
    final creatureLinks = await db.select(db.encounterCreatures).get();
    expect(creatureLinks, hasLength(2));
    expect(
      creatureLinks.map((link) => link.creatureId),
      everyElement(creatureId),
    );
    expect(creatureLinks.map((link) => link.initiative), everyElement(8));
    expect(creatureLinks.map((link) => link.currentHitpoints), everyElement(7));

    final loadedEncounter = await loadEncounter(db, id);
    expect(loadedEncounter!.combatants, hasLength(2));
    expect(
      loadedEncounter.combatants.map((combatant) => combatant.quantity),
      everyElement(1),
    );
    expect(
      loadedEncounter.combatants.map((combatant) => combatant.currentHitPoints),
      everyElement(7),
    );
  });

  test('persists player current HP, initiative, and quantity', () async {
    final id = await saveEncounter(
      db,
      Encounter(
        name: 'Player encounter',
        currentTurnIndex: 0,
        combatants: [
          Combatant(
            name: 'Ravi',
            isPlayer: true,
            currentHitPoints: 13,
            maxHitPoints: 20,
            initiative: 12,
            quantity: 1,
            playerId: playerId,
          ),
        ],
      ),
    );

    await saveEncounter(
      db,
      Encounter(
        name: 'Player encounter',
        currentTurnIndex: 0,
        encounterNotes: 'Updated during combat',
        combatants: [
          Combatant(
            name: 'Ravi',
            isPlayer: true,
            currentHitPoints: 8,
            maxHitPoints: 20,
            initiative: 17,
            quantity: 2,
            playerId: playerId,
          ),
        ],
      ),
      existingId: id,
    );

    final link = await db.select(db.encounterPlayers).getSingle();
    expect(link.currentHitpoints, 8);
    expect(link.initiative, 17);
    expect(link.quantity, 2);

    final loaded = await loadEncounter(db, id);
    expect(loaded!.encounterNotes, 'Updated during combat');
    expect(loaded.combatants.single.currentHitPoints, 8);
    expect(loaded.combatants.single.initiative, 17);
    expect(loaded.combatants.single.quantity, 2);
  });

  test('saves encounter notes and deletes encounter with combatants', () async {
    final id = await saveEncounter(
      db,
      Encounter(
        name: 'To delete',
        currentTurnIndex: 0,
        combatants: [
          Combatant(
            name: 'Goblin',
            isPlayer: false,
            currentHitPoints: 7,
            maxHitPoints: 7,
            initiative: 8,
            quantity: 1,
            creatureId: creatureId,
          ),
        ],
      ),
    );

    await saveEncounterNotes(db, id, '  Updated notes  ');
    final row = await (db.select(
      db.encounters,
    )..where((encounter) => encounter.id.equals(id))).getSingle();
    expect(row.notes, 'Updated notes');

    expect(await deleteEncounter(db, id), 1);
    expect(await db.select(db.encounters).get(), isEmpty);
    expect(await db.select(db.encounterCreatures).get(), isEmpty);
  });

  test(
    'rolls back encounter insert when a combatant has no database id',
    () async {
      final encounter = Encounter(
        name: 'Invalid encounter',
        currentTurnIndex: 0,
        combatants: [
          Combatant(
            name: 'Ravi',
            isPlayer: true,
            currentHitPoints: 20,
            maxHitPoints: 20,
            initiative: 12,
            quantity: 1,
          ),
        ],
      );

      await expectLater(saveEncounter(db, encounter), throwsArgumentError);
      expect(await db.select(db.encounters).get(), isEmpty);
    },
  );

  test(
    'expands saved creature quantities during the version 4 upgrade',
    () async {
      await db.close();
      db = AppDatabase(
        NativeDatabase.memory(
          setup: (sqliteDb) {
            sqliteDb.execute('''
            CREATE TABLE players (
              p_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
              p_hit_points INTEGER
            )
          ''');
            sqliteDb.execute('''
            CREATE TABLE encounters (
              id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              notes TEXT NOT NULL,
              created_at INTEGER NOT NULL DEFAULT CURRENT_TIMESTAMP,
              updated_at INTEGER NOT NULL DEFAULT CURRENT_TIMESTAMP
            )
          ''');
            sqliteDb.execute('''
            CREATE TABLE creatures (
              id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
              hit_points INTEGER
            )
          ''');
            sqliteDb.execute('''
            CREATE TABLE encounter_creatures (
              id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
              encounter_id INTEGER NOT NULL,
              creature_id INTEGER NOT NULL,
              initiative INTEGER NOT NULL,
              quantity INTEGER NOT NULL,
              created_at INTEGER NOT NULL DEFAULT CURRENT_TIMESTAMP,
              updated_at INTEGER NOT NULL DEFAULT CURRENT_TIMESTAMP
            )
          ''');
            sqliteDb.execute('''
            CREATE TABLE encounter_players (
              id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
              encounter_id INTEGER NOT NULL,
              player_id INTEGER NOT NULL,
              initiative INTEGER NOT NULL,
              quantity INTEGER NOT NULL,
              created_at INTEGER NOT NULL
                DEFAULT (CAST(strftime('%s', 'now') AS INTEGER) * 1000),
              updated_at INTEGER NOT NULL
                DEFAULT (CAST(strftime('%s', 'now') AS INTEGER) * 1000)
            )
          ''');
            sqliteDb.execute('''
            CREATE INDEX idx_encounter_creature_encounter_initiative
            ON encounter_creatures (encounter_id, initiative)
          ''');
            sqliteDb.execute('''
            CREATE INDEX idx_encounter_creature_creature
            ON encounter_creatures (creature_id)
          ''');
            sqliteDb.execute(
              "INSERT INTO encounters (id, name, notes) VALUES (1, 'Old', '')",
            );
            sqliteDb.execute(
              'INSERT INTO creatures (id, hit_points) VALUES (1, 11)',
            );
            sqliteDb.execute('''
            INSERT INTO encounter_creatures
              (id, encounter_id, creature_id, initiative, quantity)
            VALUES (1, 1, 1, 9, 2)
          ''');
            sqliteDb.execute('PRAGMA user_version = 4');
          },
        ),
      );

      final upgraded = await db.select(db.encounterCreatures).get();
      expect(upgraded, hasLength(2));
      for (final creature in upgraded) {
        expect(creature.encounterId, 1);
        expect(creature.creatureId, 1);
        expect(creature.initiative, 9);
        expect(creature.currentHitpoints, 11);
      }

      final columns = await db
          .customSelect('PRAGMA table_info(encounter_creatures)')
          .get();
      expect(
        columns.map((column) => column.read<String>('name')),
        contains('is_blinded'),
      );
      expect(
        columns.map((column) => column.read<String>('name')),
        contains('exhaustion_level'),
      );
      expect(
        columns.map((column) => column.read<String>('name')),
        contains('current_hitpoints'),
      );
      expect(
        columns.map((column) => column.read<String>('name')),
        contains('is_turn'),
      );
      expect(
        columns.map((column) => column.read<String>('name')),
        isNot(contains('quantity')),
      );

      final playerStatuses = await db
          .customSelect('PRAGMA table_info(encounter_players)')
          .get();
      expect(
        playerStatuses.map((column) => column.read<String>('name')),
        containsAll([
          'is_blinded',
          'exhaustion_level',
          'is_unconscious',
          'is_turn',
        ]),
      );
    },
  );

  test('upgrades a version 2 database with encounter tables', () async {
    await db.close();
    db = AppDatabase(
      NativeDatabase.memory(
        setup: (sqliteDb) {
          sqliteDb.execute('''
            CREATE TABLE players (
              p_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
              p_name TEXT NOT NULL,
              p_class TEXT NOT NULL,
              p_level INTEGER,
              p_hit_points INTEGER,
              p_armor_class INTEGER,
              p_original_campaign TEXT
            )
          ''');
          sqliteDb.execute('PRAGMA user_version = 2');
        },
      ),
    );

    expect(await db.select(db.encounters).get(), isEmpty);
    expect(await db.select(db.encounterPlayers).get(), isEmpty);
    expect(await db.select(db.encounterCreatures).get(), isEmpty);
    final indexes = await db.customSelect('PRAGMA index_list(players)').get();
    expect(
      indexes.map((row) => row.read<String>('name')),
      contains('idx_player_name'),
    );
  });
}

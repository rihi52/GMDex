import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmdex/database/database.dart';
import 'package:gmdex/database/player_writer.dart';
import 'package:gmdex/models/player_draft.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test(
    'creates a player and stores optional values as null when blank',
    () async {
      final id = await savePlayer(
        db,
        const PlayerDraft(
          name: '  Ravi  ',
          characterClass: '  Rogue ',
          originalCampaign: '  ',
        ),
      );

      final player = await (db.select(
        db.players,
      )..where((row) => row.pId.equals(id))).getSingle();
      expect(player.pName, 'Ravi');
      expect(player.pClass, 'Rogue');
      expect(player.pLevel, isNull);
      expect(player.pPassivePerception, isNull);
      expect(player.pOriginalCampaign, isNull);
    },
  );

  test('updates player fields and notes', () async {
    final id = await db
        .into(db.players)
        .insert(PlayersCompanion.insert(pName: 'Ravi', pClass: 'Rogue'));

    await savePlayer(
      db,
      const PlayerDraft(
        name: 'Ravi',
        characterClass: 'Rogue',
        level: 5,
        hitPoints: 38,
        armorClass: 15,
        passivePerception: 16,
        originalCampaign: 'Finndalin',
      ),
      existingId: id,
    );
    await savePlayerNotes(db, id, 'Party scout');

    final player = await (db.select(
      db.players,
    )..where((row) => row.pId.equals(id))).getSingle();
    expect(player.pLevel, 5);
    expect(player.pHitPoints, 38);
    expect(player.pArmorClass, 15);
    expect(player.pPassivePerception, 16);
    expect(player.pOriginalCampaign, 'Finndalin');
    expect(player.pNotes, 'Party scout');

    await savePlayerNotes(db, id, '  ');
    final cleared = await (db.select(
      db.players,
    )..where((row) => row.pId.equals(id))).getSingle();
    expect(cleared.pNotes, isNull);
  });

  test(
    'adds passive perception when upgrading a version 11 database',
    () async {
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
              p_original_campaign TEXT,
              p_notes TEXT
            )
          ''');
            sqliteDb.execute(
              "INSERT INTO players (p_name, p_class, p_hit_points) "
              "VALUES ('Ravi', 'Rogue', 24)",
            );
            sqliteDb.execute('PRAGMA user_version = 11');
          },
        ),
      );

      final player = await db.select(db.players).getSingle();
      expect(player.pName, 'Ravi');
      expect(player.pHitPoints, 24);
      expect(player.pPassivePerception, isNull);
    },
  );

  test('adds player notes when upgrading a version 3 database', () async {
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
            "INSERT INTO players (p_name, p_class, p_hit_points) VALUES ('Ravi', 'Rogue', 24)",
          );
          sqliteDb.execute(
            "INSERT INTO encounters (id, name, notes) VALUES (1, 'Old', '')",
          );
          sqliteDb.execute('''
            INSERT INTO encounter_players
              (id, encounter_id, player_id, initiative, quantity)
            VALUES (1, 1, 1, 12, 1)
          ''');
          sqliteDb.execute('PRAGMA user_version = 3');
        },
      ),
    );

    final player = await db.select(db.players).getSingle();
    expect(player.pName, 'Ravi');
    expect(player.pNotes, isNull);
    final encounterPlayer = await db.select(db.encounterPlayers).getSingle();
    expect(encounterPlayer.currentHitpoints, 24);
  });
}

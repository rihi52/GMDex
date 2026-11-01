import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmdex/database/database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test(
    'clears rows while retaining tables and allowing future inserts',
    () async {
      final playerId = await db
          .into(db.players)
          .insert(PlayersCompanion.insert(pName: 'Ravi', pClass: 'Rogue'));
      final creatureId = await db
          .into(db.creatures)
          .insert(CreaturesCompanion.insert(name: 'Goblin'));
      await db
          .into(db.notes)
          .insert(
            NotesCompanion.insert(creatureId: creatureId, body: 'Tracks'),
          );
      final encounterId = await db
          .into(db.encounters)
          .insert(EncountersCompanion.insert(name: 'Ambush', notes: 'Bridge'));
      await db
          .into(db.encounterPlayers)
          .insert(
            EncounterPlayersCompanion.insert(
              encounterId: encounterId,
              playerId: playerId,
              initiative: 12,
              quantity: 1,
            ),
          );

      final tablesBefore = await db
          .customSelect(
            "SELECT name FROM sqlite_master WHERE type = 'table' "
            "AND name NOT LIKE 'sqlite_%' ORDER BY name",
          )
          .map((row) => row.read<String>('name'))
          .get();

      await db.clearData();

      final tablesAfter = await db
          .customSelect(
            "SELECT name FROM sqlite_master WHERE type = 'table' "
            "AND name NOT LIKE 'sqlite_%' ORDER BY name",
          )
          .map((row) => row.read<String>('name'))
          .get();
      expect(tablesAfter, tablesBefore);
      expect(await db.select(db.players).get(), isEmpty);
      expect(await db.select(db.creatures).get(), isEmpty);
      expect(await db.select(db.notes).get(), isEmpty);
      expect(await db.select(db.encounters).get(), isEmpty);
      expect(await db.select(db.encounterPlayers).get(), isEmpty);

      final newPlayerId = await db
          .into(db.players)
          .insert(PlayersCompanion.insert(pName: 'Glimm', pClass: 'Monk'));
      expect(newPlayerId, 1);
    },
  );
}

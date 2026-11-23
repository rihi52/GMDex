import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmdex/database/database.dart';
import 'package:gmdex/database/database_backup.dart';

void main() {
  test('repairs persisted bestiary text and restores old backups', () async {
    final directory = await Directory.systemTemp.createTemp('gmdex-recharge-');
    final file = File('${directory.path}${Platform.pathSeparator}test.db');
    var db = AppDatabase(NativeDatabase(file));
    try {
      final creatureId = await db
          .into(db.creatures)
          .insert(
            CreaturesCompanion.insert(
              name: 'Dragon',
              armorClassType: const Value('armor {@recharge}'),
              damageResistances: const Value('fire {@recharge}'),
            ),
          );
      await db
          .into(db.creatureActions)
          .insert(
            CreatureActionsCompanion.insert(
              creatureId: creatureId,
              name: 'Breath {@recharge}',
              description: '{@recharge} and {@recharge 5} and {@recharge}',
              sortOrder: 0,
              kind: 'action',
            ),
          );
      await db
          .into(db.creatureTraits)
          .insert(
            CreatureTraitsCompanion.insert(
              creatureId: creatureId,
              name: 'Trait {@recharge}',
              description: 'Trait text {@recharge}',
              sortOrder: 0,
            ),
          );
      final spellcastingId = await db
          .into(db.creatureSpellcastings)
          .insert(
            CreatureSpellcastingsCompanion.insert(
              creatureId: creatureId,
              name: 'Magic {@recharge}',
              headerText: const Value('Header {@recharge}'),
              footerText: const Value('Footer {@recharge}'),
            ),
          );
      await db
          .into(db.creatureSpells)
          .insert(
            CreatureSpellsCompanion.insert(
              spellcastingId: spellcastingId,
              spellName: 'Spell {@recharge}',
              sortOrder: 0,
            ),
          );
      final groupId = await db
          .into(db.legendaryGroups)
          .insert(
            LegendaryGroupsCompanion.insert(name: 'Group', source: 'Test'),
          );
      await db
          .into(db.legendaryGroupEntries)
          .insert(
            LegendaryGroupEntriesCompanion.insert(
              groupId: groupId,
              section: 'lair',
              kind: 'entry',
              title: const Value('Title {@recharge}'),
              body: 'Body {@recharge}',
              sortOrder: 0,
            ),
          );
      await db.customStatement(
        'INSERT INTO creature_senses (creature_id, sense) VALUES (?, ?), (?, ?)',
        [creatureId, '{@recharge}', creatureId, 'Recharge 6'],
      );
      await db.customStatement(
        'INSERT INTO creature_languages (creature_id, language) VALUES (?, ?)',
        [creatureId, '{@recharge}'],
      );
      await db.customStatement(
        'INSERT INTO creature_environments (creature_id, environment) VALUES (?, ?)',
        [creatureId, '{@recharge}'],
      );
      await db
          .into(db.notes)
          .insert(
            NotesCompanion.insert(creatureId: creatureId, body: '{@recharge}'),
          );
      await db
          .into(db.players)
          .insert(
            PlayersCompanion.insert(
              pName: 'Player',
              pClass: 'Wizard',
              pNotes: const Value('{@recharge}'),
            ),
          );
      await db
          .into(db.spells)
          .insert(
            SpellsCompanion.insert(
              name: 'Spell',
              source: 'Test',
              level: 1,
              school: 'A',
              data: '{"entries":["{@recharge}"]}',
            ),
          );
      final backup = await exportDatabaseBackupJson(db);
      final schemaVersion = db.schemaVersion;
      await db.close();

      db = AppDatabase(NativeDatabase(file));
      await db.repairBestiaryRechargeTags();
      await db.repairBestiaryRechargeTags();

      Future<void> verify() async {
        expect(db.schemaVersion, schemaVersion);
        final creature = await db.select(db.creatures).getSingle();
        expect(creature.id, creatureId);
        expect(creature.armorClassType, 'armor Recharge 6');
        expect(creature.damageResistances, 'fire Recharge 6');
        final action = await db.select(db.creatureActions).getSingle();
        expect(action.name, 'Breath Recharge 6');
        expect(
          action.description,
          'Recharge 6 and {@recharge 5} and Recharge 6',
        );
        final trait = await db.select(db.creatureTraits).getSingle();
        expect(trait.name, 'Trait Recharge 6');
        expect(trait.description, 'Trait text Recharge 6');
        final spellcasting = await db
            .select(db.creatureSpellcastings)
            .getSingle();
        expect(spellcasting.name, 'Magic Recharge 6');
        expect(spellcasting.headerText, 'Header Recharge 6');
        expect(spellcasting.footerText, 'Footer Recharge 6');
        expect(
          (await db.select(db.creatureSpells).getSingle()).spellName,
          'Spell Recharge 6',
        );
        final groupEntry = await db
            .select(db.legendaryGroupEntries)
            .getSingle();
        expect(groupEntry.title, 'Title Recharge 6');
        expect(groupEntry.body, 'Body Recharge 6');
        expect(
          (await db.select(db.creatureSenses).get()).map((row) => row.sense),
          ['Recharge 6'],
        );
        expect(
          (await db.select(db.creatureLanguages).getSingle()).language,
          'Recharge 6',
        );
        expect(
          (await db.select(db.creatureEnvironments).getSingle()).environment,
          'Recharge 6',
        );
        expect((await db.select(db.notes).getSingle()).body, '{@recharge}');
        expect((await db.select(db.players).getSingle()).pNotes, '{@recharge}');
        expect(
          (await db.select(db.spells).getSingle()).data,
          '{"entries":["{@recharge}"]}',
        );
      }

      await verify();
      await db.close();
      db = AppDatabase(NativeDatabase(file));
      await verify();

      await importDatabaseBackupJson(db, backup);
      await verify();
    } finally {
      await db.close();
      await directory.delete(recursive: true);
    }
  });

  test('rolls back the repair and reports database errors', () async {
    final db = AppDatabase(NativeDatabase.memory());
    try {
      final id = await db
          .into(db.creatures)
          .insert(CreaturesCompanion.insert(name: 'Dragon'));
      await db
          .into(db.creatureActions)
          .insert(
            CreatureActionsCompanion.insert(
              creatureId: id,
              name: '{@recharge}',
              description: '',
              sortOrder: 0,
              kind: 'action',
            ),
          );
      await db.customStatement('''
        CREATE TRIGGER reject_trait_repair BEFORE UPDATE ON creature_traits
        BEGIN SELECT RAISE(ABORT, 'repair failed'); END
      ''');
      await db
          .into(db.creatureTraits)
          .insert(
            CreatureTraitsCompanion.insert(
              creatureId: id,
              name: '{@recharge}',
              description: '',
              sortOrder: 0,
            ),
          );

      await expectLater(db.repairBestiaryRechargeTags(), throwsA(anything));
      expect(
        (await db.select(db.creatureActions).getSingle()).name,
        '{@recharge}',
      );
    } finally {
      await db.close();
    }
  });
}

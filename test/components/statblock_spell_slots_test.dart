import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmdex/components/statblock.dart';
import 'package:gmdex/components/statblock_edit.dart';
import 'package:gmdex/database/bestiary_importer.dart';
import 'package:gmdex/database/creature_mapper.dart';
import 'package:gmdex/database/creature_writer.dart';
import 'package:gmdex/database/database.dart';
import 'package:gmdex/models/creature.dart';
import 'package:gmdex/models/creature_draft.dart';

void main() {
  testWidgets('saves slot counts for leveled spells but not cantrips', (
    tester,
  ) async {
    final formKey = GlobalKey<FormState>();
    final draft = _creatureDraft();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: SpellCastingTile(creatureDraft: draft, onSaved: (_) {}),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Spellcasting'));
    await tester.pumpAndSettle();

    expect(find.text('Number of Spell Slots'), findsNWidgets(9));
    final firstSlotField = find
        .widgetWithText(TextFormField, 'Number of Spell Slots')
        .first;
    await tester.ensureVisible(firstSlotField);
    await tester.enterText(firstSlotField, '4');
    formKey.currentState!.save();

    expect(draft.spellCasting!.spells![0]!.slots, isNull);
    expect(draft.spellCasting!.spells![1]!.slots, 4);
  });

  testWidgets('prefills imported MM spell levels and slots', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await importBestiaryJson(db, _bestiaryJson);
    final row = await (db.select(
      db.creatures,
    )..where((row) => row.source.equals('MM'))).getSingle();
    final creature = (await loadCreature(db, row.id))!;
    Creature? submitted;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatblockEditorForm(
            creature: creature,
            isEditing: true,
            onSubmit: (value) => submitted = value,
          ),
        ),
      ),
    );
    final tile = find.text('Spellcasting');
    await tester.ensureVisible(tile);
    await tester.tap(tile);
    await tester.pumpAndSettle();

    final names = find.widgetWithText(
      TextFormField,
      'Spell Names (comma-separated)',
    );
    expect(tester.widget<TextFormField>(names.at(0)).initialValue, 'light');
    expect(
      tester.widget<TextFormField>(names.at(1)).initialValue,
      'shield, bless',
    );
    final slots = find.widgetWithText(TextFormField, 'Number of Spell Slots');
    expect(tester.widget<TextFormField>(slots.first).initialValue, '3');
    await tester.ensureVisible(slots.first);
    await tester.enterText(slots.first, '4');
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(submitted, isNotNull);
    await saveCreature(db, submitted!, existingId: row.id);
    final saved = (await loadCreature(db, row.id))!.spellCasting!;
    expect(saved.spells![1]!.slots, 4);
    expect(saved.innateSpell!['will'], ['detect magic']);
  });

  testWidgets('prefills and saves MPMM at-will and daily spells', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await importBestiaryJson(db, _bestiaryJson);
    final row = await (db.select(
      db.creatures,
    )..where((row) => row.source.equals('MPMM'))).getSingle();
    final creature = (await loadCreature(db, row.id))!;
    Creature? submitted;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatblockEditorForm(
            creature: creature,
            isEditing: true,
            onSubmit: (value) => submitted = value,
          ),
        ),
      ),
    );
    final tile = find.text('Innate Spellcasting');
    await tester.ensureVisible(tile);
    await tester.tap(tile);
    await tester.pumpAndSettle();

    final atWill = find.widgetWithText(
      TextFormField,
      'At will (comma-separated)',
    );
    final daily = find.widgetWithText(
      TextFormField,
      '1/day each (comma-separated)',
    );
    expect(tester.widget<TextFormField>(atWill).initialValue, 'mage hand');
    expect(
      tester.widget<TextFormField>(daily).initialValue,
      'invisibility (self only, no light), wall of force',
    );
    await tester.ensureVisible(daily);
    await tester.enterText(daily, 'invisibility (self only, no light), shield');
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(submitted, isNotNull);
    await saveCreature(db, submitted!, existingId: row.id);
    final saved = (await loadCreature(db, row.id))!.spellCasting!;
    expect(saved.innateSpell!['will'], ['mage hand']);
    expect(saved.innateSpell!['1e'], [
      'invisibility (self only, no light)',
      'shield',
    ]);
    final hiddenBlocks = await (db.select(
      db.creatureSpellcastings,
    )..where((block) => block.creatureId.equals(row.id))).get();
    final hiddenBlock = hiddenBlocks.singleWhere(
      (block) => block.hiddenUses == '2e',
    );
    final hiddenSpells = await (db.select(
      db.creatureSpells,
    )..where((spell) => spell.spellcastingId.equals(hiddenBlock.id))).get();
    expect(hiddenSpells.single.spellName, 'detect magic');
    final copyId = await saveCreature(db, submitted!, copyFromId: row.id);
    final copiedBlocks = await (db.select(
      db.creatureSpellcastings,
    )..where((block) => block.creatureId.equals(copyId))).get();
    final copiedHiddenBlock = copiedBlocks.singleWhere(
      (block) => block.hiddenUses == '2e',
    );
    final copiedHiddenSpells =
        await (db.select(db.creatureSpells)..where(
              (spell) => spell.spellcastingId.equals(copiedHiddenBlock.id),
            ))
            .get();
    expect(copiedHiddenSpells.single.spellName, 'detect magic');
  });

  testWidgets('creates and reloads leveled and innate spellcasting', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    Creature? submitted;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatblockEditorForm(onSubmit: (value) => submitted = value),
        ),
      ),
    );

    expect(find.text('Spellcasting'), findsOneWidget);
    expect(find.text('Innate Spellcasting'), findsOneWidget);
    await tester.enterText(find.widgetWithText(TextFormField, 'Name'), 'Mage');
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Armor Class'),
      '12',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Hit Points'),
      '10',
    );
    final spellTile = find.text('Spellcasting');
    await tester.ensureVisible(spellTile);
    await tester.tap(spellTile);
    await tester.pumpAndSettle();
    final names = find.widgetWithText(
      TextFormField,
      'Spell Names (comma-separated)',
    );
    await tester.ensureVisible(names.at(1));
    await tester.enterText(names.at(1), 'shield');
    final slots = find.widgetWithText(TextFormField, 'Number of Spell Slots');
    await tester.ensureVisible(slots.first);
    await tester.enterText(slots.first, '3');

    final innateTile = find.text('Innate Spellcasting');
    await tester.ensureVisible(innateTile);
    await tester.tap(innateTile);
    await tester.pumpAndSettle();
    final atWill = find.widgetWithText(
      TextFormField,
      'At will (comma-separated)',
    );
    await tester.ensureVisible(atWill);
    await tester.enterText(atWill, 'mage hand, , light');
    final addFrequency = find.text('Add daily spell frequency');
    await tester.ensureVisible(addFrequency);
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2/day each').last);
    await tester.pumpAndSettle();
    final daily = find.widgetWithText(
      TextFormField,
      '2/day each (comma-separated)',
    );
    await tester.ensureVisible(daily);
    await tester.enterText(daily, 'misty step');
    await tester.ensureVisible(addFrequency);
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2/day').last);
    await tester.pumpAndSettle();
    final sharedDaily = find.widgetWithText(
      TextFormField,
      '2/day (comma-separated)',
    );
    await tester.ensureVisible(sharedDaily);
    await tester.enterText(sharedDaily, 'shield');
    await tester.ensureVisible(find.text('Create'));
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();
    expect(submitted, isNotNull);

    final id = await saveCreature(db, submitted!);
    final saved = (await loadCreature(db, id))!;
    expect(saved.spellCasting!.spells![1]!.slots, 3);
    expect(saved.spellCasting!.spells![1]!.spells, ['shield']);
    expect(saved.spellCasting!.innateSpell!['will'], ['mage hand', 'light']);
    expect(saved.spellCasting!.innateSpell!['2e'], ['misty step']);
    expect(saved.spellCasting!.innateSpell!['2'], ['shield']);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: CreatureStatBlock(creature: saved)),
      ),
    );
    expect(find.text('2/day each: '), findsOneWidget);
    expect(find.text('2/day: '), findsOneWidget);
  });

  testWidgets('copying an imported caster preloads both spellcasting tiles', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await importBestiaryJson(db, _bestiaryJson);
    final row = await (db.select(
      db.creatures,
    )..where((row) => row.source.equals('MM'))).getSingle();
    final creature = (await loadCreature(db, row.id))!;
    Creature? submitted;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatblockEditorForm(
            creature: creature,
            onSubmit: (value) => submitted = value,
          ),
        ),
      ),
    );
    expect(find.text('Spellcasting'), findsOneWidget);
    expect(find.text('Innate Spellcasting'), findsOneWidget);
    final innateTile = find.text('Innate Spellcasting');
    await tester.ensureVisible(innateTile);
    await tester.tap(innateTile);
    await tester.pumpAndSettle();
    final atWill = find.widgetWithText(
      TextFormField,
      'At will (comma-separated)',
    );
    expect(tester.widget<TextFormField>(atWill).initialValue, 'detect magic');
    final spellTile = find.text('Spellcasting');
    await tester.ensureVisible(spellTile);
    await tester.tap(spellTile);
    await tester.pumpAndSettle();
    final names = find.widgetWithText(
      TextFormField,
      'Spell Names (comma-separated)',
    );
    expect(
      tester.widget<TextFormField>(names.at(1)).initialValue,
      'shield, bless',
    );
    await tester.ensureVisible(find.text('Create'));
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();
    expect(submitted, isNotNull);
    final copyId = await saveCreature(db, submitted!);
    final copy = (await loadCreature(db, copyId))!;
    expect(copy.name, 'MM caster (Copy)');
    expect(copy.spellCasting!.spells![1]!.slots, 3);
    expect(copy.spellCasting!.innateSpell!['will'], ['detect magic']);
  });
}

const _bestiaryJson = r'''
{
  "monster": [
    {
      "name": "MM caster", "source": "MM", "ac": [12],
      "hp": {"average": 10},
      "spellcasting": [{
        "name": "Spellcasting",
        "spells": {
          "0": {"spells": ["{@spell light}"]},
          "1": {"slots": 3, "spells": ["{@spell shield}", "{@spell bless}"]}
        }
      }, {
        "name": "Innate Spellcasting",
        "will": ["{@spell detect magic}"]
      }]
    },
    {
      "name": "MPMM caster", "source": "MPMM", "ac": [12],
      "hp": {"average": 10},
      "spellcasting": [{
        "name": "Spellcasting",
        "will": ["{@spell mage hand}"],
        "hidden": ["2e"],
        "daily": {
          "1e": ["{@spell invisibility} (self only, no light)", "{@spell wall of force}"],
          "2e": ["{@spell detect magic}"]
        }
      }]
    }
  ]
}
''';

CreatureDraft _creatureDraft() => CreatureDraft(
  armorClass: CreatureArmorClassDraft(ac: 12),
  challengeRating: CreatureCRDraft(cr: '1'),
  speed: CreatureSpeedDraft(),
  abilityScores: CreatureAbilityScoresDraft(),
  savingThrows: CreatureSavingThrowsDraft(
    isStrProf: false,
    isDexProf: false,
    isConProf: false,
    isIntProf: false,
    isWisProf: false,
    isChaProf: false,
  ),
  spellCasting: CreatureSpellcastingDraft(
    spells: {
      for (var level = 0; level <= 9; level++)
        level: SpellLevelDraft(slots: level == 0 ? null : 0, spells: []),
    },
  ),
);

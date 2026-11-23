import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmdex/components/creature_card.dart';
import 'package:gmdex/components/spell_card.dart';
import 'package:gmdex/database/database.dart';
import 'package:gmdex/database/database_initialize.dart';
import 'package:gmdex/pages/combat_page.dart';
import 'package:gmdex/pages/creatures_page.dart';
import 'package:gmdex/pages/spells_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    setDatabaseForTesting(AppDatabase(NativeDatabase.memory()));
    for (final (name, school) in [
      ('Alpha Spell', 'A'),
      ('Conjured Spell', 'C'),
      ('Evoked Spell', 'V'),
    ]) {
      await database
          .into(database.spells)
          .insert(
            SpellsCompanion.insert(
              name: name,
              source: 'Test',
              level: 1,
              school: school,
              data: name == 'Evoked Spell' ? '{}' : '{"meta":{"ritual":true}}',
            ),
          );
    }
    for (final (name, type, size) in [
      ('Alpha Beast', 'Beast', 'Medium'),
      ('Beta Dragon', 'Dragon (red)', 'Medium'),
      ('Gamma Fiend', 'Fiend', 'Large'),
      ('Small Beast', 'Beast', 'Small'),
    ]) {
      await database
          .into(database.creatures)
          .insert(
            CreaturesCompanion.insert(
              name: name,
              type: Value(type),
              size: Value(size),
              source: const Value('Test'),
            ),
          );
    }
  });

  tearDownAll(() async {
    await database.close();
  });

  testWidgets('spell schools support multiple selections, cancel and clear', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: BrowseSpellsWidget()));
    await tester.pumpAndSettle();
    expect(
      _spellNames(tester),
      containsAll(['Alpha Spell', 'Conjured Spell', 'Evoked Spell']),
    );

    await tester.tap(find.byTooltip('Filters'));
    await tester.pumpAndSettle();
    await _tapChip(tester, 'Abjuration');
    await _tapChip(tester, 'Conjuration');
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();
    expect(_spellNames(tester), containsAll(['Alpha Spell', 'Conjured Spell']));
    expect(_spellNames(tester), isNot(contains('Evoked Spell')));

    await tester.tap(find.byTooltip('Filters'));
    await tester.pumpAndSettle();
    await _tapChip(tester, 'Abjuration');
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(_spellNames(tester), contains('Alpha Spell'));

    await tester.tap(find.byTooltip('Filters'));
    await tester.pumpAndSettle();
    await _tapChip(tester, 'Abjuration');
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();
    expect(_spellNames(tester), contains('Conjured Spell'));
    expect(_spellNames(tester), isNot(contains('Alpha Spell')));

    await tester.tap(find.byTooltip('Filters'));
    await tester.pumpAndSettle();
    await _tapChip(tester, 'Conjuration');
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();
    expect(_spellNames(tester), containsAll(['Alpha Spell', 'Evoked Spell']));

    await tester.tap(find.byTooltip('Filters'));
    await tester.pumpAndSettle();
    await _tapChip(tester, 'Abjuration');
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();
    expect(_spellNames(tester), isNot(contains('Evoked Spell')));

    await tester.tap(find.byTooltip('Filters'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clear'));
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();
    expect(_spellNames(tester), contains('Evoked Spell'));
  });

  testWidgets(
    'ritual filter combines with schools and supports cancel and clear',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: BrowseSpellsWidget()));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Filters'));
      await tester.pumpAndSettle();
      await _tapChip(tester, 'Abjuration');
      await _tapRitualFilter(tester);
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(_spellNames(tester), contains('Alpha Spell'));
      expect(_spellNames(tester), isNot(contains('Conjured Spell')));
      expect(_spellNames(tester), isNot(contains('Evoked Spell')));

      await tester.tap(find.byTooltip('Filters'));
      await tester.pumpAndSettle();
      await _tapRitualFilter(tester);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Filters'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<CheckboxListTile>(find.byType(CheckboxListTile)).value,
        isTrue,
      );
      await _tapChip(tester, 'Abjuration');
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(
        _spellNames(tester),
        containsAll(['Alpha Spell', 'Conjured Spell']),
      );
      expect(_spellNames(tester), isNot(contains('Evoked Spell')));

      await tester.tap(find.byTooltip('Filters'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Clear'));
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(_spellNames(tester), contains('Evoked Spell'));
    },
  );

  testWidgets('ritual filter reports invalid spell data and can be cleared', (
    tester,
  ) async {
    final id = await database
        .into(database.spells)
        .insert(
          SpellsCompanion.insert(
            name: 'Invalid Data',
            source: 'Test',
            level: 1,
            school: 'A',
            data: 'invalid',
          ),
        );
    addTearDown(() async {
      await (database.delete(
        database.spells,
      )..where((spell) => spell.id.equals(id))).go();
    });

    await tester.pumpWidget(const MaterialApp(home: BrowseSpellsWidget()));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Filters'));
    await tester.pumpAndSettle();
    await _tapRitualFilter(tester);
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Could not filter spells:'), findsOneWidget);

    await tester.tap(find.byTooltip('Filters'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clear'));
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Could not filter spells:'), findsNothing);
    expect(_spellNames(tester), contains('Invalid Data'));
  });

  for (final (label, page, tooltip) in [
    ('bestiary', const BrowseCreatureWidget(), 'Filters'),
    ('encounter builder', const EncounterBuildPage(), 'Filter creatures'),
  ]) {
    testWidgets('$label supports multiple creature types', (tester) async {
      tester.view.physicalSize = const Size(1400, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(MaterialApp(home: page));
      await tester.pumpAndSettle();

      if (label == 'encounter builder') {
        await tester.tap(find.byTooltip('Bestiary'));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.byTooltip(tooltip).first);
      await tester.pumpAndSettle();
      await _tapChip(tester, 'Beast');
      await _tapChip(tester, 'Dragon');
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(
        _creatureNames(tester),
        containsAll(['Alpha Beast', 'Beta Dragon']),
      );
      expect(_creatureNames(tester), isNot(contains('Gamma Fiend')));

      await tester.tap(find.byTooltip(tooltip).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('All').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Medium').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(
        _creatureNames(tester),
        containsAll(['Alpha Beast', 'Beta Dragon']),
      );
      expect(_creatureNames(tester), isNot(contains('Small Beast')));

      await tester.tap(find.byTooltip(tooltip).first);
      await tester.pumpAndSettle();
      await _tapChip(tester, 'Beast');
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(_creatureNames(tester), contains('Alpha Beast'));

      await tester.tap(find.byTooltip(tooltip).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Clear'));
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(_creatureNames(tester), contains('Gamma Fiend'));
    });
  }
}

Future<void> _tapChip(WidgetTester tester, String label) async {
  await tester.tap(
    find.ancestor(of: find.text(label), matching: find.byType(FilterChip)),
  );
  await tester.pumpAndSettle();
}

Future<void> _tapRitualFilter(WidgetTester tester) async {
  final checkbox = find.byType(CheckboxListTile);
  await tester.ensureVisible(checkbox);
  await tester.pumpAndSettle();
  await tester.tap(checkbox);
  await tester.pumpAndSettle();
}

Iterable<String> _spellNames(WidgetTester tester) => tester
    .widgetList<SpellCard>(find.byType(SpellCard))
    .map((card) => card.name);

Iterable<String> _creatureNames(WidgetTester tester) => tester
    .widgetList<CreatureCard>(find.byType(CreatureCard))
    .map((card) => card.name);

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmdex/components/statblock_edit.dart';
import 'package:gmdex/database/bestiary_importer.dart';
import 'package:gmdex/database/creature_mapper.dart';
import 'package:gmdex/database/creature_writer.dart';
import 'package:gmdex/database/database.dart';
import 'package:gmdex/models/creature.dart';

void main() {
  testWidgets('creates and saves an editable multiattack action', (
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
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Armor Class'),
      '12',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Hit Points'),
      '10',
    );
    await _toggleMultiattack(tester);

    final description = find.widgetWithText(TextFormField, 'Description');
    expect(
      _fieldText(tester, description),
      'The NAME makes two attacks, '
      'two ATTACK attacks, or one of each.',
    );
    expect(
      _fieldText(tester, find.widgetWithText(TextFormField, 'Name').last),
      'Multiattack',
    );
    expect(
      tester
          .widget<DropdownMenu<ActionType>>(
            find.byType(DropdownMenu<ActionType>),
          )
          .initialSelection,
      ActionType.action,
    );

    final creatureName = find.widgetWithText(TextFormField, 'Name').first;
    await tester.ensureVisible(creatureName);
    await tester.enterText(creatureName, 'Dragon');
    expect(
      _fieldText(tester, description),
      'The Dragon makes two attacks, '
      'two ATTACK attacks, or one of each.',
    );
    await tester.enterText(creatureName, '');
    expect(
      _fieldText(tester, description),
      'The NAME makes two attacks, two ATTACK attacks, or one of each.',
    );
    await tester.enterText(creatureName, 'Dragon');
    await tester.ensureVisible(find.text('Create'));
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();
    expect(submitted, isNotNull);
    final defaultId = await saveCreature(db, submitted!);
    final defaultAction = (await loadCreature(db, defaultId))!.actions!.single;
    expect(defaultAction.name, 'Multiattack');
    expect(defaultAction.type, ActionType.action);
    expect(
      defaultAction.description,
      'The Dragon makes two attacks, two ATTACK attacks, or one of each.',
    );

    await tester.ensureVisible(description);
    await tester.enterText(description, 'The dragon makes three attacks.');
    await tester.ensureVisible(creatureName);
    await tester.enterText(creatureName, 'Red Dragon');
    expect(_fieldText(tester, description), 'The dragon makes three attacks.');

    await tester.ensureVisible(find.text('Create'));
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();
    expect(submitted, isNotNull);
    final id = await saveCreature(db, submitted!);
    final saved = (await loadCreature(db, id))!;
    expect(saved.actions, hasLength(1));
    expect(saved.actions!.single.name, 'Multiattack');
    expect(saved.actions!.single.type, ActionType.action);
    expect(
      saved.actions!.single.description,
      'The dragon makes three attacks.',
    );
  });

  testWidgets('unchecking removes only multiattack and preserves other edits', (
    tester,
  ) async {
    Creature? submitted;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatblockEditorForm(onSubmit: (value) => submitted = value),
        ),
      ),
    );
    await tester.enterText(find.widgetWithText(TextFormField, 'Name'), 'Beast');
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Armor Class'),
      '12',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Hit Points'),
      '10',
    );
    await _toggleMultiattack(tester);
    final actionsHeader = find.text('Actions');
    await tester.ensureVisible(actionsHeader);
    await tester.tap(find.widgetWithText(ElevatedButton, '+').last);
    await tester.pumpAndSettle();
    final otherName = find.widgetWithText(TextFormField, 'Name').last;
    await tester.ensureVisible(otherName);
    await tester.enterText(otherName, 'Bite');
    final otherDescription = find
        .widgetWithText(TextFormField, 'Description')
        .last;
    await tester.ensureVisible(otherDescription);
    await tester.enterText(otherDescription, 'A biting attack.');

    await _toggleMultiattack(tester);
    expect(find.byType(DropdownMenu<ActionType>), findsOneWidget);
    expect(
      _fieldText(tester, find.widgetWithText(TextFormField, 'Name').last),
      'Bite',
    );
    expect(
      _fieldText(
        tester,
        find.widgetWithText(TextFormField, 'Description').last,
      ),
      'A biting attack.',
    );
    await _toggleMultiattack(tester);
    expect(find.byType(DropdownMenu<ActionType>), findsNWidgets(2));
    await _toggleMultiattack(tester);
    expect(find.byType(DropdownMenu<ActionType>), findsOneWidget);
    expect(
      _fieldText(tester, find.widgetWithText(TextFormField, 'Name').last),
      'Bite',
    );
    await tester.ensureVisible(find.text('Create'));
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();
    expect(submitted!.actions!.single.name, 'Bite');
    expect(submitted!.actions!.single.description, 'A biting attack.');
  });

  testWidgets('existing multiattack is checked and can be removed', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await importBestiaryJson(db, '''
      {"monster":[{"name":"Guard","source":"Test","ac":[12],
      "hp":{"average":10},"action":[
        {"name":"Multiattack","entries":["Existing description."]},
        {"name":"Spear","entries":["A spear attack."]}
      ]}]}
    ''');
    final row = await db.select(db.creatures).getSingle();
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
    final checkbox = _multiattackCheckbox();
    await tester.ensureVisible(checkbox);
    expect(tester.widget<Checkbox>(checkbox).value, isTrue);
    expect(
      _fieldText(
        tester,
        find.widgetWithText(TextFormField, 'Description').first,
      ),
      'Existing description.',
    );
    await _toggleMultiattack(tester);
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(submitted!.actions!.single.name, 'Spear');
  });
}

Finder _multiattackCheckbox() {
  final row = find
      .ancestor(of: find.text('Multiattack'), matching: find.byType(Row))
      .first;
  return find.descendant(of: row, matching: find.byType(Checkbox));
}

Future<void> _toggleMultiattack(WidgetTester tester) async {
  final checkbox = _multiattackCheckbox();
  await tester.ensureVisible(checkbox);
  await tester.tap(checkbox);
  await tester.pumpAndSettle();
}

String? _fieldText(WidgetTester tester, Finder finder) {
  final editable = find.descendant(
    of: finder,
    matching: find.byType(EditableText),
  );
  return tester.widget<EditableText>(editable).controller.text;
}

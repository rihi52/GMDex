import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmdex/database/database.dart';
import 'package:gmdex/database/database_initialize.dart';
import 'package:gmdex/models/combat.dart';
import 'package:gmdex/pages/combat_page.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    setDatabaseForTesting(db);
  });

  tearDown(() async => db.close());

  for (final width in [600.0, 1400.0]) {
    testWidgets('new encounters use the next available name at width $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const EncounterBuildPage(),
                ),
              ),
              child: const Text('Create'),
            ),
          ),
        ),
      );

      for (var number = 1; number <= 2; number++) {
        await tester.tap(find.text('Create'));
        await tester.pumpAndSettle();
        expect(_name(tester), 'Encounter $number');
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();
      }

      expect((await db.select(db.encounters).get()).map((row) => row.name), [
        'Encounter 1',
        'Encounter 2',
      ]);
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();
      expect(_name(tester), 'Encounter 3');
    });
  }

  testWidgets('fills a numbering gap and allows a custom name', (tester) async {
    for (final name in ['Encounter 1', 'Encounter 3', 'Other']) {
      await db
          .into(db.encounters)
          .insert(EncountersCompanion.insert(name: name, notes: ''));
    }

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const EncounterBuildPage(),
              ),
            ),
            child: const Text('Create'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();
    expect(_name(tester), 'Encounter 2');
    await tester.enterText(_nameField(), 'Bridge battle');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(
      (await db.select(db.encounters).get()).map((row) => row.name),
      contains('Bridge battle'),
    );
  });

  testWidgets('editing and copying preserve their existing names', (
    tester,
  ) async {
    final encounter = Encounter(
      name: 'Existing battle',
      currentTurnIndex: 0,
      combatants: [],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: EncounterBuildPage(
          key: const ValueKey('edit'),
          encounter: encounter,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(_name(tester), 'Existing battle');

    await tester.pumpWidget(
      MaterialApp(
        home: EncounterBuildPage(
          key: const ValueKey('copy'),
          encounter: encounter,
          isCopy: true,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(_name(tester), 'Existing battle (Copy)');
  });
}

Finder _nameField() => find.widgetWithText(TextFormField, 'Encounter Name');

String _name(WidgetTester tester) => tester
    .widget<EditableText>(
      find.descendant(of: _nameField(), matching: find.byType(EditableText)),
    )
    .controller
    .text;

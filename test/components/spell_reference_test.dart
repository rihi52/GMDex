import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmdex/components/spell_reference.dart';
import 'package:gmdex/components/statblock.dart';
import 'package:gmdex/database/database.dart';
import 'package:gmdex/database/read.dart' show parseCreature;

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> addSpell(String name) async {
    await db
        .into(db.spells)
        .insert(
          SpellsCompanion.insert(
            name: name,
            source: 'SRD',
            level: 1,
            school: 'E',
            data: jsonEncode({
              'entries': ['A description linked from a creature.'],
            }),
          ),
        );
  }

  Future<void> disposeWidget(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 2));
  }

  testWidgets('desktop hover shows a matching spell description', (
    tester,
  ) async {
    await addSpell('Detect Magic');

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: TargetPlatform.windows),
        home: Scaffold(
          body: SpellReference(
            database: db,
            name: 'detect magic',
            style: const TextStyle(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('detect magic'), findsOneWidget);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(
      location: tester.getCenter(find.text('detect magic')),
    );
    await mouse.moveTo(tester.getCenter(find.text('detect magic')));
    await tester.pump(const Duration(milliseconds: 500));

    expect(
      find.textContaining('A description linked from a creature.'),
      findsOneWidget,
    );
    expect(find.byType(Tooltip), findsNothing);
    final link = tester.widget<Text>(find.text('detect magic'));
    expect(link.style?.color, const Color.fromARGB(255, 68, 22, 148));
    var decoration = tester.widget<DecoratedBox>(
      find.byKey(const ValueKey('spell-reference-decoration')),
    );
    expect(
      (decoration.decoration as BoxDecoration).border!.top.color,
      Colors.white,
    );

    await mouse.moveTo(
      tester.getCenter(find.text('A description linked from a creature.')),
    );
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('A description linked from a creature.'), findsOneWidget);

    await mouse.moveTo(const Offset(790, 590));
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('A description linked from a creature.'), findsNothing);
    await mouse.removePointer();
    await disposeWidget(tester);
  });

  testWidgets('mobile tap opens spell details for an imported match', (
    tester,
  ) async {
    await addSpell('Shield');

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: TargetPlatform.android),
        home: Scaffold(
          body: SpellReference(
            database: db,
            name: 'Shield',
            style: const TextStyle(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Shield'));
    await tester.pumpAndSettle();

    expect(find.text('A description linked from a creature.'), findsOneWidget);
    expect(find.text('Enchantment'), findsOneWidget);
    await disposeWidget(tester);
  });

  testWidgets('an unmatched creature spell remains plain text', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: TargetPlatform.android),
        home: Scaffold(
          body: SpellReference(
            database: db,
            name: 'Unknown Spell',
            style: const TextStyle(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Unknown Spell'));
    await tester.pumpAndSettle();

    expect(find.text('Unknown Spell'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
    await disposeWidget(tester);
  });

  testWidgets('a spell imported while the statblock is open becomes linkable', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: TargetPlatform.android),
        home: Scaffold(
          body: SpellReference(
            database: db,
            name: 'Imported Later',
            style: const TextStyle(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await addSpell('Imported Later');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Imported Later'));
    await tester.pumpAndSettle();

    expect(find.text('A description linked from a creature.'), findsOneWidget);
    await disposeWidget(tester);
  });

  testWidgets('creature statblock spell names link to catalog entries', (
    tester,
  ) async {
    await addSpell('Detect Magic');
    final creature = parseCreature({
      'name': 'Spellcaster',
      'size': ['M'],
      'type': 'humanoid',
      'alignment': ['N'],
      'ac': [12],
      'hp': {'average': 10},
      'speed': {'walk': 30},
      'str': 10,
      'dex': 10,
      'con': 10,
      'int': 16,
      'wis': 12,
      'cha': 10,
      'spellcasting': [
        {
          'name': 'Spellcasting',
          'headerEntries': ['A spellcaster.'],
          'ability': 'int',
          'spells': {
            '0': {
              'spells': ['detect magic', 'Unavailable Spell'],
            },
          },
        },
      ],
    }, {});

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: TargetPlatform.android),
        home: Scaffold(
          body: CreatureStatBlock(creature: creature, database: db),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SpellReference), findsNWidgets(2));
    await tester.tap(find.text('detect magic'));
    await tester.pumpAndSettle();

    expect(find.text('A description linked from a creature.'), findsOneWidget);
    await disposeWidget(tester);
  });
}

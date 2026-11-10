import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmdex/components/spell_card.dart';
import 'package:gmdex/components/spell_details.dart';
import 'package:gmdex/database/database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('shows spell metadata and description', (tester) async {
    await db
        .into(db.spells)
        .insert(
          SpellsCompanion.insert(
            name: 'Test Spell',
            source: 'SRD',
            level: 1,
            school: 'E',
            data: jsonEncode({
              'time': [
                {'number': 1, 'unit': 'action'},
              ],
              'range': {
                'type': 'point',
                'distance': {'type': 'feet', 'amount': 30},
              },
              'components': {'v': true, 's': true},
              'duration': [
                {
                  'type': 'timed',
                  'duration': {'type': 'minute', 'amount': 1},
                },
              ],
              'entries': [
                'A clear spell description.',
                'It deals {@scaledice 1d8|1-9|1d8} damage.',
              ],
              'entriesHigherLevel': [
                {
                  'type': 'entries',
                  'name': 'At Higher Levels',
                  'entries': ['The spell gains power.'],
                },
              ],
            }),
          ),
        );
    final spell = await db.select(db.spells).getSingle();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SpellDetails(spell: spell)),
      ),
    );

    expect(find.text('Test Spell'), findsOneWidget);
    expect(find.text('1st level'), findsOneWidget);
    expect(find.text('Enchantment'), findsOneWidget);
    expect(find.text('1 action'), findsOneWidget);
    expect(find.text('30 feet'), findsOneWidget);
    expect(find.text('V, S'), findsOneWidget);
    expect(find.text('1 minute'), findsOneWidget);
    expect(
      find.text('A clear spell description.\n\nIt deals 1d8 damage.'),
      findsOneWidget,
    );
    expect(find.textContaining('1d8|1-9|1d8'), findsNothing);
    expect(find.text('At Higher Levels'), findsOneWidget);
    expect(find.text('The spell gains power.'), findsOneWidget);
  });

  testWidgets('spell card displays the full school name', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SpellCard(name: 'Test Spell', level: 1, school: 'E'),
        ),
      ),
    );

    expect(find.text('Enchantment'), findsOneWidget);
    expect(find.text('E'), findsNothing);
  });
}

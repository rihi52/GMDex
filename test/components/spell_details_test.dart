import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmdex/components/spell_card.dart';
import 'package:gmdex/components/spell_details.dart';
import 'package:gmdex/database/database.dart';
import 'package:gmdex/database/spell_importer.dart';

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

    expect(find.byType(SelectionArea), findsOneWidget);
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

  testWidgets('resets the selection area when switching spells', (
    tester,
  ) async {
    final firstId = await db
        .into(db.spells)
        .insert(
          SpellsCompanion.insert(
            name: 'First Spell',
            source: 'SRD',
            level: 1,
            school: 'E',
            data: '{}',
          ),
        );
    final secondId = await db
        .into(db.spells)
        .insert(
          SpellsCompanion.insert(
            name: 'Second Spell',
            source: 'SRD',
            level: 1,
            school: 'E',
            data: '{}',
          ),
        );
    final firstSpell = await (db.select(
      db.spells,
    )..where((spell) => spell.id.equals(firstId))).getSingle();
    final secondSpell = await (db.select(
      db.spells,
    )..where((spell) => spell.id.equals(secondId))).getSingle();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SpellDetails(spell: firstSpell)),
      ),
    );
    final firstSelectionKey = tester
        .widget<SelectionArea>(find.byType(SelectionArea))
        .key;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SpellDetails(spell: secondSpell)),
      ),
    );
    final secondSelectionKey = tester
        .widget<SelectionArea>(find.byType(SelectionArea))
        .key;

    expect(firstSelectionKey, ValueKey(firstId));
    expect(secondSelectionKey, ValueKey(secondId));
    expect(secondSelectionKey, isNot(firstSelectionKey));
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

  testWidgets('shows imported material text without metadata', (tester) async {
    await importSpellsJson(
      db,
      jsonEncode({
        'spell': [
          {
            'name': 'Forbiddance',
            'source': 'PHB',
            'level': 6,
            'school': 'A',
            'components': {
              'v': true,
              's': true,
              'm': {
                'text': 'rare incense and powdered ruby',
                'cost': 100000,
                'consume': 'optional',
              },
            },
          },
          {
            'name': 'String Material',
            'source': 'PHB',
            'level': 1,
            'school': 'A',
            'components': {'m': 'a feather'},
          },
          {
            'name': 'Simple Material',
            'source': 'PHB',
            'level': 1,
            'school': 'A',
            'components': {'m': true},
          },
        ],
      }),
    );
    final spells = await db.select(db.spells).get();
    final expected = {
      'Forbiddance': 'V, S, M (rare incense and powdered ruby)',
      'String Material': 'M (a feather)',
      'Simple Material': 'M',
    };
    for (final spell in spells) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: SpellDetails(spell: spell)),
        ),
      );
      expect(find.text(expected[spell.name]!), findsOneWidget);
    }

    final stored = jsonDecode(
      spells.singleWhere((spell) => spell.name == 'Forbiddance').data,
    );
    expect(stored['components']['m']['cost'], 100000);
    expect(stored['components']['m']['consume'], 'optional');
  });

  testWidgets('shows spell tag text without source or other metadata', (
    tester,
  ) async {
    await importSpellsJson(
      db,
      jsonEncode({
        'spell': [
          {
            'name': 'Find Greater Steed',
            'source': 'XGE',
            'level': 4,
            'school': 'C',
            'entries': [
              {
                'type': 'inset',
                'name': '{@item Steeds|dmg}',
                'entries': [
                  'A {@creature dragonnel|ftd} and a {@creature griffon}.',
                  '{@spell find steed|phb} and {@item saddle|dmg|a saddle}.',
                  '{@i Guide} and {@custom text|source}.',
                  'Roll {@scaledice 1d8|1-9|1d8}.',
                ],
              },
            ],
          },
        ],
      }),
    );
    final spell = await db.select(db.spells).getSingle();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SpellDetails(spell: spell)),
      ),
    );

    expect(
      find.text(
        'Steeds:\n\n'
        'A dragonnel and a griffon.\n\n'
        'find steed and saddle.\n\n'
        'Guide and text.\n\n'
        'Roll 1d8.',
      ),
      findsOneWidget,
    );
    expect(spell.data, contains(r'{@creature dragonnel|ftd}'));
  });

  testWidgets('shows ritual after the level only for ritual spells', (
    tester,
  ) async {
    await importSpellsJson(
      db,
      jsonEncode({
        'spell': [
          {
            'name': 'Forbiddance',
            'source': 'PHB',
            'level': 6,
            'school': 'A',
            'meta': {'ritual': true},
          },
          {
            'name': 'Nonritual',
            'source': 'PHB',
            'level': 6,
            'school': 'A',
            'meta': {'ritual': false},
          },
          {
            'name': 'Invalid Ritual',
            'source': 'PHB',
            'level': 6,
            'school': 'A',
            'meta': {'ritual': 'true'},
          },
        ],
      }),
    );
    final spells = await db.select(db.spells).get();
    for (final spell in spells) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: SpellDetails(spell: spell)),
        ),
      );
      final expected = spell.name == 'Forbiddance'
          ? '6th level (ritual)'
          : '6th level';
      expect(find.text(expected), findsOneWidget);
    }
  });
}

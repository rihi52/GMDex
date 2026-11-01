import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gmdex/components/statblock.dart';
import 'package:gmdex/database/read.dart';

late final List<dynamic> _monsters;
const _legendaryGroups = <String, dynamic>{};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  setUpAll(() {
    final jsonString = File(
      'assets/bestiary-srd-filtered.json',
    ).readAsStringSync();
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    final monsters = data['monster'] as List<dynamic>;
    _monsters = monsters.where((monster) {
      if (monster is! Map<String, dynamic>) return false;
      final name = monster['name'];
      final armorClass = monster['ac'];
      final hitPoints = monster['hp'];
      return name is String &&
          name.trim().isNotEmpty &&
          armorClass is List &&
          armorClass.isNotEmpty &&
          hitPoints is Map &&
          hitPoints['average'] != null;
    }).toList();
  });

  test('parseCreature parses entire dataset without throwing', () {
    for (final m in _monsters) {
      parseCreature(m as Map<String, dynamic>, _legendaryGroups);
    }
  });

  testWidgets(
    'CreatureStatBlock builds for entire dataset',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1600, 1200));
      addTearDown(() {
        tester.binding.setSurfaceSize(null);
      });

      for (final m in _monsters) {
        final creature = parseCreature(
          m as Map<String, dynamic>,
          _legendaryGroups,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: CreatureStatBlock(creature: creature)),
          ),
        );

        await tester.pump();
        expect(
          find.text(creature.name),
          findsWidgets,
          reason: 'Failed on ${creature.name}',
        );
      }
    },
    timeout: Timeout(Duration(minutes: 10)),
  );
}

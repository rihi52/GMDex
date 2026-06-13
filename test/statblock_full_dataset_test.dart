import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moonscribe/components/statblock.dart';
import 'package:moonscribe/load/read.dart';

late final List<dynamic> _monsters;
late final Map<String, dynamic> _legendaryGroups;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  setUpAll(() {
    final jsonString = File('assets/bestiary-mm.json').readAsStringSync();
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    _monsters = data['monster'] as List<dynamic>;

    final lgString = File('assets/legendarygroups.json').readAsStringSync();
    final lgData = jsonDecode(lgString) as Map<String, dynamic>;
    _legendaryGroups = {
      for (final group in lgData['legendaryGroup'] as List)
        '${group['name']}_${group['source']}': group,
    };
  });

  test('parseCreature parses entire dataset without throwing', () {
    for (final m in _monsters) {
      parseCreature(m as Map<String, dynamic>, _legendaryGroups);
    }
  });

  testWidgets('CreatureStatBlock builds for entire dataset',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1600, 1200));
    addTearDown(() {
      tester.binding.setSurfaceSize(null);
    });

    for (final m in _monsters) {
      final creature = parseCreature(m as Map<String, dynamic>, _legendaryGroups);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreatureStatBlock(creature: creature),
          ),
        ),
      );

      await tester.pump();
      expect(find.text(creature.name), findsWidgets, reason: 'Failed on ${creature.name}');
    }
  }, timeout: Timeout(Duration(minutes: 10))); 
}

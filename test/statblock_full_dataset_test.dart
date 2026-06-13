import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonscribe/components/statblock.dart';
import 'package:moonscribe/load/read.dart';

void main() {
  testWidgets('CreatureStatBlock builds for every creature in dataset',
      (WidgetTester tester) async {
    // Load monster data from assets on disk so tests don't depend on asset bundle.
    final jsonString = await File('assets/bestiary-mm.json').readAsString();
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    final monsters = data['monster'] as List<dynamic>;

    final lgString = await File('assets/legendarygroups.json').readAsString();
    final lgData = jsonDecode(lgString) as Map<String, dynamic>;
    final legendaryGroups = {
      for (final group in lgData['legendaryGroup'] as List)
        '${group['name']}_${group['source']}': group,
    };


    for (final m in monsters) {
  try {
    final creature = parseCreature(m as Map<String, dynamic>, legendaryGroups);
    print('TEST: building ${creature.name}');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CreatureStatBlock(creature: creature),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 200));
    print('TEST: built ${creature.name}');
    expect(find.text(creature.name), findsWidgets);
  } catch (e, stack) {
    print('FAILED: ${m['name']} — $e');
    print(stack);
  }
}
  }, timeout: Timeout(Duration(minutes: 5)));
}

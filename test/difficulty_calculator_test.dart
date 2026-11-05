import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmdex/components/difficulty_calculator.dart';
import 'package:gmdex/models/difficulty_calculator_ruleset.dart';

void main() {
  test('resolves creature XP from challenge rating and overrides', () {
    expect(xpForChallengeRating('1/4'), 50);
    expect(xpForChallengeRating('10'), 5900);
    expect(xpForChallengeRating('unknown'), 0);
    expect(xpForChallengeRating('1/4', xpOverride: 100), 100);
  });

  test('calculates raw and party-adjusted XP', () {
    final xp = calculateEncounterXp(partyLevels: [5], monsterXp: [50, 50]);

    expect(xp.totalXp, 100);
    expect(xp.adjustedXp, 200);
  });

  test('Flee Mortals estimate rates encounter CR against party CR budgets', () {
    final encounter = calculateFleeMortalsEncounter(
      partyLevels: [3, 3, 3, 3],
      monsterCr: [1, 1, 1],
    );

    expect(encounter.totalCr, 3);
    expect(encounter.budgets.easy, closeTo(1, 0.001));
    expect(encounter.budgets.standard, closeTo(2, 0.001));
    expect(encounter.budgets.hard, closeTo(3, 0.001));
    expect(encounter.difficulty, 'Hard');
  });

  test(
    'Flee Mortals budgets sum thresholds for characters of different levels',
    () {
      final encounter = calculateFleeMortalsEncounter(
        partyLevels: [2, 4],
        monsterCr: [1],
      );

      expect(encounter.budgets.easy, closeTo(0.625, 0.001));
      expect(encounter.budgets.standard, closeTo(1, 0.001));
      expect(encounter.budgets.hard, closeTo(1.5, 0.001));
    },
  );

  test('Flee Mortals estimate reports unavailable creature CR', () {
    final encounter = calculateFleeMortalsEncounter(
      partyLevels: [3, 3, 3, 3],
      monsterCr: [null],
    );

    expect(encounter.difficulty, 'CR unavailable');
  });

  testWidgets('renders encounter XP and party thresholds', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DifficultyCalculator(
            partyLevels: [5, 5, 5, 5],
            monsterXp: [50, 50],
          ),
        ),
      ),
    );

    expect(find.text('Total XP:'), findsOneWidget);
    expect(find.text('Adj XP:'), findsOneWidget);
    expect(find.text('100'), findsOneWidget);
    expect(find.text('150'), findsOneWidget);
    expect(find.text('Easy:'), findsOneWidget);
    expect(find.text('Deadly:'), findsOneWidget);
  });

  testWidgets('Flee Mortals mode displays CR instead of XP', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DifficultyCalculator(
            partyLevels: [3, 3, 3, 3],
            monsterXp: [50, 50],
            monsterCr: [1, 1],
            ruleset: DifficultyCalculatorRuleset.fleeMortals,
          ),
        ),
      ),
    );

    expect(find.text('Total CR:'), findsOneWidget);
    expect(find.text('Total XP:'), findsNothing);
    expect(find.text('CR Budget'), findsOneWidget);
  });
}

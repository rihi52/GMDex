import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gmdex/pages/home_page.dart';
import 'package:gmdex/pages/settings.dart';
import 'package:gmdex/models/turn_highlight_preference.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    selectedDifficultyCalculator.value = DifficultyCalculatorRuleset.dnd2014;
    await loadDifficultyCalculatorRuleset();
    await loadTurnHighlightPreference();
  });

  testWidgets('homepage settings button opens the settings page', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MyHomePage()));

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Bestiary'), findsOneWidget);
  });

  testWidgets('About GMDex opens a dialog with an exit button', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsPage()));

    final aboutButton = find.text('About GMDex');
    await tester.scrollUntilVisible(
      aboutButton,
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(aboutButton);
    await tester.pumpAndSettle();

    expect(find.text('About GMDex'), findsNWidgets(2));
    expect(find.text('Exit'), findsOneWidget);

    await tester.tap(find.text('Exit'));
    await tester.pumpAndSettle();
    expect(find.text('Exit'), findsNothing);
  });

  testWidgets('difficulty ruleset selection updates the active setting', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsPage()));

    final fleeMortalsOption = find.textContaining('Flee Mortals');
    await tester.ensureVisible(fleeMortalsOption);
    await tester.pumpAndSettle();
    await tester.tap(fleeMortalsOption);
    await tester.pumpAndSettle();
    expect(
      selectedDifficultyCalculator.value,
      DifficultyCalculatorRuleset.fleeMortals,
    );

    final dndOption = find.textContaining('2014 5e');
    await tester.ensureVisible(dndOption);
    await tester.pumpAndSettle();
    await tester.tap(dndOption);
    await tester.pumpAndSettle();
    expect(
      selectedDifficultyCalculator.value,
      DifficultyCalculatorRuleset.dnd2014,
    );
  });

  testWidgets('difficulty ruleset selection is restored from preferences', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsPage()));

    final fleeMortalsOption = find.textContaining('Flee Mortals');
    await tester.ensureVisible(fleeMortalsOption);
    await tester.pumpAndSettle();
    await tester.tap(fleeMortalsOption);
    await tester.pumpAndSettle();

    selectedDifficultyCalculator.value = DifficultyCalculatorRuleset.dnd2014;
    await loadDifficultyCalculatorRuleset();

    expect(
      selectedDifficultyCalculator.value,
      DifficultyCalculatorRuleset.fleeMortals,
    );
  });

  testWidgets('turn highlighter switch saves and updates its preference', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsPage()));

    final toggle = find.byType(Switch);
    await tester.scrollUntilVisible(
      toggle,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(tester.widget<Switch>(toggle).value, isTrue);

    await tester.tap(toggle);
    await tester.pumpAndSettle();

    expect(turnHighlightEnabled.value, isFalse);
    expect(
      (await SharedPreferences.getInstance()).getBool('turnHighlightEnabled'),
      isFalse,
    );
  });

  testWidgets('clearing database data asks for confirmation', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsPage()));

    final clearButton = find.text('Clear database data');
    await tester.ensureVisible(clearButton);
    await tester.pumpAndSettle();
    await tester.tap(clearButton);
    await tester.pumpAndSettle();

    expect(find.text('Clear database data?'), findsOneWidget);
    expect(
      find.textContaining('The database tables and structure will remain.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Clear database data?'), findsNothing);
  });
}

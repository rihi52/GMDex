import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DifficultyCalculatorRuleset { dnd2014, fleeMortals }

const _difficultyCalculatorPreferenceKey = 'difficultyCalculatorRuleset';

final selectedDifficultyCalculator = ValueNotifier<DifficultyCalculatorRuleset>(
  DifficultyCalculatorRuleset.dnd2014,
);

Future<void> loadDifficultyCalculatorRuleset() async {
  final preferences = await SharedPreferences.getInstance();
  final storedValue = preferences.getString(_difficultyCalculatorPreferenceKey);
  selectedDifficultyCalculator.value =
      DifficultyCalculatorRuleset.values
          .where((ruleset) => ruleset.name == storedValue)
          .firstOrNull ??
      DifficultyCalculatorRuleset.dnd2014;
}

Future<void> saveDifficultyCalculatorRuleset(
  DifficultyCalculatorRuleset ruleset,
) async {
  final preferences = await SharedPreferences.getInstance();
  final saved = await preferences.setString(
    _difficultyCalculatorPreferenceKey,
    ruleset.name,
  );
  if (!saved) {
    throw StateError('The difficulty calculator setting could not be saved.');
  }
  selectedDifficultyCalculator.value = ruleset;
}

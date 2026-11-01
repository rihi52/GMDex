import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _turnHighlightPreferenceKey = 'turnHighlightEnabled';

final turnHighlightEnabled = ValueNotifier<bool>(true);

Future<void> loadTurnHighlightPreference() async {
  final preferences = await SharedPreferences.getInstance();
  turnHighlightEnabled.value =
      preferences.getBool(_turnHighlightPreferenceKey) ?? true;
}

Future<void> saveTurnHighlightPreference(bool enabled) async {
  final preferences = await SharedPreferences.getInstance();
  final saved = await preferences.setBool(_turnHighlightPreferenceKey, enabled);
  if (!saved) {
    throw StateError('The turn highlight setting could not be saved.');
  }
  turnHighlightEnabled.value = enabled;
}

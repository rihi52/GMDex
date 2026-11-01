import 'package:flutter/material.dart';

import 'player_initiative_window_stub.dart'
    if (dart.library.io) 'player_initiative_window_io.dart'
    as implementation;

Future<int?> openOrFocusPlayerInitiativeWindow(
  BuildContext context,
  int? existingWindowId,
) {
  return implementation.openOrFocusPlayerInitiativeWindow(
    context,
    existingWindowId,
  );
}

Future<bool> closePlayerInitiativeWindow(int? windowId) {
  return implementation.closePlayerInitiativeWindow(windowId);
}

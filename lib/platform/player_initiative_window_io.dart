import 'package:flutter/material.dart';
import 'package:multiview_desktop/multiview_desktop.dart';
import 'package:gmdex/pages/player_face_combat.dart';

Future<int?> openOrFocusPlayerInitiativeWindow(
  BuildContext context,
  int? existingWindowId,
) async {
  if (existingWindowId != null &&
      MultiViewDesktop.allWindowViewIds.contains(existingWindowId)) {
    MultiViewDesktop.fromId(existingWindowId).focus();
    return existingWindowId;
  }

  return openWindow(
    (_, _) => const PlayerFacingCombatPage(),
    options: const WindowOptions(
      title: 'Player Initiative',
      size: Size(900, 600),
      minimumSize: Size(600, 400),
    ),
    parentContext: context,
  );
}

Future<bool> closePlayerInitiativeWindow(int? windowId) async {
  if (windowId == null ||
      !MultiViewDesktop.allWindowViewIds.contains(windowId)) {
    return true;
  }
  return MultiViewDesktop.fromId(windowId).closeWindow();
}

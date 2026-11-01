import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmdex/models/combat.dart';
import 'package:gmdex/pages/player_face_combat.dart';

void main() {
  testWidgets('player initiative view rebuilds from shared combat updates', (
    tester,
  ) async {
    updatePlayerFacingCombat(const []);
    addTearDown(() => updatePlayerFacingCombat(const []));

    await tester.pumpWidget(const MaterialApp(home: PlayerFacingCombatPage()));
    expect(find.text('Waiting for combat to start...'), findsOneWidget);

    updatePlayerFacingCombat(const [
      PlayerViewRow(name: 'Ravi', initiative: 12, isActive: true),
      PlayerViewRow(name: 'Goblin', initiative: 9, isActive: false),
      PlayerViewRow(name: 'Glimm', initiative: 7, isActive: false),
    ]);
    await tester.pump();

    expect(find.text('Ravi'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    expect(find.text('Goblin'), findsOneWidget);
    expect(find.text('9'), findsOneWidget);
    expect(find.text('Glimm'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
    expect(find.text('Waiting for combat to start...'), findsNothing);
  });

  testWidgets('player view shows combatant type, hit points, and conditions', (
    tester,
  ) async {
    final creatureRow = PlayerViewRow.fromCombatant(
      Combatant(
        name: 'Goblin',
        isPlayer: false,
        currentHitPoints: 12,
        maxHitPoints: 30,
        initiative: 9,
        quantity: 1,
        creatureId: 1,
        isProne: true,
        exhaustionLevel: 2,
      ),
    );
    final playerRow = PlayerViewRow.fromCombatant(
      Combatant(
        name: 'Ravi',
        isPlayer: true,
        maxHitPoints: 24,
        initiative: 12,
        quantity: 1,
        playerId: 1,
      ),
    );
    updatePlayerFacingCombat([creatureRow, playerRow]);
    addTearDown(() => updatePlayerFacingCombat(const []));

    await tester.pumpWidget(const MaterialApp(home: PlayerFacingCombatPage()));

    expect(creatureRow.isCreature, isTrue);
    expect(playerRow.isCreature, isFalse);
    expect(creatureRow.conditions, ['Exhaustion 2', 'Prone']);
    expect(find.text('12/30 HP'), findsOneWidget);
    expect(find.text('Prone'), findsOneWidget);
    expect(find.text('Exhaustion 2'), findsOneWidget);
    expect(find.text('24/24 HP'), findsOneWidget);
  });

  testWidgets('active combatant scrolls into view when the turn changes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 300);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(() => updatePlayerFacingCombat(const []));

    updatePlayerFacingCombat([
      for (var index = 0; index < 20; index++)
        PlayerViewRow(
          name: 'Combatant $index',
          initiative: 20 - index,
          isActive: index == 0,
        ),
    ]);

    await tester.pumpWidget(const MaterialApp(home: PlayerFacingCombatPage()));
    await tester.pumpAndSettle();

    updatePlayerFacingCombat([
      for (var index = 0; index < 20; index++)
        PlayerViewRow(
          name: 'Combatant $index',
          initiative: 20 - index,
          isActive: index == 19,
        ),
    ]);
    await tester.pumpAndSettle();

    final listRect = tester.getRect(find.byType(SingleChildScrollView));
    final activeRowRect = tester.getRect(find.text('Combatant 19'));
    expect(activeRowRect.top, greaterThanOrEqualTo(listRect.top));
    expect(activeRowRect.bottom, lessThanOrEqualTo(listRect.bottom));
  });
}

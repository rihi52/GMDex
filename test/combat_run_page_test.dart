import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmdex/components/combatant_card.dart';
import 'package:gmdex/models/combat.dart';
import 'package:gmdex/pages/player_face_combat.dart';
import 'package:gmdex/pages/combat_run_page.dart';
import 'package:gmdex/theme/apptheme.dart';
import 'package:gmdex/models/turn_highlight_preference.dart';

void main() {
  testWidgets(
    'safe area only applies to the narrow combat layout',
    (tester) async {
      tester.view.physicalSize = const Size(700, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: RunCombatPage()));
      final combatSafeArea = find.byKey(
        const ValueKey('combat-body-safe-area'),
      );
      expect(tester.widget<SafeArea>(combatSafeArea).bottom, isTrue);

      tester.view.physicalSize = const Size(1000, 900);
      await tester.pumpWidget(const MaterialApp(home: RunCombatPage()));
      expect(tester.widget<SafeArea>(combatSafeArea).bottom, isFalse);
    },
    variant: TargetPlatformVariant.desktop(),
  );

  testWidgets(
    'notes keyboard hides controls and gives more room to combatants',
    (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetViewInsets);

      await tester.pumpWidget(
        MaterialApp(
          home: RunCombatPage(
            encounter: Encounter(
              name: 'Test',
              currentTurnIndex: 0,
              combatants: [
                Combatant(
                  name: 'Goblin',
                  isPlayer: false,
                  maxHitPoints: 10,
                  initiative: 10,
                  quantity: 1,
                  creatureId: 1,
                ),
              ],
            ),
          ),
        ),
      );

      final listViewport = find.byType(SingleChildScrollView).first;
      final initialListHeight = tester.getSize(listViewport).height;
      final initialBodyHeight = tester
          .getSize(find.byKey(const ValueKey('combat-body-safe-area')))
          .height;

      expect(find.text('Next'), findsOneWidget);
      expect(find.text('Save & Exit'), findsOneWidget);
      await tester.tap(find.byType(TextField).last);
      tester.view.viewInsets = const FakeViewPadding(bottom: 320);
      await tester.pumpAndSettle();

      expect(find.text('Previous'), findsNothing);
      expect(find.text('Next'), findsNothing);
      expect(find.text('Edit'), findsNothing);
      expect(find.text('Save & Exit'), findsNothing);
      expect(find.text('Exit'), findsNothing);
      expect(
        tester.getSize(listViewport).height /
            tester
                .getSize(find.byKey(const ValueKey('combat-body-safe-area')))
                .height,
        greaterThan(initialListHeight / initialBodyHeight),
      );
    },
    variant: TargetPlatformVariant.mobile(),
  );

  testWidgets('hit point field accepts addition expressions', (tester) async {
    final combatant = Combatant(
      name: 'Goblin',
      isPlayer: false,
      currentHitPoints: 7,
      maxHitPoints: 10,
      initiative: 12,
      quantity: 1,
      creatureId: 1,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RunCombatantCard(
            isCreature: true,
            combatant: combatant,
            onDelete: () {},
            onInitiativeChanged: (_) {},
          ),
        ),
      ),
    );

    final hitPointField = find.byType(TextFormField).last;
    final textField = find.byType(TextField).last;
    final field = tester.widget<TextField>(textField);
    expect(field.keyboardType, TextInputType.text);

    await tester.enterText(hitPointField, '8+4');
    tester.widget<TextField>(textField).onSubmitted!('8+4');
    await tester.pump();

    expect(combatant.currentHitPoints, 12);
    expect(tester.widget<TextField>(textField).controller!.text, '12');
  });

  testWidgets('a new combat starts with the highest initiative active', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final combatants = [
      Combatant(
        name: 'Third',
        isPlayer: false,
        maxHitPoints: 10,
        initiative: 6,
        quantity: 1,
        creatureId: 1,
      ),
      Combatant(
        name: 'First',
        isPlayer: true,
        maxHitPoints: 10,
        initiative: 20,
        quantity: 1,
        playerId: 1,
      ),
      Combatant(
        name: 'Second',
        isPlayer: false,
        maxHitPoints: 10,
        initiative: 13,
        quantity: 1,
        creatureId: 2,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: RunCombatPage(
          encounter: Encounter(
            name: 'Test',
            currentTurnIndex: 0,
            combatants: combatants,
          ),
        ),
      ),
    );

    final cards = tester
        .widgetList<RunCombatantCard>(find.byType(RunCombatantCard))
        .toList();
    expect(cards.map((card) => card.combatant.name), [
      'First',
      'Second',
      'Third',
    ]);
    expect(cards.map((card) => card.isActiveTurn), [true, false, false]);
  });

  testWidgets('player-facing initiative follows active player turns', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(() => updatePlayerFacingCombat(const []));

    final encounter = Encounter(
      name: 'Test',
      currentTurnIndex: 0,
      combatants: [
        Combatant(
          name: 'Goblin',
          isPlayer: false,
          maxHitPoints: 10,
          initiative: 20,
          quantity: 1,
          creatureId: 1,
        ),
        Combatant(
          name: 'Ravi',
          isPlayer: true,
          maxHitPoints: 10,
          initiative: 12,
          quantity: 1,
          playerId: 1,
        ),
        Combatant(
          name: 'Glimm',
          isPlayer: true,
          maxHitPoints: 10,
          initiative: 7,
          quantity: 1,
          playerId: 2,
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Stack(
          children: [
            RunCombatPage(encounter: encounter),
            const IgnorePointer(child: PlayerFacingCombatPage()),
          ],
        ),
      ),
    );

    final playerView = find.byType(PlayerFacingCombatPage);
    expect(
      find.descendant(of: playerView, matching: find.text('Goblin')),
      findsNothing,
    );
    expect(
      find.descendant(of: playerView, matching: find.text('Enemy 1')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: playerView, matching: find.text('Ravi')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: playerView, matching: find.text('Glimm')),
      findsOneWidget,
    );

    Finder playerRow(String name) => find
        .ancestor(
          of: find.descendant(of: playerView, matching: find.text(name)),
          matching: find.byType(Container),
        )
        .first;

    BoxDecoration rowDecoration(String name) =>
        tester.widget<Container>(playerRow(name)).decoration! as BoxDecoration;

    expect(rowDecoration('Ravi').border!.top.color, Colors.transparent);

    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();
    expect(
      find.descendant(of: playerView, matching: find.text('Goblin')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: playerView, matching: find.text('Enemy 1')),
      findsNothing,
    );

    await tester.tap(find.text('Next'));
    await tester.pump();

    expect(rowDecoration('Ravi').border!.top.color, AppColors.accent);
  });

  testWidgets(
    'creatures stay masked until their Masked checkbox is cleared',
    (tester) async {
      addTearDown(() => updatePlayerFacingCombat(const []));
      final firstCreature = Combatant(
        name: 'Goblin',
        isPlayer: false,
        maxHitPoints: 10,
        initiative: 20,
        quantity: 1,
        creatureId: 1,
      );
      final secondCreature = Combatant(
        name: 'Ogre',
        isPlayer: false,
        maxHitPoints: 10,
        initiative: 10,
        quantity: 1,
        creatureId: 2,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Stack(
            children: [
              RunCombatPage(
                encounter: Encounter(
                  name: 'Test',
                  currentTurnIndex: 0,
                  combatants: [
                    firstCreature,
                    secondCreature,
                    Combatant(
                      name: 'Ravi',
                      isPlayer: true,
                      maxHitPoints: 10,
                      initiative: 5,
                      quantity: 1,
                      playerId: 1,
                    ),
                  ],
                ),
              ),
              const IgnorePointer(child: PlayerFacingCombatPage()),
            ],
          ),
        ),
      );

      final playerView = find.byType(PlayerFacingCombatPage);
      Finder playerFacing(String name) =>
          find.descendant(of: playerView, matching: find.text(name));

      expect(playerFacing('Enemy 1'), findsOneWidget);
      expect(playerFacing('Enemy 2'), findsOneWidget);
      expect(playerFacing('Goblin'), findsNothing);
      expect(playerFacing('Ogre'), findsNothing);

      await tester.tap(find.byType(Checkbox).first);
      await tester.pump();

      expect(firstCreature.isUnmasked, isTrue);
      expect(playerFacing('Goblin'), findsOneWidget);
      expect(playerFacing('Enemy 1'), findsNothing);
      expect(playerFacing('Enemy 2'), findsOneWidget);
      expect(playerFacing('Ogre'), findsNothing);

      await tester.enterText(
        find.byKey(const ValueKey('combatant-name-field')).first,
        'Goblin Captain',
      );
      await tester.pump();

      expect(firstCreature.name, 'Goblin Captain');
      expect(playerFacing('Goblin Captain'), findsOneWidget);
    },
    variant: TargetPlatformVariant.desktop(),
  );

  testWidgets('initiative turn advances with controls and spacebar', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final first = Combatant(
      name: 'Goblin',
      isPlayer: false,
      currentHitPoints: 7,
      maxHitPoints: 7,
      initiative: 15,
      quantity: 1,
      creatureId: 1,
    );
    final second = Combatant(
      name: 'Ravi',
      isPlayer: true,
      currentHitPoints: 20,
      maxHitPoints: 20,
      initiative: 10,
      quantity: 1,
      playerId: 1,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: RunCombatPage(
          encounter: Encounter(
            name: 'Test',
            currentTurnIndex: 0,
            combatants: [first, second],
          ),
        ),
      ),
    );

    List<RunCombatantCard> cards() => tester
        .widgetList<RunCombatantCard>(find.byType(RunCombatantCard))
        .toList();

    Color activeOutlineColor(int index) {
      final tile = tester.widget<ListTile>(
        find
            .descendant(
              of: find.byType(RunCombatantCard).at(index),
              matching: find.byType(ListTile),
            )
            .first,
      );
      return (tile.shape! as RoundedRectangleBorder).side.color;
    }

    expect(cards().map((card) => card.isActiveTurn), [true, false]);
    expect(activeOutlineColor(0), Colors.red);

    await tester.tap(find.text('Next'));
    await tester.pump();
    expect(cards().map((card) => card.isActiveTurn), [false, true]);
    expect(activeOutlineColor(1), Colors.red);

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(cards().map((card) => card.isActiveTurn), [true, false]);

    for (var i = 0; i < 8; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
    }
    expect(cards().map((card) => card.isActiveTurn), [true, false]);

    await tester.tap(find.text('Previous'));
    await tester.pump();
    expect(cards().map((card) => card.isActiveTurn), [false, true]);

    await tester.tap(find.byType(TextField).last);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(cards().map((card) => card.isActiveTurn), [false, true]);
  });

  testWidgets('turn controls are disabled when turn highlighting is off', (
    tester,
  ) async {
    turnHighlightEnabled.value = false;
    addTearDown(() => turnHighlightEnabled.value = true);
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: RunCombatPage(
          encounter: Encounter(
            name: 'Test',
            currentTurnIndex: 0,
            combatants: [
              Combatant(
                name: 'Goblin',
                isPlayer: false,
                maxHitPoints: 7,
                initiative: 15,
                quantity: 1,
                creatureId: 1,
              ),
              Combatant(
                name: 'Ravi',
                isPlayer: true,
                maxHitPoints: 20,
                initiative: 10,
                quantity: 1,
                playerId: 1,
              ),
            ],
          ),
        ),
      ),
    );

    for (final label in ['Previous', 'Next']) {
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, label),
      );
      expect(button.onPressed, isNull);
    }

    turnHighlightEnabled.value = true;
    await tester.pump();

    for (final label in ['Previous', 'Next']) {
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, label),
      );
      expect(button.onPressed, isNotNull);
    }
  });

  testWidgets('turn changes scroll the active combatant into view', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final combatants = List.generate(
      14,
      (index) => Combatant(
        name: 'Combatant $index',
        isPlayer: false,
        currentHitPoints: 10,
        maxHitPoints: 10,
        initiative: 30 - index,
        quantity: 1,
        creatureId: index + 1,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: RunCombatPage(
          encounter: Encounter(
            name: 'Test',
            currentTurnIndex: 0,
            combatants: combatants,
          ),
        ),
      ),
    );

    final listFinder = find.byType(SingleChildScrollView).first;
    for (var i = 0; i < 13; i++) {
      tester
          .widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Next'))
          .onPressed!
          .call();
      await tester.pumpAndSettle();
    }

    final activeCardIndex = tester
        .widgetList<RunCombatantCard>(find.byType(RunCombatantCard))
        .toList()
        .indexWhere((card) => card.isActiveTurn);
    expect(activeCardIndex, greaterThan(0));

    final listRect = tester.getRect(listFinder);
    final activeCardRect = tester.getRect(
      find.byType(RunCombatantCard).at(activeCardIndex),
    );
    expect(activeCardRect.top, greaterThan(listRect.top));
    expect(activeCardRect.bottom, lessThan(listRect.bottom));
  });

  testWidgets(
    'initiative sorting scrolls an off-screen active card into view',
    (tester) async {
      tester.view.physicalSize = const Size(800, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final combatants = List.generate(
        14,
        (index) => Combatant(
          name: 'Combatant $index',
          isPlayer: false,
          currentHitPoints: 10,
          maxHitPoints: 10,
          initiative: 30 - index,
          quantity: 1,
          creatureId: index + 1,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: RunCombatPage(
            encounter: Encounter(
              name: 'Test',
              currentTurnIndex: 0,
              combatants: combatants,
            ),
          ),
        ),
      );

      final activeCard = find.byType(RunCombatantCard).first;
      final initiativeField = find
          .descendant(of: activeCard, matching: find.byType(TextFormField))
          .first;
      tester.widget<TextFormField>(initiativeField).onChanged!('0');
      await tester.pumpAndSettle();

      final cards = tester
          .widgetList<RunCombatantCard>(find.byType(RunCombatantCard))
          .toList();
      final activeCardIndex = cards.indexWhere((card) => card.isActiveTurn);
      expect(activeCardIndex, cards.length - 1);

      final listRect = tester.getRect(find.byType(SingleChildScrollView).first);
      final activeCardRect = tester.getRect(
        find.byType(RunCombatantCard).at(activeCardIndex),
      );
      expect(activeCardRect.top, greaterThan(listRect.top));
      expect(activeCardRect.bottom, lessThan(listRect.bottom));
    },
  );
}

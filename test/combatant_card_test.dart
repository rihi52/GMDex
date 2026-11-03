import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmdex/components/combatant_card.dart';
import 'package:gmdex/components/responsive_layout.dart';
import 'package:gmdex/components/status_button.dart';
import 'package:gmdex/models/combat.dart';
import 'package:gmdex/models/turn_highlight_preference.dart';
import 'package:gmdex/pages/player_face_combat.dart';

void main() {
  testWidgets('status button width follows its label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              StatusButton(label: 'OK', height: 20),
              StatusButton(label: 'Charmed', height: 20),
            ],
          ),
        ),
      ),
    );

    final shortButtonWidth = tester
        .getSize(find.byType(StatusButton).first)
        .width;
    final longButtonWidth = tester
        .getSize(find.byType(StatusButton).last)
        .width;

    expect(find.text('Charmed'), findsOneWidget);
    expect(longButtonWidth, greaterThan(shortButtonWidth));
  });

  testWidgets('count fill button is a filled button and keeps stepped count', (
    tester,
  ) async {
    var changedCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CountFillButton(
            label: 'Exhaustion',
            tooltip: 'Exhaustion',
            layers: 6,
            height: 20,
            onChanged: (count) => changedCount = count,
          ),
        ),
      ),
    );

    expect(find.byType(FilledButton), findsOneWidget);
    expect(find.text('Exhaustion'), findsOneWidget);
    expect(tester.getSize(find.byType(CountFillButton)).height, 20);
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(changedCount, 1);
    expect(find.byTooltip('Exhaustion: 1/6'), findsOneWidget);
  });

  testWidgets('count fill button width follows its label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CountFillButton(label: 'HP', tooltip: 'Hit points', height: 20),
              CountFillButton(
                label: 'Exhaustion',
                tooltip: 'Exhaustion',
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );

    final shortWidth = tester.getSize(find.byType(CountFillButton).first).width;
    final longWidth = tester.getSize(find.byType(CountFillButton).last).width;

    expect(longWidth, greaterThan(shortWidth));
  });

  testWidgets('evaluates HP addition and subtraction on submit', (
    tester,
  ) async {
    var changedCount = 0;
    final combatant = Combatant(
      name: 'Goblin',
      isPlayer: false,
      currentHitPoints: 30,
      maxHitPoints: 30,
      initiative: 10,
      quantity: 1,
      creatureId: 1,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            child: RunCombatantCard(
              isCreature: true,
              combatant: combatant,
              onDelete: () {},
              onInitiativeChanged: (_) {},
              onCombatantChanged: () => changedCount++,
            ),
          ),
        ),
      ),
    );

    final hitPointsField = find.byType(TextFormField).last;
    expect(find.text('HP'), findsOneWidget);
    expect(
      tester.widget<EditableText>(find.byType(EditableText).last).keyboardType,
      TextInputType.text,
    );
    await tester.enterText(hitPointsField, '30-15');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    final field = tester.widget<TextFormField>(hitPointsField);
    expect(field.controller!.text, '15');
    expect(combatant.currentHitPoints, 15);
    expect(changedCount, greaterThan(0));

    await tester.enterText(hitPointsField, '12a+3');
    expect(
      tester.widget<TextFormField>(hitPointsField).controller!.text,
      '12+3',
    );
  });

  testWidgets('runtime condition changes notify the player-facing view', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final combatant = Combatant(
      name: 'Goblin',
      isPlayer: false,
      currentHitPoints: 30,
      maxHitPoints: 30,
      initiative: 10,
      quantity: 1,
      creatureId: 1,
    );
    void publish() {
      updatePlayerFacingCombat([
        PlayerViewRow.fromCombatant(combatant, maskedName: 'Enemy 1'),
      ]);
    }

    publish();
    addTearDown(() => updatePlayerFacingCombat(const []));

    await tester.pumpWidget(
      MaterialApp(
        home: Row(
          children: [
            SizedBox(
              width: 700,
              child: Material(
                child: SingleChildScrollView(
                  child: RunCombatantCard(
                    isCreature: true,
                    combatant: combatant,
                    onDelete: () {},
                    onInitiativeChanged: (_) {},
                    onCombatantChanged: publish,
                  ),
                ),
              ),
            ),
            const Expanded(child: PlayerFacingCombatPage()),
          ],
        ),
      ),
    );

    expect(find.text('Frightened'), findsNothing);
    expect(find.text('Enemy 1'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).last, '30-18');
    await tester.pump();
    expect(combatant.currentHitPoints, 12);
    expect(find.text('12/30 HP'), findsOneWidget);

    await tester.tap(find.text('Conditions'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(StatusButton, 'Frightened'));
    await tester.pump();

    expect(combatant.isFrightened, isTrue);
    expect(find.text('Frightened'), findsNWidgets(2));

    await tester.tap(find.widgetWithText(StatusButton, 'Frightened'));
    await tester.pump();

    expect(combatant.isFrightened, isFalse);
    expect(find.text('Frightened'), findsOneWidget);

    await tester.tap(find.byType(Checkbox).last);
    await tester.pump();
    expect(combatant.isUnmasked, isTrue);
    expect(find.text('Goblin'), findsOneWidget);
    expect(find.text('Enemy 1'), findsNothing);

    await tester.tap(find.byType(Checkbox).last);
    await tester.pump();
    expect(combatant.isUnmasked, isFalse);
    expect(find.text('Enemy 1'), findsOneWidget);
  });

  testWidgets('initiative field uses a compact in-field label', (tester) async {
    final combatant = Combatant(
      name: 'Goblin',
      isPlayer: false,
      maxHitPoints: 30,
      initiative: 10,
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

    expect(find.text('Init '), findsOneWidget);
  });

  testWidgets(
    'desktop combatant name editor has a bounded width',
    (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final combatant = Combatant(
        name: 'Goblin',
        isPlayer: false,
        maxHitPoints: 30,
        initiative: 10,
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

      expect(
        tester
            .getSize(find.byKey(const ValueKey('combatant-name-field')))
            .width,
        275,
      );
    },
    variant: TargetPlatformVariant.desktop(),
  );

  testWidgets(
    'desktop player name remains read-only',
    (tester) async {
      final combatant = Combatant(
        name: 'Ravi',
        isPlayer: true,
        maxHitPoints: 30,
        initiative: 10,
        quantity: 1,
        playerId: 1,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RunCombatantCard(
              isCreature: false,
              combatant: combatant,
              onDelete: () {},
              onInitiativeChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('combatant-name-field')), findsNothing);
      expect(find.text('Ravi'), findsOneWidget);
    },
    variant: TargetPlatformVariant.desktop(),
  );

  testWidgets('active turn red outline follows the highlight preference', (
    tester,
  ) async {
    turnHighlightEnabled.value = true;
    final combatant = Combatant(
      name: 'Goblin',
      isPlayer: false,
      maxHitPoints: 30,
      initiative: 10,
      quantity: 1,
      creatureId: 1,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RunCombatantCard(
            isCreature: true,
            combatant: combatant,
            isActiveTurn: true,
            onDelete: () {},
            onInitiativeChanged: (_) {},
          ),
        ),
      ),
    );

    ListTile activeTile() =>
        tester.widget<ListTile>(find.byType(ListTile).first);
    RoundedRectangleBorder shape() =>
        activeTile().shape! as RoundedRectangleBorder;

    expect(shape().side.color, Colors.red);

    turnHighlightEnabled.value = false;
    await tester.pump();

    expect(shape().side.color, Colors.transparent);
    turnHighlightEnabled.value = true;
  });

  testWidgets('status controls update the combatant model', (tester) async {
    final combatant = Combatant(
      name: 'Goblin',
      isPlayer: false,
      currentHitPoints: 30,
      maxHitPoints: 30,
      initiative: 10,
      quantity: 1,
      creatureId: 1,
      isCharmed: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            child: BuildCombatantCard(
              isCreature: true,
              combatant: combatant,
              onDelete: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Blinded'), findsNothing);
    await tester.tap(find.text('Conditions'));
    await tester.pumpAndSettle();
    final charmedButton = tester.widget<StatusButton>(
      find.widgetWithText(StatusButton, 'Charmed'),
    );
    expect(charmedButton.initiallySelected, isTrue);
    expect(find.text('Blinded'), findsOneWidget);
    await tester.tap(find.text('Blinded'));
    await tester.pump();
    expect(combatant.isBlinded, isTrue);
    await tester.tap(find.text('Charmed'));
    await tester.pump();
    expect(combatant.isCharmed, isFalse);

    await tester.tap(find.text('Exhaustion'));
    await tester.pump();
    expect(combatant.exhaustionLevel, 1);
  });

  testWidgets(
    'creature is masked by default and can be unmasked in builder',
    (tester) async {
      final combatant = Combatant(
        name: 'Goblin',
        isPlayer: false,
        maxHitPoints: 30,
        initiative: 10,
        quantity: 1,
        creatureId: 1,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => BuildCombatantCard(
                isCreature: true,
                combatant: combatant,
                onDelete: () {},
                onMaskedChanged: (_) => setState(() {}),
              ),
            ),
          ),
        ),
      );

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);
      expect(combatant.isUnmasked, isFalse);

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isFalse);
      expect(combatant.isUnmasked, isTrue);
    },
    variant: TargetPlatformVariant.desktop(),
  );

  testWidgets(
    'mask checkboxes are hidden on mobile',
    (tester) async {
      final combatant = Combatant(
        name: 'Goblin',
        isPlayer: false,
        maxHitPoints: 30,
        initiative: 10,
        quantity: 1,
        creatureId: 1,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BuildCombatantCard(
              isCreature: true,
              combatant: combatant,
              onDelete: () {},
            ),
          ),
        ),
      );
      expect(find.byType(Checkbox), findsNothing);

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
      expect(find.byType(Checkbox), findsNothing);
    },
    variant: TargetPlatformVariant.mobile(),
  );

  testWidgets('collapsed conditions tile indicates an active condition', (
    tester,
  ) async {
    final combatant = Combatant(
      name: 'Goblin',
      isPlayer: false,
      maxHitPoints: 30,
      initiative: 10,
      quantity: 1,
      creatureId: 1,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BuildCombatantCard(
            isCreature: true,
            combatant: combatant,
            onDelete: () {},
          ),
        ),
      ),
    );

    expect(find.byTooltip('Active conditions'), findsNothing);
    await tester.tap(find.text('Conditions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Charmed'));
    await tester.pumpAndSettle();

    expect(combatant.isCharmed, isTrue);
    expect(find.byTooltip('Active conditions'), findsOneWidget);

    await tester.tap(find.text('Conditions'));
    await tester.pumpAndSettle();
    expect(find.text('Charmed'), findsNothing);
    expect(find.byTooltip('Active conditions'), findsOneWidget);
  });

  testWidgets('quantity field updates the combatant as it is edited', (
    tester,
  ) async {
    final combatant = Combatant(
      name: 'Goblin',
      isPlayer: false,
      maxHitPoints: 7,
      initiative: 10,
      quantity: 1,
      creatureId: 1,
    );
    int? updatedQuantity;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            child: BuildCombatantCard(
              isCreature: true,
              combatant: combatant,
              onDelete: () {},
              onQuantityChanged: (quantity) => updatedQuantity = quantity,
            ),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).last, '3');

    expect(combatant.quantity, 3);
    expect(updatedQuantity, 3);
  });

  testWidgets(
    'builder quantity field is narrower only on mobile',
    (tester) async {
      final combatant = Combatant(
        name: 'Goblin',
        isPlayer: false,
        maxHitPoints: 7,
        initiative: 10,
        quantity: 1,
        creatureId: 1,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: BuildCombatantCard(
                isCreature: true,
                combatant: combatant,
                onDelete: () {},
              ),
            ),
          ),
        ),
      );

      expect(
        tester.getSize(find.byType(TextFormField).last).width,
        ResponsiveLayout.isMobilePlatform ? 60 : 75,
      );
    },
    variant: TargetPlatformVariant.all(),
  );
}

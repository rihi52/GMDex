import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmdex/components/combatant_card.dart';
import 'package:gmdex/database/database.dart';
import 'package:gmdex/database/database_initialize.dart';
import 'package:gmdex/database/encounter_writer.dart';
import 'package:gmdex/models/combat.dart';
import 'package:gmdex/pages/combat_page.dart';
import 'package:gmdex/pages/combat_run_page.dart';

void main() {
  late AppDatabase db;
  late List<int> playerIds;
  late int creatureId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    setDatabaseForTesting(db);
    playerIds = [];
    for (var index = 0; index < 12; index++) {
      playerIds.add(
        await db
            .into(db.players)
            .insert(
              PlayersCompanion.insert(
                pName: 'Player $index',
                pClass: 'Fighter',
              ),
            ),
      );
    }
    creatureId = await db
        .into(db.creatures)
        .insert(
          CreaturesCompanion.insert(name: 'Goblin', hitPoints: const Value(10)),
        );
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('entered initiative survives saving, reopening, and starting', (
    tester,
  ) async {
    Encounter encounter = Encounter(
      name: 'Initiative test',
      currentTurnIndex: 0,
      combatants: [
        _player(0, playerIds[0]),
        Combatant(
          name: 'Goblin',
          isPlayer: false,
          maxHitPoints: 10,
          initiative: 0,
          quantity: 1,
          creatureId: creatureId,
        ),
      ],
    );
    await _openBuilder(tester, () => encounter);
    await _enterInitiative(tester, 'Player 0', '17');
    await _enterInitiative(tester, 'Goblin', '11');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final saved = await db.select(db.encounters).getSingle();
    encounter = (await loadEncounter(db, saved.id))!;
    expect(_initiatives(encounter), {'Player 0': 17, 'Goblin': 11});

    await tester.tap(find.text('Open builder'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();
    final started = tester.widget<RunCombatPage>(find.byType(RunCombatPage));
    expect(_initiatives(started.encounter!), {'Player 0': 17, 'Goblin': 11});
  });

  testWidgets('ally changes survive builder and live combat saves', (
    tester,
  ) async {
    Encounter encounter = Encounter(
      name: 'Ally test',
      currentTurnIndex: 0,
      combatants: [
        Combatant(
          name: 'Goblin',
          isPlayer: false,
          maxHitPoints: 10,
          initiative: 11,
          quantity: 1,
          creatureId: creatureId,
        ),
      ],
    );
    await _openBuilder(tester, () => encounter);
    final ally = find.byKey(const ValueKey('combatant-ally-checkbox'));
    await tester.tap(ally);
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final saved = await db.select(db.encounters).getSingle();
    encounter = (await loadEncounter(db, saved.id))!;
    expect(encounter.combatants.single.isAlly, isTrue);
    await tester.tap(find.text('Open builder'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();
    expect(tester.widget<Checkbox>(ally).value, isTrue);

    await tester.tap(ally);
    await tester.pump();
    await tester.tap(find.text('Save & Exit'));
    await tester.pumpAndSettle();
    expect(
      (await loadEncounter(db, saved.id))!.combatants.single.isAlly,
      isFalse,
    );
  });

  for (final action in ['Start', 'Save']) {
    testWidgets('initiative survives scrolling out of view before $action', (
      tester,
    ) async {
      final encounter = Encounter(
        name: 'Long encounter',
        currentTurnIndex: 0,
        combatants: [
          for (var index = 0; index < playerIds.length; index++)
            _player(index, playerIds[index]),
        ],
      );
      await _openBuilder(tester, () => encounter);
      await _enterInitiative(tester, 'Player 0', '19');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();

      await _scrollToLastCombatant(tester);
      expect(_builderCard('Player 0'), findsNothing);
      expect(_builderCard('Player 11'), findsOneWidget);
      await _enterInitiative(tester, 'Player 11', '8');
      await tester.tap(find.text(action));
      await tester.pumpAndSettle();

      final Encounter result;
      if (action == 'Start') {
        result = tester
            .widget<RunCombatPage>(find.byType(RunCombatPage))
            .encounter!;
      } else {
        final saved = await db.select(db.encounters).getSingle();
        result = (await loadEncounter(db, saved.id))!;
      }
      expect(_initiatives(result)['Player 11'], 8);
      expect(_initiatives(result)['Player 0'], 19);
    });

    testWidgets(
      'rejects a blank initiative scrolled out of view before $action',
      (tester) async {
        final encounter = Encounter(
          name: 'Invalid initiative',
          currentTurnIndex: 0,
          combatants: [
            for (var index = 0; index < playerIds.length; index++)
              _player(index, playerIds[index]),
          ],
        );
        await _openBuilder(tester, () => encounter);
        await _enterInitiative(tester, 'Player 0', '');
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await _scrollToLastCombatant(tester);
        expect(_builderCard('Player 0'), findsNothing);

        await tester.tap(find.text(action));
        await tester.pumpAndSettle();

        expect(
          find.text('Enter a valid initiative for every combatant.'),
          findsOneWidget,
        );
        expect(find.byType(RunCombatPage), findsNothing);
        expect(await db.select(db.encounters).get(), isEmpty);
      },
    );
  }
}

Combatant _player(int index, int id) => Combatant(
  name: 'Player $index',
  isPlayer: true,
  maxHitPoints: 10,
  initiative: 0,
  quantity: 1,
  playerId: id,
);

Future<void> _openBuilder(
  WidgetTester tester,
  Encounter Function() encounter,
) async {
  tester.view.physicalSize = const Size(600, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      routes: {'/home': (_) => const Scaffold()},
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => EncounterBuildPage(encounter: encounter()),
              ),
            ),
            child: const Text('Open builder'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Open builder'));
  await tester.pumpAndSettle();
}

Finder _builderCard(String name) => find.byWidgetPredicate(
  (widget) => widget is BuildCombatantCard && widget.combatant.name == name,
);

Future<void> _scrollToLastCombatant(WidgetTester tester) async {
  for (var index = 0; index < 5; index++) {
    final scrollable = find
        .ancestor(
          of: find.byType(BuildCombatantCard).first,
          matching: find.byType(Scrollable),
        )
        .first;
    await tester.drag(scrollable, const Offset(0, -600));
    await tester.pumpAndSettle();
  }
}

Future<void> _enterInitiative(
  WidgetTester tester,
  String name,
  String value,
) async {
  final field = find.descendant(
    of: _builderCard(name),
    matching: find.widgetWithText(TextFormField, 'Init'),
  );
  await tester.ensureVisible(field);
  await tester.enterText(field, value);
  await tester.pumpAndSettle();
}

Map<String, int?> _initiatives(Encounter encounter) => {
  for (final combatant in encounter.combatants)
    combatant.name: combatant.initiative,
};

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmdex/components/player_edit.dart';
import 'package:gmdex/database/database.dart';
import 'package:gmdex/models/player_draft.dart';

void main() {
  testWidgets('player form loads and submits passive perception', (
    tester,
  ) async {
    PlayerDraft? savedDraft;
    final player = PlayerRow(
      pId: 1,
      pName: 'Ravi',
      pClass: 'Rogue',
      pPassivePerception: 16,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlayerDetailsEdit(
            player: player,
            isEditing: true,
            onSubmit: (draft) => savedDraft = draft,
          ),
        ),
      ),
    );

    final passivePerceptionField = find.byType(TextFormField).at(5);
    expect(find.text('Passive Perception'), findsOneWidget);
    expect(
      tester.widget<TextFormField>(passivePerceptionField).initialValue,
      '16',
    );

    await tester.enterText(passivePerceptionField, '18');
    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(savedDraft?.passivePerception, 18);
  });

  testWidgets('unset passive perception starts as an empty field', (
    tester,
  ) async {
    final player = PlayerRow(
      pId: 1,
      pName: 'Ravi',
      pClass: 'Rogue',
      pPassivePerception: null,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlayerDetailsEdit(
            player: player,
            isEditing: true,
            onSubmit: (_) {},
          ),
        ),
      ),
    );

    final passivePerceptionField = find.byType(TextFormField).at(5);
    expect(
      tester.widget<TextFormField>(passivePerceptionField).initialValue,
      '',
    );
  });
}

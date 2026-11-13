import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmdex/components/notes_drawer.dart';

void main() {
  testWidgets('notes label marks entities that have notes', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: NotesLabel(hasNotes: true))),
    );

    expect(find.text('Notes'), findsOneWidget);
    expect(find.byIcon(Icons.priority_high), findsOneWidget);

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: NotesLabel(hasNotes: false))),
    );

    expect(find.text('Notes'), findsOneWidget);
    expect(find.byIcon(Icons.priority_high), findsNothing);
  });

  testWidgets('notes icon fits within the 110 pixel button width', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 110,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: NotesLabel(
                hasNotes: true,
                style: ThemeData().textTheme.bodyLarge,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.priority_high), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

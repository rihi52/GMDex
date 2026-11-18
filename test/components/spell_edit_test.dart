import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmdex/components/spell_edit.dart';

void main() {
  testWidgets('selected spell level and school use bodySmall', (tester) async {
    final theme = ThemeData(
      textTheme: const TextTheme(
        bodySmall: TextStyle(fontSize: 13),
        bodyMedium: TextStyle(fontSize: 18),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Scaffold(body: SpellEdit(onSubmit: (_) {})),
      ),
    );

    await tester.tap(find.byType(DropdownButtonFormField<int>));
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(find.text('Level 1')).style?.fontSize,
      18,
    );
    await tester.tap(find.text('Level 1'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(find.text('Level 1')).style?.fontSize,
      13,
    );

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(find.text('Evocation')).style?.fontSize,
      18,
    );
    await tester.tap(find.text('Evocation'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(find.text('Evocation')).style?.fontSize,
      13,
    );
  });
}

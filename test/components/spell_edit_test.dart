import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmdex/components/spell_edit.dart';
import 'package:gmdex/database/database.dart';
import 'package:gmdex/models/spell_draft.dart';

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
    expect(tester.widget<Text>(find.text('Level 1')).style?.fontSize, 18);
    await tester.tap(find.text('Level 1'));
    await tester.pumpAndSettle();
    expect(tester.widget<Text>(find.text('Level 1')).style?.fontSize, 13);

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    expect(tester.widget<Text>(find.text('Evocation')).style?.fontSize, 18);
    await tester.tap(find.text('Evocation'));
    await tester.pumpAndSettle();
    expect(tester.widget<Text>(find.text('Evocation')).style?.fontSize, 13);
  });

  testWidgets('new spell checkbox is included in the submitted draft', (
    tester,
  ) async {
    SpellDraft? submitted;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SpellEdit(onSubmit: (draft) => submitted = draft)),
      ),
    );
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isFalse);
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'New Ritual');
    await _selectLevelAndSchool(tester);
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();
    expect(submitted?.isRitual, isTrue);
  });

  testWidgets('editing and copying initialize and submit the ritual choice', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await db
        .into(db.spells)
        .insert(
          SpellsCompanion.insert(
            name: 'Ritual Spell',
            source: 'PHB',
            level: 1,
            school: 'A',
            data: '{"meta":{"ritual":true}}',
          ),
        );
    final spell = await db.select(db.spells).getSingle();
    SpellDraft? submitted;

    for (final isEditing in [true, false]) {
      submitted = null;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SpellEdit(
              key: ValueKey(isEditing),
              spell: spell,
              isEditing: isEditing,
              onSubmit: (draft) => submitted = draft,
            ),
          ),
        ),
      );
      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);
      if (isEditing) {
        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();
      }
      await _selectLevelAndSchool(tester);
      await tester.tap(find.text(isEditing ? 'Save' : 'Create'));
      await tester.pumpAndSettle();
      expect(submitted?.isRitual, !isEditing);
    }
  });
}

Future<void> _selectLevelAndSchool(WidgetTester tester) async {
  await tester.tap(find.byType(DropdownButtonFormField<int>));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Level 1').last);
  await tester.pumpAndSettle();
  await tester.tap(find.byType(DropdownButtonFormField<String>));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Abjuration').last);
  await tester.pumpAndSettle();
}

import 'package:drift/drift.dart' show Value;
import 'package:gmdex/database/database.dart';

/// Saves free-form notes for a spell, storing blank notes as null.
Future<void> saveSpellNotes(AppDatabase db, int spellId, String notes) async {
  final normalized = notes.trim();
  await (db.update(
    db.spells,
  )..where((spell) => spell.id.equals(spellId))).write(
    SpellsCompanion(notes: Value(normalized.isEmpty ? null : normalized)),
  );
}

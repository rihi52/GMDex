// Persists creature notes in the separate notes table.
import 'package:gmdex/database/database.dart' hide CreatureSkills;
import 'package:gmdex/models/creature.dart';

/// Saves a note for the supplied creature or explicit existing row id.
///
/// A null note is ignored; whitespace is trimmed before writing. A missing
/// creature id is rejected before opening a transaction.
Future<void> saveNotes(
  AppDatabase db,
  Creature c, {
  int? existingId,
  String? notes,
}) {
  final creatureId = existingId ?? c.id;
  if (creatureId == null) {
    throw ArgumentError('A creature id is required to save notes.');
  }

  final body = (notes ?? c.notes)?.trim();
  if (body == null) return Future.value();

  return db.transaction(() async {
    await db
        .into(db.notes)
        .insert(NotesCompanion.insert(creatureId: creatureId, body: body));
  });
}

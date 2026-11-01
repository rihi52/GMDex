// Persists player drafts and player-note edits through Drift.
import 'package:drift/drift.dart';
import 'package:gmdex/database/database.dart';
import 'package:gmdex/models/player_draft.dart';

/// Inserts a new player or updates the row identified by [existingId].
///
/// Returns the inserted or updated database id. Optional text is normalized
/// before writing so whitespace-only campaign values are stored as null.
Future<int> savePlayer(
  AppDatabase db,
  PlayerDraft player, {
  int? existingId,
}) async {
  final fields = PlayersCompanion(
    pName: Value(player.name.trim()),
    pClass: Value(player.characterClass.trim()),
    pLevel: Value(player.level),
    pHitPoints: Value(player.hitPoints),
    pArmorClass: Value(player.armorClass),
    pPassivePerception: Value(player.passivePerception),
    pOriginalCampaign: Value(_blank(player.originalCampaign)),
  );

  if (existingId == null) {
    return db.into(db.players).insert(fields);
  }

  await (db.update(
    db.players,
  )..where((row) => row.pId.equals(existingId))).write(fields);
  return existingId;
}

/// Replaces a player's notes after normalizing empty text to null.
Future<void> savePlayerNotes(AppDatabase db, int playerId, String notes) async {
  await (db.update(db.players)..where((row) => row.pId.equals(playerId))).write(
    PlayersCompanion(pNotes: Value(_blank(notes))),
  );
}

/// Trims optional text and represents blank values as null for the database.
String? _blank(String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}

import 'package:drift/drift.dart';
import 'package:gmdex/database/database.dart';

/// Watches for a catalog spell matching a creature statblock spell name.
///
/// Matching is trimmed and case-insensitive, so imported catalog entries link
/// to creature spell names without requiring a separate link table.
Stream<SpellRow?> watchSpellByName(AppDatabase db, String name) {
  final normalizedName = name.trim().toLowerCase();
  if (normalizedName.isEmpty) return Stream.value(null);

  return db
      .customSelect(
        'SELECT * FROM spells WHERE lower(trim(name)) = ? LIMIT 1',
        variables: [Variable.withString(normalizedName)],
        readsFrom: {db.spells},
      )
      .watch()
      .map((rows) => rows.isEmpty ? null : db.spells.map(rows.first.data));
}

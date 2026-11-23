import 'dart:convert';

import 'package:drift/drift.dart' show BooleanExpressionOperators, Value;
import 'package:gmdex/database/database.dart';
import 'package:gmdex/models/spell_draft.dart';

/// Thrown when another spell already has the requested name.
class SpellNameTaken implements Exception {
  SpellNameTaken(this.name);
  final String name;

  @override
  String toString() => 'A spell named "$name" already exists.';
}

/// Saves an edited or new spell while preserving unsupported imported fields.
///
/// Existing spells retain their source. New spells, including copies, use
/// [newSource]. Spell names are unique across all sources.
Future<int> saveSpell(
  AppDatabase db,
  SpellDraft draft, {
  int? existingId,
  String newSource = 'Custom',
}) {
  return db.transaction(() async {
    final name = draft.name.trim();
    if (name.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Cannot be blank.');
    }
    if (draft.level < 0 || draft.level > 9) {
      throw RangeError.range(draft.level, 0, 9, 'level');
    }
    if (draft.school.trim().isEmpty) {
      throw ArgumentError.value(draft.school, 'school', 'Cannot be blank.');
    }

    final SpellRow? existing;
    if (existingId == null) {
      existing = null;
    } else {
      existing = await (db.select(
        db.spells,
      )..where((spell) => spell.id.equals(existingId))).getSingle();
    }

    final clash =
        await (db.select(db.spells)..where(
              (spell) =>
                  spell.name.equals(name) &
                  spell.id.equals(existingId ?? -1).not(),
            ))
            .getSingleOrNull();
    if (clash != null) throw SpellNameTaken(name);

    final source = existing?.source ?? newSource;
    final data = existing == null
        ? <String, dynamic>{}
        : jsonDecode(existing.data) as Map<String, dynamic>;
    final meta = data['meta'];
    if (meta == null) {
      if (draft.isRitual) data['meta'] = {'ritual': true};
    } else if (meta is Map<String, dynamic>) {
      if (draft.isRitual) {
        meta['ritual'] = true;
      } else {
        meta.remove('ritual');
      }
    } else if (draft.isRitual) {
      throw const FormatException('Spell metadata must be a JSON object.');
    }
    data
      ..['name'] = name
      ..['source'] = source
      ..['level'] = draft.level
      ..['school'] = draft.school
      ..['entries'] = _paragraphs(draft.description)
      ..['entriesHigherLevel'] = _paragraphs(draft.higherLevel)
      ..['_gmdexEditor'] = {
        'castingTime': draft.castingTime.trim(),
        'range': draft.range.trim(),
        'components': draft.components.trim(),
        'duration': draft.duration.trim(),
      };

    final companion = SpellsCompanion(
      name: Value(name),
      source: Value(source),
      level: Value(draft.level),
      school: Value(draft.school.trim()),
      data: Value(jsonEncode(data)),
    );
    final current = existing;
    if (current == null) {
      return db.into(db.spells).insert(companion);
    }
    await (db.update(
      db.spells,
    )..where((spell) => spell.id.equals(current.id))).write(companion);
    return current.id;
  });
}

List<String> _paragraphs(String text) => text
    .split(RegExp(r'\n\s*\n'))
    .map((paragraph) => paragraph.trim())
    .where((paragraph) => paragraph.isNotEmpty)
    .toList();

/// Saves free-form notes for a spell, storing blank notes as null.
Future<void> saveSpellNotes(AppDatabase db, int spellId, String notes) async {
  final normalized = notes.trim();
  await (db.update(
    db.spells,
  )..where((spell) => spell.id.equals(spellId))).write(
    SpellsCompanion(notes: Value(normalized.isEmpty ? null : normalized)),
  );
}

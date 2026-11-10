import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:gmdex/database/database.dart';

const maxSpellImportSizeBytes = 16 * 1024 * 1024;

/// Seeds missing SRD spells without replacing higher-priority definitions.
Future<int> importSpells(
  AppDatabase db, {
  String asset = 'assets/spells-srd.json',
}) async {
  return importSpellsJson(db, await rootBundle.loadString(asset));
}

/// Imports spell definitions from a JSON document with a `spell` array.
///
/// The complete source object is stored in [Spells.data] so fields not yet
/// exposed by the database remain available to future consumers.
Future<int> importSpellsJson(AppDatabase db, String jsonContent) async {
  if (utf8.encode(jsonContent).length > maxSpellImportSizeBytes) {
    throw const FormatException('Spell JSON files must be 16 MiB or smaller.');
  }

  final decoded = jsonDecode(jsonContent);
  if (decoded is! Map<String, dynamic> || decoded['spell'] is! List) {
    throw const FormatException(
      'Expected a spell JSON object containing a "spell" array.',
    );
  }

  final spells = decoded['spell'] as List;
  return db.transaction(() async {
    for (var index = 0; index < spells.length; index++) {
      final rawSpell = spells[index];
      if (rawSpell is! Map<String, dynamic> ||
          rawSpell['name'] is! String ||
          (rawSpell['name'] as String).trim().isEmpty ||
          rawSpell['source'] is! String ||
          (rawSpell['source'] as String).trim().isEmpty ||
          rawSpell['level'] is! int ||
          rawSpell['school'] is! String ||
          (rawSpell['school'] as String).trim().isEmpty) {
        throw FormatException('Spell $index is missing required fields.');
      }

      final name = rawSpell['name'] as String;
      final source = rawSpell['source'] as String;
      final existing =
          await (db.select(db.spells)
                ..where((spell) => spell.name.equals(name))
                ..limit(1))
              .getSingleOrNull();
      if (source == 'SRD' && existing != null && existing.source != 'SRD') {
        continue;
      }

      final companion = SpellsCompanion.insert(
        name: name,
        source: source,
        level: rawSpell['level'] as int,
        school: rawSpell['school'] as String,
        data: jsonEncode(rawSpell),
      );
      if (existing == null) {
        await db.into(db.spells).insert(companion);
      } else {
        await (db.update(
          db.spells,
        )..where((spell) => spell.id.equals(existing.id))).write(companion);
      }
    }

    return spells.length;
  });
}

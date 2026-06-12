import 'dart:convert';
import 'dart:io';

void main() {
  final monstersPath = 'assets/monsters.json';
  final bestiaryPath = 'assets/bestiary-srd.json';
  final outPath = 'assets/bestiary-srd.filtered.json';

  final monstersFile = File(monstersPath);
  final bestiaryFile = File(bestiaryPath);
  if (!monstersFile.existsSync()) {
    stderr.writeln('Monsters file not found: $monstersPath');
    exit(1);
  }
  if (!bestiaryFile.existsSync()) {
    stderr.writeln('Bestiary file not found: $bestiaryPath');
    exit(1);
  }

  final monstersJson = jsonDecode(monstersFile.readAsStringSync());
  final bestiaryJson = jsonDecode(bestiaryFile.readAsStringSync());

  final monsterNames = <String>{};
  if (monstersJson is List) {
    for (var m in monstersJson) {
      if (m is Map && m.containsKey('name')) {
        final name = (m['name']?.toString() ?? '').trim().toLowerCase();
        if (name.isNotEmpty) monsterNames.add(name);
      }
    }
  }

  if (bestiaryJson is Map && bestiaryJson.containsKey('monster')) {
    final List entries = bestiaryJson['monster'];
    final List outEntries = [];
    for (var e in entries) {
      if (e is Map) {
        final name = (e['name']?.toString() ?? '').trim().toLowerCase();
        if (monsterNames.contains(name)) {
          // For entries that exist in monsters.json, keep structure but
          // blank out metadata/tag fields that monsters.json doesn't contain.
          final metadataKeys = {
            'source',
            'page',
            'referenceSources',
            'basicRules',
            'group',
            'dragonCastingColor',
            'dragonAge',
            'soundClip',
            'traitTags',
            'senseTags',
            'actionTags',
            'languageTags',
            'damageTags',
            'damageTagsLegendary',
            'damageTagsSpell',
            'miscTags',
            'conditionInflict',
            'conditionInflictLegendary',
            'savingThrowForced',
            'savingThrowForcedLegendary',
            'hasToken',
            'hasFluff',
            'hasFluffImages',
            'legendaryGroup',
            'variant',
            'attachedItems',
            'spellcastingTags',
          };
          final Map m = Map.from(e);
          for (var k in metadataKeys) {
            if (m.containsKey(k)) {
              m[k] = blankify(m[k]);
            }
          }
          outEntries.add(m);
        } else {
          outEntries.add(blankify(e));
        }
      } else {
        outEntries.add(e);
      }
    }
    final out = {'monster': outEntries};
    File(
      outPath,
    ).writeAsStringSync(const JsonEncoder.withIndent('    ').convert(out));
    print('Wrote $outPath');
  } else {
    stderr.writeln('Bestiary JSON does not have top-level "monster" array');
    exit(1);
  }
}

dynamic blankify(dynamic value) {
  if (value is Map) {
    final Map m = {};
    value.forEach((k, v) {
      m[k] = blankify(v);
    });
    return m;
  } else if (value is List) {
    return <dynamic>[];
  } else {
    return "";
  }
}

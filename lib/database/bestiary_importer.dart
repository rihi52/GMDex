import 'dart:convert';

import 'package:drift/drift.dart' show InsertMode, Value;
import 'package:flutter/services.dart' show rootBundle;

import 'package:gmdex/database/database.dart';
import 'package:gmdex/database/read.dart'
    show alignmentNames, parseEntries, sizeNames;

class ImportResult {
  int imported = 0;
  int skipped = 0; // duplicates and `_copy` entries
  final List<String> failed = [];

  @override
  String toString() =>
      'imported $imported, skipped $skipped, failed ${failed.length}';
}

const _actionKinds = [
  'action',
  'bonus',
  'reaction',
  'legendary',
  'special',
  'villain',
];
const _saveKeys = {'str', 'dex', 'con', 'int', 'wis', 'cha'};

/// Safe to run more than once: creatures and groups already in the
/// database (matched on name + source) are skipped.
Future<ImportResult> importBestiary(
  AppDatabase db, {
  List<String> bestiaryAssets = const ['assets/bestiary-mm.json'],
  String legendaryGroupsAsset = 'assets/legendarygroups.json',
}) async {
  final result = ImportResult();

  await db.transaction(() async {
    final groupIds = await _importLegendaryGroups(db, legendaryGroupsAsset);

    final existing = <String>{
      for (final c in await db.select(db.creatures).get())
        '${c.name}|${c.source}',
    };

    for (final asset in bestiaryAssets) {
      final json = jsonDecode(await rootBundle.loadString(asset));
      for (final raw in (json['monster'] as List)) {
        final data = raw as Map<String, dynamic>;
        final name = data['name'] as String?;
        final source = (data['source'] as String?) ?? '';

        if (name == null ||
            data.containsKey('_copy') ||
            existing.contains('$name|$source')) {
          result.skipped++;
          continue;
        }

        try {
          await db.transaction(
            () => _insertCreature(db, data, name, source, groupIds),
          );
          existing.add('$name|$source');
          result.imported++;
        } catch (e) {
          result.failed.add('$name ($source): $e');
        }
      }
    }
  });

  return result;
}

// ---------------------------------------------------------------------------
// Legendary groups
// ---------------------------------------------------------------------------

Future<Map<String, int>> _importLegendaryGroups(
  AppDatabase db,
  String asset,
) async {
  final ids = <String, int>{
    for (final g in await db.select(db.legendaryGroups).get())
      '${g.name}_${g.source}': g.id,
  };

  final json = jsonDecode(await rootBundle.loadString(asset));
  for (final raw in (json['legendaryGroup'] as List)) {
    final g = raw as Map<String, dynamic>;
    final name = g['name'] as String?;
    final source = g['source'] as String?;
    if (name == null || source == null || g.containsKey('_copy')) continue;

    final key = '${name}_$source';
    if (ids.containsKey(key)) continue;

    final groupId = await db
        .into(db.legendaryGroups)
        .insert(
          LegendaryGroupsCompanion.insert(
            name: name,
            source: source,
            page: Value(_int(g['page'])),
          ),
        );
    ids[key] = groupId;

    final rows = [
      ..._groupEntries(groupId, 'lair', g['lairActions']),
      ..._groupEntries(groupId, 'regional', g['regionalEffects']),
    ];
    await db.batch((b) => b.insertAll(db.legendaryGroupEntries, rows));
  }
  return ids;
}

List<LegendaryGroupEntriesCompanion> _groupEntries(
  int groupId,
  String section,
  dynamic list,
) {
  if (list is! List) return const [];
  final rows = <LegendaryGroupEntriesCompanion>[];

  void add(String kind, String body, {String? title}) {
    rows.add(
      LegendaryGroupEntriesCompanion.insert(
        groupId: groupId,
        section: section,
        kind: kind,
        body: body,
        sortOrder: rows.length,
        title: Value(title),
      ),
    );
  }

  for (final e in list) {
    if (e is String) {
      add('text', _clean(e));
    } else if (e is Map && e['type'] == 'list') {
      for (final item in (e['items'] as List? ?? const [])) {
        if (item is String) {
          add('bullet', _clean(item));
        } else if (item is Map) {
          add(
            'bullet',
            _text(item['entries'] ?? item['entry']),
            title: item['name'] == null ? null : _clean('${item['name']}'),
          );
        }
      }
    } else if (e is Map && e['entries'] != null) {
      add(
        'entry',
        _text(e['entries']),
        title: e['name'] == null ? null : _clean('${e['name']}'),
      );
    }
  }
  return rows;
}

// ---------------------------------------------------------------------------
// Creatures
// ---------------------------------------------------------------------------

Future<void> _insertCreature(
  AppDatabase db,
  Map<String, dynamic> d,
  String name,
  String source,
  Map<String, int> groupIds,
) async {
  final ac = (d['ac'] as List?) ?? const [];
  final firstAc = ac.isEmpty ? null : ac.first;
  final hp = d['hp'];
  final speed = d['speed'];
  final cr = d['cr'];
  final group = d['legendaryGroup'];

  final id = await db
      .into(db.creatures)
      .insert(
        CreaturesCompanion.insert(
          name: name,
          source: Value(source),
          page: Value(_int(d['page'])),
          isSrd: Value(d['srd'] == true),
          size: Value(_size(d['size'])),
          type: Value(_typeName(d['type'])),
          typeTags: Value(_typeTags(d['type'])),
          alignment: Value(_alignment(d['alignment'])),
          armorClass: Value(
            firstAc is Map ? _int(firstAc['ac']) : _int(firstAc),
          ),
          armorClassType: Value(
            firstAc is Map ? _joinClean(firstAc['from']) : null,
          ),
          armorClassOther: Value(_otherAc(ac)),
          hitPoints: Value(hp is Map ? _int(hp['average']) : null),
          hitPointFormula: Value(hp is Map ? hp['formula']?.toString() : null),
          speedWalk: Value(_speed(speed is Map ? speed['walk'] : null)),
          speedFly: Value(_speed(speed is Map ? speed['fly'] : null)),
          speedSwim: Value(_speed(speed is Map ? speed['swim'] : null)),
          speedClimb: Value(_speed(speed is Map ? speed['climb'] : null)),
          speedBurrow: Value(_speed(speed is Map ? speed['burrow'] : null)),
          strength: Value(_int(d['str']) ?? 10),
          dexterity: Value(_int(d['dex']) ?? 10),
          constitution: Value(_int(d['con']) ?? 10),
          intelligence: Value(_int(d['int']) ?? 10),
          wisdom: Value(_int(d['wis']) ?? 10),
          charisma: Value(_int(d['cha']) ?? 10),
          passivePerception: Value(_int(d['passive'])),
          challengeRating: Value(
            cr is Map ? cr['cr']?.toString() : cr?.toString(),
          ),
          challengeRatingLair: Value(cr is Map ? cr['lair']?.toString() : null),
          challengeRatingCoven: Value(
            cr is Map ? cr['coven']?.toString() : null,
          ),
          xpOverride: Value(cr is Map ? _int(cr['xp']) : null),
          damageVulnerabilities: Value(_damage(d['vulnerable'])),
          damageResistances: Value(_damage(d['resist'])),
          damageImmunities: Value(_damage(d['immune'])),
          conditionImmunities: Value(_damage(d['conditionImmune'])),
          legendaryGroupId: Value(
            group is Map ? groupIds['${group['name']}_${group['source']}'] : null,
          ),
        ),
      );

  // ----- saves & skills -----
  final saves = <CreatureSavesCompanion>[];
  if (d['save'] is Map) {
    for (final e in (d['save'] as Map).entries) {
      final key = '${e.key}';
      final bonus = _int(e.value);
      if (_saveKeys.contains(key) && bonus != null) {
        saves.add(
          CreatureSavesCompanion.insert(
            creatureId: id,
            ability: key,
            bonus: bonus,
          ),
        );
      }
    }
  }

  final skills = <CreatureSkillsCompanion>[];
  if (d['skill'] is Map) {
    for (final e in (d['skill'] as Map).entries) {
      final bonus = _int(e.value); // skips non-numeric keys like `other`
      if (bonus != null) {
        skills.add(
          CreatureSkillsCompanion.insert(
            creatureId: id,
            skill: _camel('${e.key}'),
            bonus: bonus,
          ),
        );
      }
    }
  }

  // ----- simple lists -----
  final senses = [
    for (final s in _strings(d['senses']))
      CreatureSensesCompanion.insert(creatureId: id, sense: s),
  ];
  final languages = [
    for (final s in _strings(d['languages']))
      CreatureLanguagesCompanion.insert(creatureId: id, language: s),
  ];
  final environments = [
    for (final s in _strings(d['environment']))
      CreatureEnvironmentsCompanion.insert(creatureId: id, environment: s),
  ];

  // ----- traits & actions -----
  final traits = <CreatureTraitsCompanion>[];
  final traitList = (d['trait'] as List?) ?? const [];
  for (var i = 0; i < traitList.length; i++) {
    final t = traitList[i] as Map;
    traits.add(
      CreatureTraitsCompanion.insert(
        creatureId: id,
        name: _clean('${t['name'] ?? ''}'),
        description: _text(t['entries']),
        sortOrder: i,
      ),
    );
  }

  final actions = <CreatureActionsCompanion>[];
  for (final kind in _actionKinds) {
    final list = (d[kind] as List?) ?? const [];
    for (var i = 0; i < list.length; i++) {
      final a = list[i] as Map;
      actions.add(
        CreatureActionsCompanion.insert(
          creatureId: id,
          name: _clean('${a['name'] ?? ''}'),
          description: _text(a['entries']),
          sortOrder: i,
          kind: kind,
        ),
      );
    }
  }

  await db.batch((b) {
    const ignore = InsertMode.insertOrIgnore;
    b.insertAll(db.creatureSaves, saves, mode: ignore);
    b.insertAll(db.creatureSkills, skills, mode: ignore);
    b.insertAll(db.creatureSenses, senses, mode: ignore);
    b.insertAll(db.creatureLanguages, languages, mode: ignore);
    b.insertAll(db.creatureEnvironments, environments, mode: ignore);
    b.insertAll(db.creatureTraits, traits);
    b.insertAll(db.creatureActions, actions);
  });

  // ----- spellcasting (needs each block's id before its spells) -----
  final blocks = (d['spellcasting'] as List?) ?? const [];
  for (var i = 0; i < blocks.length; i++) {
    final b = blocks[i] as Map<String, dynamic>;

    final scId = await db
        .into(db.creatureSpellcastings)
        .insert(
          CreatureSpellcastingsCompanion.insert(
            creatureId: id,
            name: _clean('${b['name'] ?? 'Spellcasting'}'),
            headerText: Value(_textOrNull(b['headerEntries'])),
            footerText: Value(_textOrNull(b['footerEntries'])),
            ability: Value(b['ability']?.toString()),
            hiddenUses: Value((b['hidden'] as List?)?.join(',')),
            sortOrder: Value(i),
          ),
        );

    final spells = <CreatureSpellsCompanion>[];
    void add(dynamic raw, {int? level, String? uses, int? slots}) {
      final spell = raw is String
          ? raw
          : (raw is Map ? raw['entry']?.toString() : null);
      if (spell == null) return;
      spells.add(
        CreatureSpellsCompanion.insert(
          spellcastingId: scId,
          spellName: _clean(spell),
          sortOrder: spells.length,
          spellLevel: Value(level),
          uses: Value(uses),
          slots: Value(slots),
        ),
      );
    }

    for (final s in (b['will'] as List? ?? const [])) {
      add(s, uses: 'will');
    }
    (b['daily'] as Map?)?.forEach((key, list) {
      for (final s in (list as List? ?? const [])) {
        add(s, uses: '$key'); // '1', '1e', '2e', ...
      }
    });
    (b['spells'] as Map?)?.forEach((key, value) {
      final level = int.tryParse('$key');
      if (level == null || value is! Map) return;
      final slots = _int(value['slots']);
      for (final s in (value['spells'] as List? ?? const [])) {
        add(s, level: level, slots: slots);
      }
    });

    await db.batch((bt) => bt.insertAll(db.creatureSpells, spells));
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Strips {@tag ...} markup with your existing parseEntries.
String _clean(String s) => parseEntries([s]);

/// Turns an `entries` value (string, list, nested lists/blocks) into text.
String _text(dynamic entries) {
  if (entries == null) return '';
  return _clean(entries is List ? _flatten(entries) : '$entries');
}

String? _textOrNull(dynamic entries) {
  final t = _text(entries);
  return t.isEmpty ? null : t;
}

String _flatten(List entries) {
  final parts = <String>[];
  for (final e in entries) {
    if (e is String) {
      parts.add(e);
    } else if (e is Map) {
      if (e['type'] == 'list') {
        final lines = <String>[];
        for (final item in (e['items'] as List? ?? const [])) {
          if (item is String) {
            lines.add('• $item');
          } else if (item is Map) {
            final name = item['name'];
            final body = item['entries'] is List
                ? _flatten(item['entries'] as List)
                : '${item['entry'] ?? ''}';
            lines.add('• ${name != null ? '$name. ' : ''}$body');
          }
        }
        parts.add(lines.join('\n'));
      } else if (e['entries'] is List) {
        final name = e['name'];
        final body = _flatten(e['entries'] as List);
        parts.add(name != null ? '$name. $body' : body);
      }
    }
  }
  return parts.join('\n\n');
}

int? _int(dynamic v) =>
    v is int ? v : (v is num ? v.toInt() : (v is String ? int.tryParse(v) : null));

int? _speed(dynamic v) => v is Map ? _int(v['number']) : _int(v);

String? _size(dynamic v) {
  final code = v is List && v.isNotEmpty ? v.first : v;
  return code is String ? (sizeNames[code] ?? code) : null;
}

String? _alignment(dynamic v) {
  if (v is! List || v.isEmpty) return null;
  final parts = <String>[];
  for (final a in v) {
    if (a is String) {
      parts.add(alignmentNames[a] ?? a);
    } else if (a is Map) {
      final inner = _alignment(a['alignment']);
      if (inner != null) {
        parts.add(a['chance'] != null ? '$inner (${a['chance']}%)' : inner);
      }
    }
  }
  return parts.isEmpty ? null : parts.join(' ');
}

String? _typeName(dynamic t) {
  if (t is String) return t;
  if (t is Map) {
    final inner = t['type'];
    if (inner is String) return inner;
    if (inner is Map && inner['choose'] is List) {
      return (inner['choose'] as List).join(' or ');
    }
  }
  return null;
}

String? _typeTags(dynamic t) {
  if (t is! Map || t['tags'] is! List) return null;
  final tags = [
    for (final x in t['tags'] as List)
      if (x is String)
        x
      else if (x is Map && x['tag'] != null)
        '${x['tag']}',
  ];
  return tags.isEmpty ? null : tags.join(', ');
}

String? _joinClean(dynamic v) {
  if (v is! List) return null;
  final s = v.whereType<String>().map(_clean).where((x) => x.isNotEmpty);
  return s.isEmpty ? null : s.join(', ');
}

List<String> _strings(dynamic v) =>
    v is List ? [for (final e in v) if (e is String) _clean(e)] : <String>[];

/// 2nd and later AC entries, e.g. '15 (with mage armor)'.
String? _otherAc(List ac) {
  if (ac.length < 2) return null;
  final out = <String>[];
  for (final a in ac.skip(1)) {
    if (a is int) {
      out.add('$a');
    } else if (a is Map) {
      final n = _int(a['ac']);
      if (n == null) continue;
      final cond = a['condition'] == null ? null : _clean('${a['condition']}');
      final from = _joinClean(a['from']);
      out.add([
        '$n',
        if (cond != null) (a['braces'] == true ? '($cond)' : cond),
        if (from != null) '($from)',
      ].join(' '));
    }
  }
  return out.isEmpty ? null : out.join('; ');
}

/// resist / immune / vulnerable / conditionImmune -> one display string.
String? _damage(dynamic v) {
  if (v is! List || v.isEmpty) return null;
  final parts = <String>[];
  var hasObject = false;
  for (final e in v) {
    if (e is String) {
      parts.add(_clean(e));
    } else if (e is Map) {
      hasObject = true;
      if (e['special'] != null) {
        parts.add(_clean('${e['special']}'));
      } else {
        final inner = _damage(
          e['resist'] ?? e['immune'] ?? e['vulnerable'] ?? e['conditionImmune'],
        );
        final text = [
          if (e['preNote'] != null) _clean('${e['preNote']}'),
          if (inner != null) inner,
          if (e['note'] != null) _clean('${e['note']}'),
        ].join(' ');
        if (text.isNotEmpty) parts.add(text);
      }
    }
  }
  return parts.isEmpty ? null : parts.join(hasObject ? '; ' : ', ');
}

/// 'sleight of hand' -> 'sleightOfHand'; already-camel keys pass through.
String _camel(String s) {
  final words = s.trim().split(RegExp(r'\s+'));
  if (words.length == 1) return s;
  return words.first.toLowerCase() +
      words
          .skip(1)
          .map(
            (w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1).toLowerCase(),
          )
          .join();
}
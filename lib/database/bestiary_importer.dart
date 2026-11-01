// Imports bestiary JSON into the normalized creature and legendary-group tables.
//
// Both bundled assets and user-selected JSON use the same insertion pipeline;
// existing name/source pairs and copy-template entries are skipped, except
// MM entries that enrich an existing SRD creature.
import 'dart:convert';

import 'package:drift/drift.dart' show InsertMode, Value;
import 'package:flutter/services.dart' show rootBundle;

import 'package:gmdex/database/database.dart';
import 'package:gmdex/database/read.dart'
    show alignmentNames, parseEntries, sizeNames;

class ImportResult {
  /// Counts successful inserts, skipped duplicates/templates, and failures.
  int imported = 0;
  int skipped = 0; // duplicates and `_copy` entries
  final List<String> failed = [];

  @override
  String toString() =>
      'imported $imported, skipped $skipped, failed ${failed.length}';
}

class LegendaryGroupImportResult {
  const LegendaryGroupImportResult({
    required this.imported,
    required this.skipped,
  });

  final int imported;
  final int skipped;
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

const maxBestiaryImportSizeBytes = 16 * 1024 * 1024;

/// Safe to run more than once: creatures and groups already in the
/// database (matched on name + source) are skipped. MM creatures replace a
/// matching SRD creature and combine their source labels.
/// Imports the configured bundled bestiary and optional legendary-group asset.
Future<ImportResult> importBestiary(
  AppDatabase db, {
  List<String> bestiaryAssets = const ['assets/bestiary-srd-filtered.json'],
  String? legendaryGroupsAsset,
}) async {
  final result = ImportResult();

  await db.transaction(() async {
    final groupIds = legendaryGroupsAsset == null
        ? await _existingLegendaryGroupIds(db)
        : await _importLegendaryGroups(db, legendaryGroupsAsset);
    final existing = await _existingCreatures(db);

    for (final asset in bestiaryAssets) {
      final json = jsonDecode(await rootBundle.loadString(asset));
      await _importMonsters(
        db,
        json['monster'] as List,
        groupIds,
        existing,
        result,
      );
    }
    await _linkCreaturesToLegendaryGroups(db, groupIds);
  });

  return result;
}

/// Imports a validated JSON document supplied by the user or another caller.
///
/// The decoded document must contain a `monster` list. Size is checked before
/// decoding to cap memory usage for imported content.
Future<ImportResult> importBestiaryJson(
  AppDatabase db,
  String jsonContent,
) async {
  _validateBestiaryJsonSize(jsonContent);
  final decoded = jsonDecode(jsonContent);
  if (decoded is! Map<String, dynamic> || decoded['monster'] is! List) {
    throw const FormatException(
      'Expected a bestiary JSON object containing a "monster" array.',
    );
  }

  final result = ImportResult();
  await db.transaction(() async {
    final groups = decoded['legendaryGroup'];
    final groupIds = groups is List
        ? await _importLegendaryGroupsFromList(db, groups)
        : await _existingLegendaryGroupIds(db);
    await _importMonsters(
      db,
      decoded['monster'] as List,
      groupIds,
      await _existingCreatures(db),
      result,
    );
    await _linkCreaturesToLegendaryGroups(db, groupIds);
  });
  return result;
}

/// Imports a standalone legendary-groups JSON document.
///
/// The document must contain a `legendaryGroup` array. Existing groups are
/// preserved and skipped, matching bestiary-import behavior.
Future<LegendaryGroupImportResult> importLegendaryGroupsJson(
  AppDatabase db,
  String jsonContent,
) async {
  _validateBestiaryJsonSize(jsonContent);
  final decoded = jsonDecode(jsonContent);
  if (decoded is! Map<String, dynamic> || decoded['legendaryGroup'] is! List) {
    throw const FormatException(
      'Expected a legendary groups JSON object containing a '
      '"legendaryGroup" array.',
    );
  }

  final groups = decoded['legendaryGroup'] as List;
  if (groups.any((group) => group is! Map<String, dynamic>)) {
    throw const FormatException('Every legendary group must be a JSON object.');
  }

  return db.transaction(() async {
    final before = await db.select(db.legendaryGroups).get();
    await _importLegendaryGroupsFromList(db, groups);
    final after = await db.select(db.legendaryGroups).get();
    final imported = after.length - before.length;
    return LegendaryGroupImportResult(
      imported: imported,
      skipped: groups.length - imported,
    );
  });
}

/// Rejects JSON input that exceeds the importer size limit in UTF-8 bytes.
void _validateBestiaryJsonSize(String jsonContent) {
  var byteLength = 0;
  for (final rune in jsonContent.runes) {
    byteLength += switch (rune) {
      <= 0x7f => 1,
      <= 0x7ff => 2,
      <= 0xffff => 3,
      _ => 4,
    };
    if (byteLength > maxBestiaryImportSizeBytes) {
      throw const FormatException(
        'Bestiary JSON files must be 16 MiB or smaller.',
      );
    }
  }
}

class _ExistingCreature {
  _ExistingCreature({
    required this.id,
    required this.name,
    required this.source,
  });

  final int id;
  final String name;
  String source;
}

Future<List<_ExistingCreature>> _existingCreatures(AppDatabase db) async => [
  for (final creature in await db.select(db.creatures).get())
    _ExistingCreature(
      id: creature.id,
      name: creature.name,
      source: creature.source,
    ),
];

Future<void> _importMonsters(
  AppDatabase db,
  List monsters,
  Map<String, int> groupIds,
  List<_ExistingCreature> existing,
  ImportResult result,
) async {
  for (final raw in monsters) {
    if (raw is! Map<String, dynamic>) {
      result.failed.add('Invalid monster entry: expected a JSON object.');
      continue;
    }

    final name = raw['name'];
    final source = (raw['source'] as String?) ?? '';
    if (name is! String ||
        name.trim().isEmpty ||
        !_hasRequiredCreatureFields(raw) ||
        raw.containsKey('_copy')) {
      result.skipped++;
      continue;
    }

    final namedCreatures = existing.where((creature) => creature.name == name);
    _ExistingCreature? match;
    _ExistingCreature? srdCreatureToUpdate;
    for (final creature in namedCreatures) {
      if (_sameSource(creature.source, source) ||
          (_isMmSource(source) && _hasSource(creature.source, 'mm'))) {
        match = creature;
        break;
      }
      if (_isMmSource(source) && _sameSource(creature.source, 'srd')) {
        srdCreatureToUpdate ??= creature;
      }
    }

    if (match != null) {
      result.skipped++;
      continue;
    }

    try {
      final creatureToUpdate = srdCreatureToUpdate;
      final updatedSource = creatureToUpdate == null ? source : 'srd, mm';
      final id = await db.transaction(
        () => _insertCreature(
          db,
          raw,
          name,
          updatedSource,
          groupIds,
          existingId: creatureToUpdate?.id,
        ),
      );
      if (creatureToUpdate == null) {
        existing.add(
          _ExistingCreature(id: id, name: name, source: updatedSource),
        );
      } else {
        creatureToUpdate.source = updatedSource;
      }
      result.imported++;
    } catch (error) {
      result.failed.add('$name ($source): $error');
    }
  }
}

bool _hasRequiredCreatureFields(Map<String, dynamic> raw) {
  final armorClass = raw['ac'];
  final firstArmorClass = armorClass is List && armorClass.isNotEmpty
      ? armorClass.first
      : null;
  final armorClassValue = firstArmorClass is Map
      ? _int(firstArmorClass['ac'])
      : _int(firstArmorClass);
  final hitPoints = raw['hp'];
  final hitPointsValue = hitPoints is Map ? _int(hitPoints['average']) : null;

  return armorClassValue != null && hitPointsValue != null;
}

bool _sameSource(String first, String second) =>
    first.trim().toLowerCase() == second.trim().toLowerCase();

bool _isMmSource(String source) => _sameSource(source, 'mm');

bool _hasSource(String sourceList, String source) =>
    sourceList.split(',').any((part) => _sameSource(part, source));

// ---------------------------------------------------------------------------
// Legendary groups
// ---------------------------------------------------------------------------

Future<Map<String, int>> _importLegendaryGroups(
  AppDatabase db,
  String asset,
) async {
  final json = jsonDecode(await rootBundle.loadString(asset));
  return _importLegendaryGroupsFromList(db, json['legendaryGroup'] as List);
}

Future<Map<String, int>> _importLegendaryGroupsFromList(
  AppDatabase db,
  List groups,
) async {
  final ids = await _existingLegendaryGroupIds(db);

  for (final raw in groups) {
    final g = raw as Map<String, dynamic>;
    final name = g['name'] as String?;
    final source = g['source'] as String?;
    if (name == null || source == null || g.containsKey('_copy')) continue;

    final key = _legendaryGroupKey(name, source);
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

  await _linkCreaturesToLegendaryGroups(db, ids);
  return ids;
}

Future<Map<String, int>> _existingLegendaryGroupIds(AppDatabase db) async => {
  for (final group in await db.select(db.legendaryGroups).get())
    _legendaryGroupKey(group.name, group.source): group.id,
};

String _legendaryGroupKey(String name, String source) =>
    '${name.trim().toLowerCase()}\u0000${source.trim().toLowerCase()}';

Future<void> _linkCreaturesToLegendaryGroups(
  AppDatabase db,
  Map<String, int> groupIds,
) async {
  final groups = await db.select(db.legendaryGroups).get();
  final creatures = await db.select(db.creatures).get();

  for (final creature in creatures) {
    final referencedName = creature.legendaryGroupName;
    final referencedSource = creature.legendaryGroupSource;
    final referencedGroupId = referencedName == null || referencedSource == null
        ? null
        : groupIds[_legendaryGroupKey(referencedName, referencedSource)];

    final sameNameGroups = groups
        .where((group) => group.name == creature.name)
        .toList();
    final sourceMatchedGroup = sameNameGroups
        .where(
          (group) =>
              _sameSource(group.source, creature.source) ||
              _hasSource(creature.source, group.source),
        )
        .firstOrNull;
    final legacyMatch =
        referencedGroupId == null &&
            creature.legendaryGroupId == null &&
            referencedName == null &&
            referencedSource == null
        ? sourceMatchedGroup ??
              (sameNameGroups.length == 1 ? sameNameGroups.single : null)
        : null;
    final groupId = referencedGroupId ?? legacyMatch?.id;
    if (groupId == null || creature.legendaryGroupId == groupId) continue;

    await (db.update(
      db.creatures,
    )..where((row) => row.id.equals(creature.id))).write(
      CreaturesCompanion(
        legendaryGroupId: Value(groupId),
        legendaryGroupName: Value(referencedName ?? legacyMatch?.name),
        legendaryGroupSource: Value(referencedSource ?? legacyMatch?.source),
      ),
    );
  }
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

Future<int> _insertCreature(
  AppDatabase db,
  Map<String, dynamic> d,
  String name,
  String source,
  Map<String, int> groupIds, {
  int? existingId,
}) async {
  final ac = (d['ac'] as List?) ?? const [];
  final firstAc = ac.isEmpty ? null : ac.first;
  final hp = d['hp'];
  final speed = d['speed'];
  final cr = d['cr'];
  final group = d['legendaryGroup'];
  final groupName = _nonEmptyString(group is Map ? group['name'] : null);
  final groupSource = _nonEmptyString(group is Map ? group['source'] : null);
  final hasGroupReference = groupName != null && groupSource != null;

  final creature = CreaturesCompanion(
    name: Value(name),
    source: Value(source),
    page: Value(_int(d['page'])),
    isSrd: Value(d['srd'] == true),
    size: Value(_size(d['size'])),
    type: Value(_typeName(d['type'])),
    typeTags: Value(_typeTags(d['type'])),
    alignment: Value(_alignment(d['alignment'])),
    armorClass: Value(firstAc is Map ? _int(firstAc['ac']) : _int(firstAc)),
    armorClassType: Value(
      firstAc is Map ? _armorClassType(firstAc['from']) : null,
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
    challengeRating: Value(cr is Map ? cr['cr']?.toString() : cr?.toString()),
    challengeRatingLair: Value(cr is Map ? cr['lair']?.toString() : null),
    challengeRatingCoven: Value(cr is Map ? cr['coven']?.toString() : null),
    xpOverride: Value(cr is Map ? _int(cr['xp']) : null),
    damageVulnerabilities: Value(_damage(d['vulnerable'])),
    damageResistances: Value(_damage(d['resist'])),
    damageImmunities: Value(_damage(d['immune'])),
    conditionImmunities: Value(_damage(d['conditionImmune'])),
    legendaryGroupId: Value(
      hasGroupReference
          ? groupIds[_legendaryGroupKey(groupName, groupSource)]
          : null,
    ),
    legendaryGroupName: Value(hasGroupReference ? groupName : null),
    legendaryGroupSource: Value(hasGroupReference ? groupSource : null),
  );

  final int id;
  if (existingId == null) {
    id = await db.into(db.creatures).insert(creature);
  } else {
    id = existingId;
    await (db.update(
      db.creatures,
    )..where((row) => row.id.equals(id))).write(creature);
    await _deleteImportedCreatureChildren(db, id);
  }

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
  return id;
}

Future<void> _deleteImportedCreatureChildren(AppDatabase db, int id) async {
  await (db.delete(
    db.creatureSaves,
  )..where((row) => row.creatureId.equals(id))).go();
  await (db.delete(
    db.creatureSkills,
  )..where((row) => row.creatureId.equals(id))).go();
  await (db.delete(
    db.creatureSenses,
  )..where((row) => row.creatureId.equals(id))).go();
  await (db.delete(
    db.creatureLanguages,
  )..where((row) => row.creatureId.equals(id))).go();
  await (db.delete(
    db.creatureEnvironments,
  )..where((row) => row.creatureId.equals(id))).go();
  await (db.delete(
    db.creatureTraits,
  )..where((row) => row.creatureId.equals(id))).go();
  await (db.delete(
    db.creatureActions,
  )..where((row) => row.creatureId.equals(id))).go();
  await (db.delete(
    db.creatureSpellcastings,
  )..where((row) => row.creatureId.equals(id))).go();
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

String? _nonEmptyString(dynamic value) {
  if (value is! String || value.trim().isEmpty) return null;
  return value.trim();
}

int? _int(dynamic v) => v is int
    ? v
    : (v is num ? v.toInt() : (v is String ? int.tryParse(v) : null));

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
      if (x is String) x else if (x is Map && x['tag'] != null) '${x['tag']}',
  ];
  return tags.isEmpty ? null : tags.join(', ');
}

String? _joinClean(dynamic v) {
  if (v is! List) return null;
  final s = v.whereType<String>().map(_clean).where((x) => x.isNotEmpty);
  return s.isEmpty ? null : s.join(', ');
}

/// Formats AC source tags without their source suffixes, e.g. `(leather armor)`.
String? _armorClassType(dynamic from) {
  if (from is! List) return null;
  final sources = from
      .whereType<String>()
      .map(_clean)
      .map((source) => source.split('|').first.trim())
      .where((source) => source.isNotEmpty)
      .toList();
  return sources.isEmpty ? null : '(${sources.join(', ')})';
}

List<String> _strings(dynamic v) => v is List
    ? [
        for (final e in v)
          if (e is String) _clean(e),
      ]
    : <String>[];

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
      out.add(
        [
          '$n',
          if (cond != null) (a['braces'] == true ? '($cond)' : cond),
          if (from != null) '($from)',
        ].join(' '),
      );
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
          ?inner,
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
            (w) => w.isEmpty
                ? w
                : w[0].toUpperCase() + w.substring(1).toLowerCase(),
          )
          .join();
}

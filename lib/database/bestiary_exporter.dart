import 'dart:convert';

import 'package:drift/drift.dart' show CustomExpression, OrderingTerm;
import 'package:gmdex/database/database.dart';

const _skillKeys = [
  'acrobatics',
  'animalHandling',
  'arcana',
  'athletics',
  'deception',
  'history',
  'insight',
  'intimidation',
  'investigation',
  'medicine',
  'nature',
  'perception',
  'performance',
  'persuasion',
  'religion',
  'sleightOfHand',
  'stealth',
  'survival',
];
const _actionKinds = [
  'action',
  'bonus',
  'reaction',
  'legendary',
  'special',
  'villain',
];

/// Encodes all creature records as a bestiary JSON document.
Future<String> exportBestiaryJson(AppDatabase db) async {
  final creatures = await (db.select(
    db.creatures,
  )..orderBy([(c) => OrderingTerm.asc(c.id)])).get();
  final monsters = <Map<String, dynamic>>[];

  for (final creature in creatures) {
    final id = creature.id;
    final speed = _speed(creature);
    final saves = await _saves(db, id);
    final skills = await _skills(db, id);
    final senses = await _senses(db, id);
    final languages = await _languages(db, id);
    final challengeRating = _challengeRating(creature);
    final traits = await _traits(db, id);
    final actions = await _actions(db, id);
    final spellcasting = await _spellcasting(db, id);
    final environments = await _environments(db, id);
    final monster = <String, dynamic>{
      'name': creature.name,
      'source': creature.source,
      if (creature.page != null) 'page': creature.page,
      if (creature.isSrd) 'srd': true,
      if (creature.size != null) 'size': [_sizeCode(creature.size!)],
      if (creature.type != null) 'type': _type(creature),
      if (creature.alignment != null)
        'alignment': _alignmentCodes(creature.alignment!),
      if (creature.armorClass != null) 'ac': _armorClass(creature),
      if (creature.hitPoints != null)
        'hp': {
          'average': creature.hitPoints,
          if (creature.hitPointFormula != null)
            'formula': creature.hitPointFormula,
        },
      if (speed.isNotEmpty) 'speed': speed,
      'str': creature.strength,
      'dex': creature.dexterity,
      'con': creature.constitution,
      'int': creature.intelligence,
      'wis': creature.wisdom,
      'cha': creature.charisma,
      if (saves != null && saves.isNotEmpty) 'save': saves,
      if (skills != null && skills.isNotEmpty) 'skill': skills,
      if (creature.passivePerception != null)
        'passive': creature.passivePerception,
      if (senses != null && senses.isNotEmpty) 'senses': senses,
      if (languages != null && languages.isNotEmpty) 'languages': languages,
      if (challengeRating != null) 'cr': challengeRating,
      if (creature.damageVulnerabilities != null)
        'vulnerable': _split(creature.damageVulnerabilities!),
      if (creature.damageResistances != null)
        'resist': _split(creature.damageResistances!),
      if (creature.damageImmunities != null)
        'immune': _split(creature.damageImmunities!),
      if (creature.conditionImmunities != null)
        'conditionImmune': _split(creature.conditionImmunities!),
      if (traits != null && traits.isNotEmpty) 'trait': traits,
      ...actions,
      if (spellcasting != null && spellcasting.isNotEmpty)
        'spellcasting': spellcasting,
      if (environments != null && environments.isNotEmpty)
        'environment': environments,
    };
    monsters.add(monster);
  }

  return const JsonEncoder.withIndent('  ').convert({'monster': monsters});
}

String _sizeCode(String size) => switch (size) {
  'Tiny' => 'T',
  'Small' => 'S',
  'Medium' => 'M',
  'Large' => 'L',
  'Huge' => 'H',
  'Gargantuan' => 'G',
  _ => size,
};

List<String> _alignmentCodes(String alignment) => [
  for (final part in alignment.split(RegExp(r'\s+')))
    switch (part) {
      'Lawful' => 'L',
      'Neutral' => 'N',
      'Chaotic' => 'C',
      'Good' => 'G',
      'Evil' => 'E',
      'Unaligned' => 'U',
      'Any' => 'A',
      _ => part,
    },
];

Map<String, dynamic> _type(CreatureRow creature) => {
  'type': creature.type,
  if (creature.typeTags != null) 'tags': _split(creature.typeTags!),
};

List<Map<String, dynamic>> _armorClass(CreatureRow creature) {
  final first = _armorClassValue(creature.armorClass!, creature.armorClassType);
  final other = creature.armorClassOther;
  if (other == null || other.isEmpty) return [first];
  final entries = [first];
  for (final part in other.split(';')) {
    final ac = _parseOtherArmorClass(part);
    if (ac != null) entries.add(ac);
  }
  return entries;
}

Map<String, dynamic> _armorClassValue(int ac, String? description) {
  final from = description
      ?.replaceAll(RegExp(r'^\(|\)$'), '')
      .split(',')
      .map((part) => part.trim())
      .where((part) => part.isNotEmpty)
      .toList();
  return {'ac': ac, if (from != null && from.isNotEmpty) 'from': from};
}

Map<String, dynamic>? _parseOtherArmorClass(String value) {
  final match = RegExp(
    r'^\s*(\d+)(?:\s*\((.*?)\)|\s+(.*))?\s*$',
  ).firstMatch(value);
  if (match == null) return null;
  final condition = match.group(2) ?? match.group(3);
  return {
    'ac': int.parse(match.group(1)!),
    if (condition != null && condition.isNotEmpty) 'condition': condition,
  };
}

Map<String, dynamic> _speed(CreatureRow creature) => {
  if (creature.speedWalk != null) 'walk': creature.speedWalk,
  if (creature.speedFly != null) 'fly': creature.speedFly,
  if (creature.speedSwim != null) 'swim': creature.speedSwim,
  if (creature.speedClimb != null) 'climb': creature.speedClimb,
  if (creature.speedBurrow != null) 'burrow': creature.speedBurrow,
};

Object? _challengeRating(CreatureRow creature) {
  final cr = creature.challengeRating;
  final values = <String, dynamic>{
    if (cr != null) 'cr': cr,
    if (creature.challengeRatingLair != null)
      'lair': creature.challengeRatingLair,
    if (creature.challengeRatingCoven != null)
      'coven': creature.challengeRatingCoven,
    if (creature.xpOverride != null) 'xp': creature.xpOverride,
  };
  if (values.isEmpty) return null;
  if (values.length == 1 && values.containsKey('cr')) return values['cr'];
  return values;
}

Future<Map<String, String>?> _saves(AppDatabase db, int creatureId) async {
  final rows = await (db.select(
    db.creatureSaves,
  )..where((row) => row.creatureId.equals(creatureId))).get();
  if (rows.isEmpty) return null;
  return {for (final row in rows) row.ability: _signed(row.bonus)};
}

Future<Map<String, String>?> _skills(AppDatabase db, int creatureId) async {
  final rows = await (db.select(
    db.creatureSkills,
  )..where((row) => row.creatureId.equals(creatureId))).get();
  if (rows.isEmpty) return null;
  return {
    for (final key in _skillKeys)
      for (final row in rows.where((row) => row.skill == key))
        row.skill: _signed(row.bonus),
  };
}

Future<List<String>?> _senses(AppDatabase db, int creatureId) async {
  final rows =
      await (db.select(db.creatureSenses)
            ..where((row) => row.creatureId.equals(creatureId))
            ..orderBy([
              (_) => OrderingTerm.asc(CustomExpression<int>('rowid')),
            ]))
          .get();
  return rows.isEmpty ? null : rows.map((row) => row.sense).toList();
}

Future<List<String>?> _languages(AppDatabase db, int creatureId) async {
  final rows =
      await (db.select(db.creatureLanguages)
            ..where((row) => row.creatureId.equals(creatureId))
            ..orderBy([
              (_) => OrderingTerm.asc(CustomExpression<int>('rowid')),
            ]))
          .get();
  return rows.isEmpty ? null : rows.map((row) => row.language).toList();
}

Future<List<String>?> _environments(AppDatabase db, int creatureId) async {
  final rows =
      await (db.select(db.creatureEnvironments)
            ..where((row) => row.creatureId.equals(creatureId))
            ..orderBy([
              (_) => OrderingTerm.asc(CustomExpression<int>('rowid')),
            ]))
          .get();
  return rows.isEmpty ? null : rows.map((row) => row.environment).toList();
}

Future<List<Map<String, dynamic>>?> _traits(
  AppDatabase db,
  int creatureId,
) async {
  final rows =
      await (db.select(db.creatureTraits)
            ..where((row) => row.creatureId.equals(creatureId))
            ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]))
          .get();
  if (rows.isEmpty) return null;
  return [
    for (final row in rows)
      {
        'name': row.name,
        'entries': [row.description],
      },
  ];
}

Future<Map<String, List<Map<String, dynamic>>>> _actions(
  AppDatabase db,
  int creatureId,
) async {
  final result = <String, List<Map<String, dynamic>>>{};
  final rows =
      await (db.select(db.creatureActions)
            ..where((row) => row.creatureId.equals(creatureId))
            ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]))
          .get();
  for (final kind in _actionKinds) {
    final kindRows = rows.where((row) => row.kind == kind);
    if (kindRows.isEmpty) continue;
    result[kind] = [
      for (final row in kindRows)
        {
          'name': row.name,
          'entries': [row.description],
        },
    ];
  }
  return result;
}

Future<List<Map<String, dynamic>>?> _spellcasting(
  AppDatabase db,
  int creatureId,
) async {
  final blocks =
      await (db.select(db.creatureSpellcastings)
            ..where((row) => row.creatureId.equals(creatureId))
            ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]))
          .get();
  if (blocks.isEmpty) return null;

  final result = <Map<String, dynamic>>[];
  for (final block in blocks) {
    final spellRows =
        await (db.select(db.creatureSpells)
              ..where((row) => row.spellcastingId.equals(block.id))
              ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]))
            .get();
    final spells = <String, dynamic>{
      'will': <String>[],
      'daily': <String, List<String>>{},
      'spells': <String, Map<String, dynamic>>{},
    };
    for (final spell in spellRows) {
      if (spell.spellLevel case final level?) {
        final levelSpells =
            spells['spells'] as Map<String, Map<String, dynamic>>;
        final levelKey = '$level';
        final levelData = levelSpells.putIfAbsent(
          levelKey,
          () => {
            if (spell.slots != null) 'slots': spell.slots,
            'spells': <String>[],
          },
        );
        (levelData['spells'] as List<String>).add(spell.spellName);
      } else if (spell.uses == 'will') {
        (spells['will'] as List<String>).add(spell.spellName);
      } else if (spell.uses != null) {
        final daily = spells['daily'] as Map<String, List<String>>;
        (daily[spell.uses!] ??= []).add(spell.spellName);
      }
    }

    final blockJson = <String, dynamic>{
      'name': block.name,
      if (block.headerText != null) 'headerEntries': [block.headerText],
      if (block.footerText != null) 'footerEntries': [block.footerText],
      if (block.ability != null) 'ability': block.ability,
      if (block.hiddenUses != null)
        'hidden': block.hiddenUses!
            .split(',')
            .map((use) => use.trim())
            .where((use) => use.isNotEmpty)
            .toList(),
    };
    if ((spells['will'] as List).isNotEmpty) {
      blockJson['will'] = spells['will'];
    }
    if ((spells['daily'] as Map).isNotEmpty) {
      blockJson['daily'] = spells['daily'];
    }
    if ((spells['spells'] as Map).isNotEmpty) {
      blockJson['spells'] = spells['spells'];
    }
    result.add(blockJson);
  }
  return result;
}

List<String> _split(String value) => value
    .split(RegExp(r'\s*[,;]\s*'))
    .map((part) => part.trim())
    .where((part) => part.isNotEmpty)
    .toList();

String _signed(int value) => value >= 0 ? '+$value' : '$value';

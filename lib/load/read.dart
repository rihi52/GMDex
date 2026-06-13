import 'dart:convert';
import 'package:flutter/services.dart';
// import 'package:flutter/material.dart';
import '../components/statblock.dart';

Future<dynamic> loadMonsters() async {
  final jsonString = await rootBundle.loadString(
    'assets/bestiary-srd-filtered.json',
  );
  return jsonDecode(jsonString);
}

Future<Map<String, dynamic>> loadLegendaryGroups() async {
  final jsonString = await rootBundle.loadString('assets/legendarygroups.json');
  final data = jsonDecode(jsonString);
  return {
    for (final group in data['legendaryGroup'] as List)
      '${group['name']}_${group['source']}': group,
  };
}

const sizeNames = {
  'T': 'Tiny',
  'S': 'Small',
  'M': 'Medium',
  'L': 'Large',
  'H': 'Huge',
  'G': 'Gargantuan',
};

const alignmentNames = {
  'L': 'Lawful',
  'N': 'Neutral',
  'C': 'Chaotic',
  'G': 'Good',
  'E': 'Evil',
  'U': 'Unaligned',
  'A': 'Any',
};

Creature parseCreature(
  Map<String, dynamic> data,
  Map<String, dynamic> legendaryGroups,
) {
  final skills = data['skill'] ?? {};
  final save = data['save'] ?? {};
  final spells = data['spellcasting'] ?? {};
  final lgRef = data['legendaryGroup'];
  final group = lgRef != null
      ? legendaryGroups['${lgRef['name']}_${lgRef['source']}']
      : null;

  return Creature(
    name: data['name'],
    size: sizeNames[data['size'][0]] ?? data['size'][0],
    type: data['type'] is String
        ? data['type']
        : (data['type']?['type'] ?? 'Unknown'),
    alignment:
        (data['alignment'] as List?)
            ?.map((a) => alignmentNames[a] ?? a)
            .join(' ') ??
        'Unaligned',
    armorClass: CreatureArmorClass(
      ac: data['ac'][0] is int ? data['ac'][0] : data['ac'][0]['ac'] ?? 0,
      type: data['ac'][0] is int
          ? 'Natural'
          : (data['ac'][0]['from'] as List?)?.first ?? 'Unknown',
    ),
    hitPoints: data['hp']['average'],
    hitPointFormula: data['hp']['formula'] ?? '',
    challengeRating: data['cr'] is Map
        ? CreatureCR(
            cr: data['cr']['cr'],
            lair: data['cr']['lair'],
            coven: data['cr']['coven'],
            xpOverride: data['cr']['xp'],
          )
        : CreatureCR(cr: data['cr']?.toString() ?? '0'),
    speed: CreatureSpeed(
      //walk: data['speed']['walk'] ?? 0,
      walk: data['speed']['walk'] == null
          ? 0
          : data['speed']['walk'] is int
          ? data['speed']['walk']
          : data['speed']['walk']['number'] ?? 0,
      burrow: data['speed']['burrow'] ?? 0,
      fly: data['speed']['fly'] == null
          ? 0
          : data['speed']['fly'] is int
          ? data['speed']['fly']
          : data['speed']['fly']['number'] ?? 0,
      climb: data['speed']['climb'] ?? 0,
      swim: data['speed']['swim'] ?? 0,
    ),
    abilityScores: CreatureAbilityScores(
      strength: data['str'],
      strengthModifier: ((data['str'] - 10) / 2).floor(),
      dexterity: data['dex'],
      dexterityModifier: ((data['dex'] - 10) / 2).floor(),
      constitution: data['con'],
      constitutionModifier: ((data['con'] - 10) / 2).floor(),
      intelligence: data['int'],
      intelligenceModifier: ((data['int'] - 10) / 2).floor(),
      wisdom: data['wis'],
      wisdomModifier: ((data['wis'] - 10) / 2).floor(),
      charisma: data['cha'],
      charismaModifier: ((data['cha'] - 10) / 2).floor(),
    ),
    skills: CreatureSkills(
      athletics: skills['athletics']?.toString(),
      acrobatics: skills['acrobatics']?.toString(),
      sleightOfHand: skills['sleightOfHand']?.toString(),
      stealth: skills['stealth']?.toString(),
      arcana: skills['arcana']?.toString(),
      history: skills['history']?.toString(),
      investigation: skills['investigation']?.toString(),
      nature: skills['nature']?.toString(),
      religion: skills['religion']?.toString(),
      animalHandling: skills['animalHandling']?.toString(),
      insight: skills['insight']?.toString(),
      medicine: skills['medicine']?.toString(),
      perception: skills['perception']?.toString(),
      survival: skills['survival']?.toString(),
      deception: skills['deception']?.toString(),
      intimidation: skills['intimidation']?.toString(),
      performance: skills['performance']?.toString(),
    ),
    senses: (data['senses'] as List?)?.join(', ') ?? '',
    languages: (data['languages'] as List?)?.join(', ') ?? '',
    savingThrows: CreatureSavingThrows(
      strength: int.tryParse(save['str']?.toString() ?? ''),
      dexterity: int.tryParse(save['dex']?.toString() ?? ''),
      constitution: int.tryParse(save['con']?.toString() ?? ''),
      intelligence: int.tryParse(save['int']?.toString() ?? ''),
      wisdom: int.tryParse(save['wis']?.toString() ?? ''),
      charisma: int.tryParse(save['cha']?.toString() ?? ''),
    ),
    spellCasting: spells == null || spells.isEmpty
        ? null
        : CreatureSpellcasting(
            name: spells[0]['name'],
            headerEntries: parseEntries(spells[0]['headerEntries'] as List),
            ability: spells[0]['ability'],
            spells: spells[0]['spells'] == null
                ? null
                : (spells[0]['spells'] as Map<String, dynamic>).map(
                    (key, value) => MapEntry(
                      int.parse(key),
                      SpellLevel(
                        slots: value['slots'] ?? 0,
                        spells: (value['spells'] as List)
                            .map((s) => parseEntries([s]))
                            .toList(),
                      ),
                    ),
                  ),
            innateSpell: spells[0]['name'] != 'Innate Spellcasting'
                ? null
                : {
                    if (spells[0]['will'] != null)
                      'will': (spells[0]['will'] as List)
                          .map((s) => parseEntries([s]))
                          .toList(),
                    if (spells[0]['daily'] != null)
                      ...(spells[0]['daily'] as Map<String, dynamic>).map(
                        (key, value) => MapEntry(
                          key,
                          (value as List)
                              .map((s) => parseEntries([s]))
                              .toList(),
                        ),
                      ),
                  },
          ),
    actions: [
      for (final (key, type) in [
        ('action', ActionType.action),
        ('legendary', ActionType.legendary),
        ('bonus', ActionType.bonusAction),
        ('reaction', ActionType.reaction),
        ('special', ActionType.special),
        ('villain', ActionType.villainAction),
      ])
        if (data[key] != null)
          ...List<CreatureAction>.from(
            (data[key] as List).map(
              (action) => CreatureAction(
                name: parseEntries([action['name']]),
                description: parseEntries(action['entries'] as List),
                type: type,
              ),
            ),
          ),
      if (group?['lairActions'] != null)
        CreatureAction(
          name: '',
          description: parseEntries(
            (group!['lairActions'] as List).where((e) => e is! String).toList(),
          ),
          type: ActionType.lair,
        ),
    ],
    traits: List<CreatureTrait>.from(
      (data['trait'] as List? ?? []).map(
        (trait) => CreatureTrait(
          name: trait['name'],
          description: parseEntries(trait['entries'] as List),
        ),
      ),
    ),
    regionalEffect: group?['regionalEffects'] == null
        ? null
        : _parseRegionalEffect(group!['regionalEffects'] as List),
    id: 1,
  );
}

CreatureRegionalEffect _parseRegionalEffect(List entries) {
  return CreatureRegionalEffect(
    blurb: parseEntries([entries.whereType<String>().first]),
    bulletPoints:
        (entries.firstWhere(
                  (e) => e is Map && e['type'] == 'list',
                  orElse: () => {'items': []},
                )['items']
                as List)
            .map(
              (item) => item is String
                  ? parseEntries([item])
                  : parseEntries([item.toString()]),
            )
            .toList(),
    blurbEnd: entries.whereType<String>().length > 1
        ? parseEntries([entries.whereType<String>().last])
        : null,
  );
}

String parseEntries(List entries) {
  final parts = <String>[];
  for (final entry in entries) {
    if (entry is String) {
      parts.add(entry);
    } else if (entry is Map && entry['type'] == 'list') {
      for (final item in entry['items'] as List) {
        if (item is String) {
          parts.add('• $item\n');
        } else if (item is Map && item['type'] == 'item') {
          parts.add('• ${item['name']} ${item['entry']}\n');
        }
      }
    }
  }
  String text = parts.join('\n');

  // Attack types
  text = text.replaceAll('{@atk mw}', 'Melee Weapon Attack:');
  text = text.replaceAll('{@atk rw}', 'Ranged Weapon Attack:');
  text = text.replaceAll('{@atk mw,rw}', 'Melee or Ranged Weapon Attack:');
  text = text.replaceAll('{@atk ms}', 'Melee Spell Attack:');
  text = text.replaceAll('{@atk rs}', 'Ranged Spell Attack:');

  // DC
  text = text.replaceAllMapped(
    RegExp(r'\{@dc (\d+)\}'),
    (match) => 'DC ${match.group(1)}',
  );

  // Hit bonus
  text = text.replaceAllMapped(
    RegExp(r'\{@hit (\d+)\}'),
    (match) => '+${match.group(1)}',
  );

  // Hit result
  text = text.replaceAllMapped(
    RegExp(r'\{@h\}(\d+)'),
    (match) => 'Hit: ${match.group(1)}',
  );

  // Dice and damage
  text = text.replaceAllMapped(
    RegExp(r'\{@dice ([^}]+)\}'),
    (match) => match.group(1)!,
  );
  text = text.replaceAllMapped(
    RegExp(r'\{@damage ([^}]+)\}'),
    (match) => match.group(1)!,
  );

  // Conditions, skills, spells, creatures, items, actions
  text = text.replaceAllMapped(
    RegExp(r'\{@condition ([^}]+)\}'),
    (match) => match.group(1)!,
  );
  text = text.replaceAllMapped(
    RegExp(r'\{@skill ([^}]+)\}'),
    (match) => match.group(1)!,
  );
  text = text.replaceAllMapped(
    RegExp(r'\{@spell ([^}]+)\}'),
    (match) => match.group(1)!,
  );
  text = text.replaceAllMapped(
    RegExp(r'\{@creature ([^}]+)\}'),
    (match) => match.group(1)!,
  );
  text = text.replaceAllMapped(
    RegExp(r'\{@item ([^}]+)\}'),
    (match) => match.group(1)!,
  );
  text = text.replaceAllMapped(
    RegExp(r'\{@action ([^}]+)\}'),
    (match) => match.group(1)!,
  );

  text = text.replaceAllMapped(
    RegExp(r'\{@quickref ([^|]+)\|\|[^}]*\}'),
    (match) => match.group(1)!,
  );

  text = text.replaceAllMapped(
    RegExp(r'\{@recharge (\d+)-(\d+)\}'),
    (match) => 'Recharge ${match.group(1)}-${match.group(2)}',
  );

  text = text.replaceAllMapped(RegExp(r'\{@recharge (\d+)\}'), (match) {
    final min = int.parse(match.group(1)!);
    return 'Recharge $min-${min + 1}';
  });

  // Catch-all for any remaining {@tag content} patterns
  text = text.replaceAllMapped(
    RegExp(r'\{@\w+ ([^}]+)\}'),
    (match) => match.group(1)!,
  );

  return text;
}

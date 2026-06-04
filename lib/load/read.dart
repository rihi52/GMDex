import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../components/statblock.dart';

Future<dynamic> loadMonsters() async {
  final jsonString = await rootBundle.loadString('assets/mm.json');
  final data = jsonDecode(jsonString);

  return data;
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

Future<Creature> test() async {
  final data = await loadMonsters();
  final skills = data['skill'] ?? {};
  final save = data['save'] ?? {};
  final creature = Creature(
    name: data['name'],
    size: sizeNames[data['size'][0]] ?? data['size'][0],
    type: data['type'],
    alignment: 
      (data['alignment'] as List?)?.map((a) => alignmentNames[a] ?? a).join(' ') ?? 'Unaligned',
    armorClass: CreatureArmorClass(
      ac: data['ac'][0]['ac'],
      type: (data['ac'][0]['from'] as List?)?.first ?? 'Unknown',
    ),
    hitPoints: data['hp']['average'],
    hitPointFormula: data['hp']['formula'] ?? '',
    challengeRating: data['cr'],
    speed: CreatureSpeed(
      walk: data['speed']['walk'] ?? 0,
      fly: data['speed']['fly'] ?? 0,
      climb: data['speed']['climb'] ?? 0,
      swim: data['speed']['swim'] ?? 0,
      burrow: data['speed']['burrow'] ?? 0,
    ),
    abilityScores: CreatureAbilityScores(
      strength: data['str'],
      dexterity: data['dex'],
      constitution: data['con'],
      intelligence: data['int'],
      wisdom: data['wis'],
      charisma: data['cha'],
    ),
    skills: CreatureSkills(
      athletics: skills['athletics']?.toString() ?? '0',
      acrobatics: skills['acrobatics']?.toString() ?? '0',
      sleightOfHand: skills['sleightOfHand']?.toString() ?? '0',
      stealth: skills['stealth']?.toString() ?? '0',
      arcana: skills['arcana']?.toString() ?? '0',
      history: skills['history']?.toString() ?? '0',
      investigation: skills['investigation']?.toString() ?? '0',
      nature: skills['nature']?.toString() ?? '0',
      religion: skills['religion']?.toString() ?? '0',
      animalHandling: skills['animalHandling']?.toString() ?? '0',
      insight: skills['insight']?.toString() ?? '0',
      medicine: skills['medicine']?.toString() ?? '0',
      perception: skills['perception']?.toString() ?? '0',
      survival: skills['survival']?.toString() ?? '0',
      deception: skills['deception']?.toString() ?? '0',
      intimidation: skills['intimidation']?.toString() ?? '0',
      performance: skills['performance']?.toString() ?? '0',
    ),
    savingThrows: CreatureSavingThrows(
      strength: int.tryParse(save['str'] ?? '0') ?? 0,
      dexterity: int.tryParse(save['dex'] ?? '0') ?? 0,
      constitution: int.tryParse(save['con'] ?? '0') ?? 0,
      intelligence: int.tryParse(save['int'] ?? '0') ?? 0,
      wisdom: int.tryParse(save['wis'] ?? '0') ?? 0,
      charisma: int.tryParse(save['cha'] ?? '0') ?? 0,
    ),
    actions: List<CreatureAction>.from(
      (data['action'] as List? ?? []).map(
        (action) => CreatureAction(
          name: action['name'],
          description: (action['entries'] as List).join('\n'),
          type: ActionType.action,
        ),
      ),
    ),
    traits: List<CreatureTrait>.from(
      (data['trait'] as List? ?? []).map(
        (trait) => CreatureTrait(
          name: trait['name'],
          description: (trait['entries'] as List).join('\n'),
        ),
      ),
    ),
    regionalEffect: null,
    id: 1,
  );
  return creature;
}
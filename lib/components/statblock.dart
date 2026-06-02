import 'package:flutter/material.dart';
// import '../theme/apptheme.dart';

class CreatureStatBlock extends StatefulWidget {
  const CreatureStatBlock({super.key});

  @override
  State<CreatureStatBlock> createState() => _CreatureStatBlockState();
}

class _CreatureStatBlockState extends State<CreatureStatBlock> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: const Column(
        children: [],
      ),
    );
  }
}

class Creature {
  final String name;
  final String size;
  final String type;
  final String alignment;
  final int armorClass;
  final int hitPoints;
  final String hitPointFormula;
  final String challengeRating;
  final CreatureSpeed speed;
  final CreatureAbilityScores abilityScores;
  final CreatureSkills skills;
  final CreatureSavingThrows savingThrows;
  final List<CreatureAction> actions;
  final List<CreatureTrait> traits;
  final CreatureRegionalEffect? regionalEffect;

  final int id;

  const Creature({
    required this.name,
    required this.size,
    required this.type,
    required this.alignment,
    required this.armorClass,
    required this.hitPoints,
    required this.hitPointFormula,
    required this.challengeRating,
    required this.speed,
    required this.abilityScores,
    required this.skills,
    required this.savingThrows,
    required this.actions,
    required this.traits,
    required this.regionalEffect,
    required this.id,
  });
}

class CreatureSpeed {
  final int? walk;
  final int? fly;
  final int? climb;
  final int? swim;
  final int? burrow;

  const CreatureSpeed({
    required this.walk,
    required this.fly,
    required this.climb,
    required this.swim,
    required this.burrow,
  });
}

class CreatureAbilityScores {
  final int strength;
  final int dexterity;
  final int constitution;
  final int intelligence;
  final int wisdom;
  final int charisma;

  const CreatureAbilityScores({
    required this.strength,
    required this.dexterity,
    required this.constitution,
    required this.intelligence,
    required this.wisdom,
    required this.charisma,
  });
}

class CreatureSkills {
  final String athletics;
  final String acrobatics;
  final String sleightOfHand;
  final String stealth;
  final String arcana;
  final String history;
  final String investigation;
  final String nature;
  final String religion;
  final String animalHandling;
  final String insight;
  final String medicine;
  final String perception;
  final String survival;
  final String deception;
  final String intimidation;
  final String performance;

  const CreatureSkills({
    required this.athletics,
    required this.acrobatics,
    required this.sleightOfHand,
    required this.stealth,
    required this.arcana,
    required this.history,
    required this.investigation,
    required this.nature,
    required this.religion,
    required this.animalHandling,
    required this.insight,
    required this.medicine,
    required this.perception,
    required this.survival,
    required this.deception,
    required this.intimidation,
    required this.performance,
  });
}

class CreatureSavingThrows {
  final int strength;
  final int dexterity;
  final int constitution;
  final int intelligence;
  final int wisdom;
  final int charisma;

  const CreatureSavingThrows({
    required this.strength,
    required this.dexterity,
    required this.constitution,
    required this.intelligence,
    required this.wisdom,
    required this.charisma,
  });
}

enum ActionType {
  action,
  blurb,
  bonusAction,
  reaction,
  legendary,
  lair,
  special,
  villainAction,
}

class CreatureAction {
  final String name;
  final String description;
  final ActionType type;

  const CreatureAction({
    required this.name,
    required this.description,
    required this.type,
  });
}

class CreatureTrait {
  final String name;
  final String description;

  const CreatureTrait({
    required this.name,
    required this.description,
  });
}

class CreatureRegionalEffect {
  final String blurb;
  final List<String> bulletPoints;
  final String blurbEnd;

  const CreatureRegionalEffect({
    required this.blurb,
    required this.bulletPoints,
    required this.blurbEnd,
  });
}

import 'package:flutter/material.dart';
import '../theme/apptheme.dart';
import 'package:google_fonts/google_fonts.dart';

class CreatureStatBlock extends StatelessWidget {
  final Creature? creature;

  const CreatureStatBlock({super.key, required this.creature});

  @override
  Widget build(BuildContext context) {
    if (creature == null) return const Text("Loading...");

    return Container(
      // color: AppColors.cardBackground,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.primary, width: 1),
              ),
            ),
            child: creature == null
                ? const Text("Loading...")
                : Text(creature!.name),
          ),
          Container(
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.primary, width: 1),
              ),
            ),
            child: Row(
              children: [
                Text(
                  '${creature!.size} ',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Text(
                  '${creature!.type}, ',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Text(
                  creature!.alignment,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.primary, width: 1),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Armor Class:  ',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      '${creature!.armorClass.ac.toString()}, ${creature!.armorClass.type}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Hit Points:  ',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      '${creature!.hitPoints}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      '(${creature!.hitPointFormula})',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Speed: ',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      '${creature!.speed.walk ?? 0} ft.',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    if ((creature!.speed.fly ?? 0) > 0)
                      Text(
                        ', fly ${creature!.speed.fly} ft.',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    if ((creature!.speed.climb ?? 0) > 0)
                      Text(
                        ', climb ${creature!.speed.climb} ft.',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    if ((creature!.speed.swim ?? 0) > 0)
                      Text(
                        ', swim ${creature!.speed.swim} ft.',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    if ((creature!.speed.burrow ?? 0) > 0)
                      Text(
                        ', burrow ${creature!.speed.burrow} ft.',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              Column(
                children:[
                  Text(
                    'STR',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Text(
                    '${creature!.abilityScores.strength}',
                    style: Theme.of(context).textTheme.labelSmall,
                  )
                ]
              ),
            ],
          ),
          /* NEXT CHILD GOES HERE */
        ],
      ),
    );
  }
}

class Creature {
  final String name;
  final String size;
  final String type;
  final String alignment;
  final CreatureArmorClass armorClass;
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

class CreatureArmorClass {
  final int ac;
  final String type;

  const CreatureArmorClass({required this.ac, required this.type});
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

  const CreatureTrait({required this.name, required this.description});
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

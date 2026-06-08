import 'package:flutter/material.dart';
import '../theme/apptheme.dart';
import 'package:google_fonts/google_fonts.dart';

class CreatureStatBlock extends StatelessWidget {
  final Creature? creature;

  const CreatureStatBlock({super.key, required this.creature});

  @override
  Widget build(BuildContext context) {
    if (creature == null) return const Text("Loading...");

    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.white, Colors.white, Colors.transparent],
        stops: const [0.0, 0.97, 1.0],
      ).createShader(bounds),
      blendMode: BlendMode.dstIn,
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppSpacing.spacingSmall),
          ),
          padding: EdgeInsets.all(AppSpacing.spacingSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  bottom: AppSpacing.spacingSmall,
                  top: AppSpacing.spacingSmall,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.primary, width: 1),
                  ),
                ),
                child: creature == null
                    ? const Text("Loading...")
                    : Text(
                        creature!.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  bottom: AppSpacing.spacingSmall,
                  top: AppSpacing.spacingSmall,
                ),
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
                padding: const EdgeInsets.only(
                  bottom: AppSpacing.spacingSmall,
                  top: AppSpacing.spacingSmall,
                ),
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
                          style: Theme.of(context).textTheme.titleSmall,
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
                          style: Theme.of(context).textTheme.titleSmall,
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
                          style: Theme.of(context).textTheme.titleSmall,
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
              Container(
                padding: const EdgeInsets.only(
                  bottom: AppSpacing.spacingSmall,
                  top: AppSpacing.spacingSmall,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.primary, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Text(
                          'STR',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          '${creature!.abilityScores.strength} (${creature!.abilityScores.strengthModifier >= 0 ? '+' : ''}${creature!.abilityScores.strengthModifier})',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.abilityBoxes),
                    Column(
                      children: [
                        Text(
                          'DEX',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          '${creature!.abilityScores.dexterity} (${creature!.abilityScores.dexterityModifier >= 0 ? '+' : ''}${creature!.abilityScores.dexterityModifier})',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.abilityBoxes),
                    Column(
                      children: [
                        Text(
                          'CON',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          '${creature!.abilityScores.constitution} (${creature!.abilityScores.constitutionModifier >= 0 ? '+' : ''}${creature!.abilityScores.constitutionModifier})',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.abilityBoxes),
                    Column(
                      children: [
                        Text(
                          'INT',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          '${creature!.abilityScores.intelligence} (${creature!.abilityScores.intelligenceModifier >= 0 ? '+' : ''}${creature!.abilityScores.intelligenceModifier})',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.abilityBoxes),
                    Column(
                      children: [
                        Text(
                          'WIS',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          '${creature!.abilityScores.wisdom} (${creature!.abilityScores.wisdomModifier >= 0 ? '+' : ''}${creature!.abilityScores.wisdomModifier})',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.abilityBoxes),
                    Column(
                      children: [
                        Text(
                          'CHA',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          '${creature!.abilityScores.charisma} (${creature!.abilityScores.charismaModifier >= 0 ? '+' : ''}${creature!.abilityScores.charismaModifier})',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  bottom: AppSpacing.spacingSmall,
                  top: AppSpacing.spacingSmall,
                ),
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
                          'Saving Throws: ',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        if (creature!.savingThrows.strength != null)
                          Text(
                            'Str ${creature!.savingThrows.strength! >= 0 ? '+' : ''}${creature!.savingThrows.strength}',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        if (creature!.savingThrows.dexterity != null)
                          Text(
                            'Dex ${creature!.savingThrows.dexterity! >= 0 ? '+' : ''}${creature!.savingThrows.dexterity}, ',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        if (creature!.savingThrows.constitution != null)
                          Text(
                            'Con ${creature!.savingThrows.constitution! >= 0 ? '+' : ''}${creature!.savingThrows.constitution}, ',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        if (creature!.savingThrows.intelligence != null)
                          Text(
                            'Int ${creature!.savingThrows.intelligence! >= 0 ? '+' : ''}${creature!.savingThrows.intelligence}, ',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        if (creature!.savingThrows.wisdom != null)
                          Text(
                            'Wis ${creature!.savingThrows.wisdom! >= 0 ? '+' : ''}${creature!.savingThrows.wisdom}, ',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        if (creature!.savingThrows.charisma != null)
                          Text(
                            'Cha ${creature!.savingThrows.charisma! >= 0 ? '+' : ''}${creature!.savingThrows.charisma}, ',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Skills: ',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          [
                            if (creature!.skills.acrobatics != null)
                              'Acrobatics ${creature!.skills.acrobatics!}',
                            if (creature!.skills.animalHandling != null)
                              'Animal Handling ${creature!.skills.animalHandling!}',
                            if (creature!.skills.arcana != null)
                              'Arcana ${creature!.skills.arcana!}',
                            if (creature!.skills.athletics != null)
                              'Athletics ${creature!.skills.athletics!}',
                            if (creature!.skills.deception != null)
                              'Deception ${creature!.skills.deception!}',
                            if (creature!.skills.history != null)
                              'History ${creature!.skills.history!}',
                            if (creature!.skills.insight != null)
                              'Insight ${creature!.skills.insight!}',
                            if (creature!.skills.intimidation != null)
                              'Intimidation ${creature!.skills.intimidation!}',
                            if (creature!.skills.investigation != null)
                              'Investigation ${creature!.skills.investigation!}',
                            if (creature!.skills.medicine != null)
                              'Medicine ${creature!.skills.medicine!}',
                            if (creature!.skills.nature != null)
                              'Nature ${creature!.skills.nature!}',
                            if (creature!.skills.perception != null)
                              'Perception ${creature!.skills.perception!}',
                            if (creature!.skills.performance != null)
                              'Performance ${creature!.skills.performance!}',
                            if (creature!.skills.religion != null)
                              'Religion ${creature!.skills.religion!}',
                            if (creature!.skills.sleightOfHand != null)
                              'Sleight of Hand ${creature!.skills.sleightOfHand!}',
                            if (creature!.skills.stealth != null)
                              'Stealth ${creature!.skills.stealth!}',
                            if (creature!.skills.survival != null)
                              'Survival ${creature!.skills.survival!}',
                          ].join(', '),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Senses: ',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        if (creature!.senses != null)
                          Text(
                            creature!.senses!,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Languages: ',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        if (creature!.languages != null)
                          Text(
                            creature!.languages!,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Challenge: ',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          '${creature!.challengeRating} (${crToXp[creature!.challengeRating] ?? '0'} XP)',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ...creature!.traits.map(
                (trait) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trait.name,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      trait.description,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              ...creature!.actions.map(
                (action) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      action.name,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      action.description,
                      style: Theme.of(context).textTheme.labelSmall,
                      softWrap: true,
                      overflow: TextOverflow.visible, // let it wrap, not clip
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              /* NEXT CHILD GOES HERE */
            ],
          ),
        ),
      ),
    );
  }
}

const crToXp = {
  '0': '10',
  '1/8': '25',
  '1/4': '50',
  '1/2': '100',
  '1': '200',
  '2': '450',
  '3': '700',
  '4': '1,100',
  '5': '1,800',
  '6': '2,300',
  '7': '2,900',
  '8': '3,900',
  '9': '5,000',
  '10': '5,900',
  '11': '7,200',
  '12': '8,400',
  '13': '10,000',
  '14': '11,500',
  '15': '13,000',
  '16': '15,000',
  '17': '18,000',
  '18': '20,000',
  '19': '22,000',
  '20': '25,000',
  '21': '33,000',
  '22': '41,000',
  '23': '50,000',
  '24': '62,000',
  '25': '75,000',
  '26': '90,000',
  '27': '105,000',
  '28': '120,000',
  '29': '135,000',
  '30': '155,000',
};

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
  final String? senses;
  final String? languages;
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
    required this.senses,
    required this.languages,
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
  final int strengthModifier;
  final int dexterity;
  final int dexterityModifier;
  final int constitution;
  final int constitutionModifier;
  final int intelligence;
  final int intelligenceModifier;
  final int wisdom;
  final int wisdomModifier;
  final int charisma;
  final int charismaModifier;

  const CreatureAbilityScores({
    required this.strength,
    required this.strengthModifier,
    required this.dexterity,
    required this.dexterityModifier,
    required this.constitution,
    required this.constitutionModifier,
    required this.intelligence,
    required this.intelligenceModifier,
    required this.wisdom,
    required this.wisdomModifier,
    required this.charisma,
    required this.charismaModifier,
  });
}

class CreatureSavingThrows {
  final int? strength;
  final int? dexterity;
  final int? constitution;
  final int? intelligence;
  final int? wisdom;
  final int? charisma;

  const CreatureSavingThrows({
    required this.strength,
    required this.dexterity,
    required this.constitution,
    required this.intelligence,
    required this.wisdom,
    required this.charisma,
  });
}

class CreatureSkills {
  final String? athletics;
  final String? acrobatics;
  final String? sleightOfHand;
  final String? stealth;
  final String? arcana;
  final String? history;
  final String? investigation;
  final String? nature;
  final String? religion;
  final String? animalHandling;
  final String? insight;
  final String? medicine;
  final String? perception;
  final String? survival;
  final String? deception;
  final String? intimidation;
  final String? performance;

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

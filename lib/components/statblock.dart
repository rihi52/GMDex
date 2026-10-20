import 'package:flutter/material.dart';
import 'package:moonscribe/components/creature_calculations.dart';
import 'package:moonscribe/theme/apptheme.dart';

class CreatureStatBlock extends StatelessWidget {
  final Creature? creature;

  const CreatureStatBlock({super.key, required this.creature});

  @override
  Widget build(BuildContext context) {
    if (creature == null) return const Text("Loading...");

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardSelected,
          borderRadius: BorderRadius.circular(AppSpacing.cornerRadiusMedium),
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
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
            ),
            StatblockSection(
              child: Row(
                children: [
                  StatblockSmallText(data: '${creature!.size} '),
                  StatblockSmallText(data: '${creature!.type}, '),
                  StatblockSmallText(data: creature?.alignment ?? ''),
                ],
              ),
            ),
            StatblockSection(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Armor Class:  ',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      StatblockSmallText(
                        data:
                            '${creature!.armorClass.ac.toString()}, ${creature!.armorClass.type}',
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Hit Points:  ',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      StatblockSmallText(data: '${creature!.hitPoints}'),
                      StatblockSmallText(
                        data: '(${creature!.hitPointFormula})',
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Speed: ',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Expanded(
                        child: StatblockSmallText(
                          data: [
                            if ((creature!.speed.walk ?? 0) > 0)
                              '${creature!.speed.walk} ft.',
                            if ((creature!.speed.fly ?? 0) > 0)
                              'fly ${creature!.speed.fly} ft.',
                            if ((creature!.speed.climb ?? 0) > 0)
                              'climb ${creature!.speed.climb} ft.',
                            if ((creature!.speed.swim ?? 0) > 0)
                              'swim ${creature!.speed.swim} ft.',
                            if ((creature!.speed.burrow ?? 0) > 0)
                              'burrow ${creature!.speed.burrow} ft.',
                          ].join(', '),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            StatblockSection(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        'STR',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      StatblockSmallText(
                        data:
                            '${creature!.abilityScores.strength} (${creature!.abilityScores.strengthModifier >= 0 ? '+' : ''}${creature!.abilityScores.strengthModifier})',
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
                      StatblockSmallText(
                        data:
                            '${creature!.abilityScores.dexterity} (${creature!.abilityScores.dexterityModifier >= 0 ? '+' : ''}${creature!.abilityScores.dexterityModifier})',
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
                      StatblockSmallText(
                        data:
                            '${creature!.abilityScores.constitution} (${creature!.abilityScores.constitutionModifier >= 0 ? '+' : ''}${creature!.abilityScores.constitutionModifier})',
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
                      StatblockSmallText(
                        data:
                            '${creature!.abilityScores.intelligence} (${creature!.abilityScores.intelligenceModifier >= 0 ? '+' : ''}${creature!.abilityScores.intelligenceModifier})',
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
                      StatblockSmallText(
                        data:
                            '${creature!.abilityScores.wisdom} (${creature!.abilityScores.wisdomModifier >= 0 ? '+' : ''}${creature!.abilityScores.wisdomModifier})',
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
                      StatblockSmallText(
                        data:
                            '${creature!.abilityScores.charisma} (${creature!.abilityScores.charismaModifier >= 0 ? '+' : ''}${creature!.abilityScores.charismaModifier})',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            StatblockSection(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Saving Throws: ',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      if (creature!.savingThrows.strength != null)
                        StatblockSmallText(
                          data:
                              'Str ${creature!.savingThrows.strength! >= 0 ? '+' : ''}${creature!.savingThrows.strength}',
                        ),
                      if (creature!.savingThrows.dexterity != null)
                        StatblockSmallText(
                          data:
                              'Dex ${creature!.savingThrows.dexterity! >= 0 ? '+' : ''}${creature!.savingThrows.dexterity}, ',
                        ),
                      if (creature!.savingThrows.constitution != null)
                        StatblockSmallText(
                          data:
                              'Con ${creature!.savingThrows.constitution! >= 0 ? '+' : ''}${creature!.savingThrows.constitution}, ',
                        ),
                      if (creature!.savingThrows.intelligence != null)
                        StatblockSmallText(
                          data:
                              'Int ${creature!.savingThrows.intelligence! >= 0 ? '+' : ''}${creature!.savingThrows.intelligence}, ',
                        ),
                      if (creature!.savingThrows.wisdom != null)
                        StatblockSmallText(
                          data:
                              'Wis ${creature!.savingThrows.wisdom! >= 0 ? '+' : ''}${creature!.savingThrows.wisdom}, ',
                        ),
                      if (creature!.savingThrows.charisma != null)
                        StatblockSmallText(
                          data:
                              'Cha ${creature!.savingThrows.charisma! >= 0 ? '+' : ''}${creature!.savingThrows.charisma}, ',
                        ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Skills: ',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      StatblockSmallText(
                        data: [
                          if (creature!.skills?.acrobatics != null)
                            'Acrobatics ${creature!.skills?.acrobatics!}',
                          if (creature!.skills?.animalHandling != null)
                            'Animal Handling ${creature!.skills?.animalHandling!}',
                          if (creature!.skills?.arcana != null)
                            'Arcana ${creature!.skills?.arcana!}',
                          if (creature!.skills?.athletics != null)
                            'Athletics ${creature!.skills?.athletics!}',
                          if (creature!.skills?.deception != null)
                            'Deception ${creature!.skills?.deception!}',
                          if (creature!.skills?.history != null)
                            'History ${creature!.skills?.history!}',
                          if (creature!.skills?.insight != null)
                            'Insight ${creature!.skills?.insight!}',
                          if (creature!.skills?.intimidation != null)
                            'Intimidation ${creature!.skills?.intimidation!}',
                          if (creature!.skills?.investigation != null)
                            'Investigation ${creature!.skills?.investigation!}',
                          if (creature!.skills?.medicine != null)
                            'Medicine ${creature!.skills?.medicine!}',
                          if (creature!.skills?.nature != null)
                            'Nature ${creature!.skills?.nature!}',
                          if (creature!.skills?.perception != null)
                            'Perception ${creature!.skills?.perception!}',
                          if (creature!.skills?.performance != null)
                            'Performance ${creature!.skills?.performance!}',
                          if (creature!.skills?.religion != null)
                            'Religion ${creature!.skills?.religion!}',
                          if (creature!.skills?.sleightOfHand != null)
                            'Sleight of Hand ${creature!.skills?.sleightOfHand!}',
                          if (creature!.skills?.stealth != null)
                            'Stealth ${creature!.skills?.stealth!}',
                          if (creature!.skills?.survival != null)
                            'Survival ${creature!.skills?.survival!}',
                        ].join(', '),
                      ),
                    ],
                  ),
                  if (creature?.senses != null && creature?.senses != '')
                    Row(
                      children: [
                        Text(
                          'Senses: ',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        if (creature?.senses != null && creature?.senses != '')
                          StatblockSmallText(data: creature!.senses!),
                      ],
                    ),
                  Row(
                    children: [
                      Text(
                        'Languages: ',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      if (creature!.languages != null)
                        StatblockSmallText(data: creature!.languages!),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Challenge: ',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      StatblockSmallText(data: '${creature!.challengeRating}'),
                      StatblockSmallText(
                        data:
                            '   Proficiency Bonus: +${creature?.proficiencyBonus?.toInt() ?? proficiencyBonusCalc(tryParseFraction(creature!.challengeRating.cr) ?? 2)}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (creature!.traits != null)
              ...creature!.traits!.map(
                (trait) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trait.name,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    StatblockSmallText(data: trait.description),
                    const SizedBox(height: AppSpacing.spacingMedium),
                  ],
                ),
              ),
            /* Add spellcasting */
            if (creature!.spellCasting != null) // if creature has spells
              Container(
                padding: const EdgeInsets.only(
                  bottom: AppSpacing.spacingSmall,
                  top: AppSpacing.spacingSmall,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /* innate spell casting */
                    if (creature!.spellCasting!.innateSpell != null) ...[
                      Text(
                        'Innate Spellcasting',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      StatblockSmallText(
                        data: creature!.spellCasting!.headerEntries,
                      ),
                      ...creature!.spellCasting!.innateSpell!.entries.map(
                        (entry) => Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StatblockSmallText(
                              data: '${innateSpellLevelNames[entry.key]}: ',
                            ),
                            Expanded(
                              child: Text(
                                entry.value.join(', '),
                                style: Theme.of(context).textTheme.labelSmall,
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (creature!.spellCasting!.spells != null &&
                        creature!.spellCasting!.innateSpell != null)
                      const SizedBox(height: AppSpacing.spacingMedium),
                    if (creature!.spellCasting!.spells != null) ...[
                      // if creature is regular spellcaster
                      Text(
                        'Spellcasting',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      StatblockSmallText(
                        data: creature!.spellCasting!.headerEntries,
                      ),
                      const SizedBox(height: AppSpacing.spacingSmall),
                      ...creature!.spellCasting!.spells!.entries.map(
                        // takes the map<int, SpellLevel> from CreatureSpellcasting and makes it iterable with .entries .map transforms it into the row shown on the next line
                        (entry) => Row(
                          // each entry goes on its on row, i.e. [0 : "spell1", "spell2"] is a row
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StatblockSmallText(
                              data: // key is the spell level, reads from const. entry.key is spell level from map. checks if slots are 0, prints if they aren't and assumes cantrips if they are
                                  '${spellLevelNames[entry.key] ?? "${entry.key}th level"}${entry.key == 0 ? ' (at will): ' : ' (${entry.value.slots} slots): '}',
                            ),
                            StatblockSmallText(
                              data: entry.value.spells.join(
                                ', ',
                              ), // joins each string together with ', ' between them
                            ),
                            //),
                            const SizedBox(height: AppSpacing.spacingMedium),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.spacingSmall),
                      if (creature!.spellCasting!.footerEntries != null)
                        StatblockSmallText(
                          data: '${creature!.spellCasting!.footerEntries}',
                        ),
                    ],
                  ],
                ),
              ),
            if (creature?.actions != null)
              ...buildActionSections(context, creature!.actions!),
            if (creature!.regionalEffect != null)
              StatblockSection(
                child: Text(
                  'Regional Effects',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            if (creature!.regionalEffect != null) ...[
              StatblockSmallText(data: creature!.regionalEffect!.blurb),
              SizedBox(height: AppSpacing.spacingSmall),
              ...creature!.regionalEffect!.bulletPoints.map(
                (point) => StatblockSmallText(data: '• $point\n'),
              ),
              if (creature!.regionalEffect!.blurbEnd != null)
                StatblockSmallText(data: creature!.regionalEffect!.blurbEnd!),
            ],
            /* NEXT CHILD GOES HERE */
            SizedBox(height: AppSpacing.spacingLarge),
          ],
        ),
      ),
    );
  }
}

// /* Helper Functions */

List<Widget> buildActionSections(
  BuildContext context,
  List<CreatureAction> actions,
) {
  final grouped = <ActionType, List<CreatureAction>>{};
  for (final action in actions) {
    grouped.putIfAbsent(action.type, () => []).add(action);
  }
  return [
    for (final entry in grouped.entries) ...[
      Container(
        margin: const EdgeInsets.only(top: AppSpacing.spacingSmall),
        padding: const EdgeInsets.only(bottom: AppSpacing.spacingSmall),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.primary, width: 1),
          ),
        ),
        child: Text(
          entry.key.displayName,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      ...entry.value.map(
        (action) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (action.name.isNotEmpty)
              Text(action.name, style: Theme.of(context).textTheme.titleSmall),
            Text(
              action.description,
              style: Theme.of(context).textTheme.labelSmall,
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
            const SizedBox(height: AppSpacing.spacingMedium),
          ],
        ),
      ),
    ],
  ];
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
  final String? size;
  final String? type;
  final String? alignment;
  final CreatureArmorClass armorClass;
  final int hitPoints;
  final String? hitPointFormula;
  final CreatureCR challengeRating;
  final double? proficiencyBonus;
  final CreatureSpeed speed;
  final CreatureAbilityScores abilityScores;
  final CreatureSkills? skills;
  final String? senses;
  final String? languages;
  final CreatureSavingThrows savingThrows;
  final CreatureSpellcasting? spellCasting;
  final List<CreatureAction>? actions;
  final List<CreatureTrait>? traits;
  final CreatureRegionalEffect? regionalEffect;

  final int? id;

  const Creature({
    required this.name,
    this.size,
    this.type,
    this.alignment,
    required this.armorClass,
    required this.hitPoints,
    this.hitPointFormula,
    required this.challengeRating,
    this.proficiencyBonus,
    required this.speed,
    required this.abilityScores,
    this.skills,
    this.senses,
    this.languages,
    required this.savingThrows,
    this.spellCasting,
    this.actions,
    this.traits,
    this.regionalEffect,
    this.id,
  });
}

class SpellLevel {
  final int? slots;
  final List<String> spells;

  const SpellLevel({this.slots, required this.spells});
}

const spellLevelNames = {
  0: 'Cantrip',
  1: '1st level',
  2: '2nd level',
  3: '3rd level',
  4: '4th level',
  5: '5th level',
  6: '6th level',
  7: '7th level',
  8: '8th level',
  9: '9th level',
};

const innateSpellLevelNames = {
  'will': 'At will',
  '1': '1/day',
  '1e': '1/day',
  '2e': '2/day',
  '3e': '3/day',
  '4e': '4/day',
  '5e': '5/day',
  '6e': '6/day',
  '7e': '7/day',
  '8e': '8/day',
  '9e': '9/day',
};

class CreatureSpellcasting {
  final String name;
  final String headerEntries;
  final String? footerEntries;
  final String ability;
  final Map<int, SpellLevel>? spells; // keyed by level 0-9
  final Map<String, List<String>>?
  innateSpell; // keyed by times per day, value is spell

  const CreatureSpellcasting({
    required this.name,
    required this.headerEntries,
    this.footerEntries,
    required this.ability,
    this.spells,
    this.innateSpell,
  });
}

class CreatureArmorClass {
  final int ac;
  final String type;

  CreatureArmorClass copy() => CreatureArmorClass(ac: ac, type: type);

  const CreatureArmorClass({required this.ac, required this.type});
}

class CreatureCR {
  final String cr;
  final String? lair;
  final String? coven;
  final int? _xpOverride;

  const CreatureCR({required this.cr, this.lair, this.coven, this._xpOverride});

  String get xp => _xpOverride?.toString() ?? crToXp[cr] ?? '0';
  String? get lairXp => lair != null ? crToXp[lair] : null;
  String? get covenXp => coven != null ? crToXp[coven] : null;

  @override
  String toString() {
    return [
      '$cr ($xp XP)',
      if (lair != null) 'lair: $lair ($lairXp XP)',
      if (coven != null) 'coven: $coven ($covenXp XP)',
    ].join(', ');
  }
}

class CreatureSpeed {
  final int? walk;
  final int? fly;
  final int? climb;
  final int? swim;
  final int? burrow;
  final String? condition;

  const CreatureSpeed({
    this.walk,
    this.fly,
    this.climb,
    this.swim,
    this.burrow,
    this.condition,
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
  final bool? isStrProf;
  final int? dexterity;
  final bool? isDexProf;
  final int? constitution;
  final bool? isConProf;
  final int? intelligence;
  final bool? isIntProf;
  final int? wisdom;
  final bool? isWisProf;
  final int? charisma;
  final bool? isChaProf;

  const CreatureSavingThrows({
    required this.strength,
    required this.dexterity,
    required this.constitution,
    required this.intelligence,
    required this.wisdom,
    required this.charisma,
    this.isStrProf,
    this.isDexProf,
    this.isConProf,
    this.isIntProf,
    this.isWisProf,
    this.isChaProf,
  });
}

class CreatureSkills {
  final String? athletics;
  final bool? isAthleticsProf;
  final String? acrobatics;
  final bool? isAcrobaticsProf;
  final String? sleightOfHand;
  final bool? isSleightOfHandProf;
  final String? stealth;
  final bool? isStealthProf;
  final String? arcana;
  final bool? isArcanaProf;
  final String? history;
  final bool? isHistoryProf;
  final String? investigation;
  final bool? isInvestigationProf;
  final String? nature;
  final bool? isNatureProf;
  final String? religion;
  final bool? isReligionProf;
  final String? animalHandling;
  final bool? isAnimalHandlingProf;
  final String? insight;
  final bool? isInsightProf;
  final String? medicine;
  final bool? isMedicineProf;
  final String? perception;
  final bool? isPerceptionProf;
  final String? survival;
  final bool? isSurvivalProf;
  final String? deception;
  final bool? isDeceptionProf;
  final String? intimidation;
  final bool? isIntimidationProf;
  final String? persuasion;
  final bool? isPersuasionProf;
  final String? performance;
  final bool? isPerformanceProf;

  const CreatureSkills({
    required this.athletics,
    this.isAthleticsProf,
    required this.acrobatics,
    this.isAcrobaticsProf,
    required this.sleightOfHand,
    this.isSleightOfHandProf,
    required this.stealth,
    this.isStealthProf,
    required this.arcana,
    this.isArcanaProf,
    required this.history,
    this.isHistoryProf,
    required this.investigation,
    this.isInvestigationProf,
    required this.nature,
    this.isNatureProf,
    required this.religion,
    this.isReligionProf,
    required this.animalHandling,
    this.isAnimalHandlingProf,
    required this.insight,
    this.isInsightProf,
    required this.medicine,
    this.isMedicineProf,
    required this.perception,
    this.isPerceptionProf,
    required this.persuasion,
    this.isPersuasionProf,
    required this.survival,
    this.isSurvivalProf,
    required this.deception,
    this.isDeceptionProf,
    required this.intimidation,
    this.isIntimidationProf,
    required this.performance,
    this.isPerformanceProf,
  });
}

enum ActionType {
  action('Action'),
  blurb('Blurb'),
  bonusAction('Bonus Action'),
  reaction('Reaction'),
  legendary('Legendary'),
  lair('Lair'),
  special('Special'),
  villainAction('Villain Action');

  const ActionType(this.label);
  final String label;
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

extension ActionTypeDisplay on ActionType {
  String get displayName => switch (this) {
    ActionType.action => 'Actions',
    ActionType.blurb => 'Blurb',
    ActionType.legendary => 'Legendary Actions',
    ActionType.bonusAction => 'Bonus Actions',
    ActionType.reaction => 'Reactions',
    ActionType.lair => 'Lair Actions',
    ActionType.special => 'Special Abilities',
    ActionType.villainAction => 'Villain Actions',
  };
}

class CreatureTrait {
  final String name;
  final String description;

  const CreatureTrait({required this.name, required this.description});
}

class CreatureRegionalEffect {
  final String blurb;
  final List<String> bulletPoints;
  final String? blurbEnd;

  const CreatureRegionalEffect({
    required this.blurb,
    required this.bulletPoints,
    this.blurbEnd,
  });
}

/// ****************
/// Statblock Components
/// ***************

class StatblockSection extends StatelessWidget {
  const StatblockSection({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: AppSpacing.spacingSmall,
        top: AppSpacing.spacingSmall,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.primary, width: 1)),
      ),
      child: child,
    );
  }
}

class StatblockSmallText extends StatelessWidget {
  const StatblockSmallText({super.key, required this.data, this.alignment});

  final String data;
  final TextAlign? alignment;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.labelSmall,
      textAlign: alignment,
    );
  }
}

class StatblockVerticalDivider extends StatelessWidget {
  const StatblockVerticalDivider({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: 5,
      child: Container(
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: AppColors.primary, width: 1)),
        ),
      ),
    );
  }
}

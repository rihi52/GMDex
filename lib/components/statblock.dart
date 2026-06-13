import 'package:flutter/material.dart';
import '../theme/apptheme.dart';

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
                      Expanded(
                        child: Text(
                          [
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
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
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
                        '${creature!.challengeRating}',
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
                  const SizedBox(height: AppSpacing.spacingMedium,),
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
                      Text(
                        creature!.spellCasting!.headerEntries,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      ...creature!.spellCasting!.innateSpell!.entries.map(
                        (entry) => Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${innateSpellLevelNames[entry.key]}: ',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            Expanded(
                              child:
                            Text(
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
                    if (creature!.spellCasting!.spells != null && creature!.spellCasting!.innateSpell != null)
                      const SizedBox(height: AppSpacing.spacingMedium,),
                    if (creature!.spellCasting!.spells != null) ...[ // if creature is regular spellcaster
                      Text(
                        'Spellcasting',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        creature!.spellCasting!.headerEntries,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: AppSpacing.spacingSmall,),
                      ...creature!.spellCasting!.spells!.entries.map( // takes the map<int, SpellLevel> from CreatureSpellcasting and makes it iterable with .entries .map transforms it into the row shown on the next line
                        (entry) => Row( // each entry goes on its on row, i.e. [0 : "spell1", "spell2"] is a row
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // key is the spell level, reads from const. entry.key is spell level from map. checks if slots are 0, prints if they aren't and assumes cantrips if they are       
                              '${spellLevelNames[entry.key] ?? "${entry.key}th level"}${entry.key == 0 ? ' (at will): ' : ' (${entry.value.slots} slots): '}',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                              Text(
                                entry.value.spells.join(', '), // joins each string together with ', ' between them
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            //),
                            const SizedBox(height: AppSpacing.spacingMedium,),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.spacingSmall,),
                      if (creature!.spellCasting!.footerEntries != null)
                      Text('${creature!.spellCasting!.footerEntries}',
                      style: Theme.of(context).textTheme.labelSmall,),
                    ],
                  ],
                ),
              ),
            ...buildActionSections(context, creature!.actions),
            if (creature!.regionalEffect != null)
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
                child: Text(
                  'Regional Effects',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            if (creature!.regionalEffect != null) ...[
              Text(
                creature!.regionalEffect!.blurb,
                style: Theme.of(context).textTheme.labelSmall,
              ),
              SizedBox(height: AppSpacing.spacingSmall,),
              ...creature!.regionalEffect!.bulletPoints.map(
                (point) => Text(
                  '• $point\n',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              if (creature!.regionalEffect!.blurbEnd != null)
                Text(
                  creature!.regionalEffect!.blurbEnd!,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
            ],
            /* NEXT CHILD GOES HERE */
            SizedBox(height: AppSpacing.spacingLarge,),
          ],
        ),
      ),
    );
  }
}

/* Helper Functions */

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
            const SizedBox(height: AppSpacing.spacingMedium,),
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
  final String size;
  final String type;
  final String alignment;
  final CreatureArmorClass armorClass;
  final int hitPoints;
  final String hitPointFormula;
  final CreatureCR challengeRating;
  final CreatureSpeed speed;
  final CreatureAbilityScores abilityScores;
  final CreatureSkills skills;
  final String? senses;
  final String? languages;
  final CreatureSavingThrows savingThrows;
  final CreatureSpellcasting? spellCasting;
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
    this.spellCasting,
    required this.actions,
    required this.traits,
    required this.regionalEffect,
    required this.id,
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
  'will' : 'At will',
  '1'  : '1/day',
  '1e' : '1/day',
  '2e' : '2/day',
  '3e' : '3/day',
  '4e' : '4/day',
  '5e' : '5/day',
  '6e' : '6/day',
  '7e' : '7/day',
  '8e' : '8/day',
  '9e' : '9/day',
};

class CreatureSpellcasting {
  final String name;
  final String headerEntries;
  final String? footerEntries;
  final String ability;
  final Map<int, SpellLevel>? spells; // keyed by level 0-9
  final Map<String, List<String>>? innateSpell; // keyed by times per day, value is spell

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
    required this.walk,
    required this.fly,
    required this.climb,
    required this.swim,
    required this.burrow,
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

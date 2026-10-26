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
  final String? notes;

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
    this.notes,
    this.id,
  });
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

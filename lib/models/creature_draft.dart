// Mutable editing representation of a creature stat block.
//
// Drafts preserve partially entered form values that are not valid in the
// immutable domain model yet. toCreature assembles nested draft sections
// into the model after the editor has collected its fields.
import 'package:gmdex/models/creature.dart';

class CreatureDraft {
  String name;
  String? size;
  String? type;
  String? alignment;
  CreatureArmorClassDraft armorClass;
  int hitPoints;
  String? hitPointFormula;
  CreatureCRDraft challengeRating;
  double? proficiencyBonus;
  CreatureSpeedDraft speed;
  CreatureAbilityScoresDraft abilityScores;
  CreatureSkillsDraft? skills;
  String? senses;
  String? languages;
  CreatureSavingThrowsDraft savingThrows;
  CreatureSpellcastingDraft? spellCasting;
  List<CreatureActionDraft>? actions;
  List<CreatureTraitDraft>? traits;
  CreatureRegionalEffectDraft? regionalEffect;

  int? id;

  /// Converts nested form values into the immutable creature model.
  Creature toCreature() {
    return Creature(
      id: id,
      name: name,
      size: size,
      type: type,
      alignment: alignment,
      armorClass: CreatureArmorClass(ac: armorClass.ac!, type: armorClass.type),
      hitPoints: hitPoints,
      hitPointFormula: hitPointFormula,
      challengeRating: CreatureCR(
        cr: challengeRating.cr,
        lair: challengeRating.lair,
        coven: challengeRating.coven,
      ),
      proficiencyBonus: proficiencyBonus,
      speed: CreatureSpeed(
        walk: speed.walk,
        fly: speed.fly,
        climb: speed.climb,
        swim: speed.swim,
        burrow: speed.burrow,
      ),
      abilityScores: CreatureAbilityScores(
        strength: abilityScores.strength,
        strengthModifier: abilityScores.strengthModifier,
        dexterity: abilityScores.dexterity,
        dexterityModifier: abilityScores.dexterityModifier,
        constitution: abilityScores.constitution,
        constitutionModifier: abilityScores.constitutionModifier,
        intelligence: abilityScores.intelligence,
        intelligenceModifier: abilityScores.intelligenceModifier,
        wisdom: abilityScores.wisdom,
        wisdomModifier: abilityScores.wisdomModifier,
        charisma: abilityScores.charisma,
        charismaModifier: abilityScores.charismaModifier,
      ),
      skills: CreatureSkills(
        athletics: skills?.athletics,
        isAthleticsProf: skills?.isAthleticsProf,
        acrobatics: skills?.acrobatics,
        isAcrobaticsProf: skills?.isAcrobaticsProf,
        sleightOfHand: skills?.sleightOfHand,
        isSleightOfHandProf: skills?.isSleightOfHandProf,
        stealth: skills?.stealth,
        isStealthProf: skills?.isStealthProf,
        arcana: skills?.arcana,
        isArcanaProf: skills?.isArcanaProf,
        history: skills?.history,
        isHistoryProf: skills?.isHistoryProf,
        investigation: skills?.investigation,
        isInvestigationProf: skills?.isInvestigationProf,
        nature: skills?.nature,
        isNatureProf: skills?.isNatureProf,
        religion: skills?.religion,
        isReligionProf: skills?.isReligionProf,
        animalHandling: skills?.animalHandling,
        isAnimalHandlingProf: skills?.isAnimalHandlingProf,
        insight: skills?.insight,
        isInsightProf: skills?.isInsightProf,
        medicine: skills?.medicine,
        isMedicineProf: skills?.isMedicineProf,
        perception: skills?.perception,
        isPerceptionProf: skills?.isPerceptionProf,
        survival: skills?.survival,
        isSurvivalProf: skills?.isSurvivalProf,
        deception: skills?.deception,
        isDeceptionProf: skills?.isDeceptionProf,
        intimidation: skills?.intimidation,
        isIntimidationProf: skills?.isIntimidationProf,
        performance: skills?.performance,
        isPerformanceProf: skills?.isPerformanceProf,
        persuasion: skills?.persuasion,
        isPersuasionProf: skills?.isPersuasionProf,
      ),
      senses: senses,
      languages: languages,
      savingThrows: CreatureSavingThrows(
        strength: savingThrows.strength,
        isStrProf: savingThrows.isStrProf,
        dexterity: savingThrows.dexterity,
        isDexProf: savingThrows.isDexProf,
        constitution: savingThrows.constitution,
        isConProf: savingThrows.isConProf,
        intelligence: savingThrows.intelligence,
        isIntProf: savingThrows.isIntProf,
        wisdom: savingThrows.wisdom,
        isWisProf: savingThrows.isWisProf,
        charisma: savingThrows.charisma,
        isChaProf: savingThrows.isChaProf,
      ),
      spellCasting: spellCasting == null
          ? null
          : CreatureSpellcasting(
              name: spellCasting!.name,
              headerEntries: spellCasting!.headerEntries,
              footerEntries: spellCasting?.footerEntries,
              ability: spellCasting!.ability,
              spells: spellCasting!.spells?.map(
                (level, draft) => MapEntry(
                  level,
                  SpellLevel(
                    slots: draft.slots,
                    spells: draft.spells?.toList() ?? [],
                  ),
                ),
              ),
              innateSpell: spellCasting?.innateSpell,
            ),
      actions: (actions ?? [])
          .map(
            (draft) => CreatureAction(
              name: draft.name,
              description: draft.description,
              type: draft.type!, // decide how to handle a missing type
            ),
          )
          .toList(),

      traits: (traits ?? [])
          .map(
            (draft) =>
                CreatureTrait(name: draft.name, description: draft.description),
          )
          .toList(),
      regionalEffect: regionalEffect == null
          ? null
          : CreatureRegionalEffect(
              blurb: regionalEffect!.blurb,
              bulletPoints: regionalEffect!.bulletPoints ?? [],
              blurbEnd: regionalEffect?.blurbEnd,
            ),
    );
  }

  CreatureDraft({
    this.name = '',
    this.size = '',
    this.type = '',
    this.alignment = '',
    required this.armorClass,
    this.hitPoints = 1,
    this.hitPointFormula = '',
    required this.challengeRating,
    this.proficiencyBonus,
    required this.speed,
    required this.abilityScores,
    this.skills,
    this.senses = '',
    this.languages = '',
    required this.savingThrows,
    this.spellCasting,
    this.actions,
    this.traits,
    this.regionalEffect,
    this.id,
  });
}

/// Editable spell slot count and spell names for one level.
class SpellLevelDraft {
  int? slots;
  List<String>? spells;

  SpellLevelDraft({this.slots, this.spells});
}

/// Mutable prepared/innate spellcasting data used by the editor.
class CreatureSpellcastingDraft {
  String name;
  String headerEntries;
  String? footerEntries;
  String ability;
  Map<int, SpellLevelDraft>? spells; // keyed by level 0-9
  Map<String, List<String>>?
  innateSpell; // keyed by times per day, value is spell

  CreatureSpellcastingDraft({
    this.name = '',
    this.headerEntries = '',
    this.footerEntries,
    this.ability = '',
    this.spells,
    this.innateSpell,
  });
}

/// Editable armor-class total and source text.
class CreatureArmorClassDraft {
  int? ac;
  String type;

  CreatureArmorClassDraft({this.ac, this.type = ''});
}

/// Editable challenge rating and optional encounter adjustments.
class CreatureCRDraft {
  String cr;
  String? lair;
  String? coven;
  final int? _xpOverride;

  CreatureCRDraft({this.cr = '', this.lair, this.coven, this._xpOverride});

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

/// Mutable movement values and their optional condition.
class CreatureSpeedDraft {
  int? walk;
  int? fly;
  int? climb;
  int? swim;
  int? burrow;
  String? condition;

  CreatureSpeedDraft({
    this.walk,
    this.fly,
    this.climb,
    this.swim,
    this.burrow,
    this.condition,
  });
}

/// Editable ability scores and their corresponding modifiers.
class CreatureAbilityScoresDraft {
  int strength;
  int strengthModifier;
  int dexterity;
  int dexterityModifier;
  int constitution;
  int constitutionModifier;
  int intelligence;
  int intelligenceModifier;
  int wisdom;
  int wisdomModifier;
  int charisma;
  int charismaModifier;

  CreatureAbilityScoresDraft({
    this.strength = 10,
    this.strengthModifier = 0,
    this.dexterity = 10,
    this.dexterityModifier = 0,
    this.constitution = 10,
    this.constitutionModifier = 0,
    this.intelligence = 10,
    this.intelligenceModifier = 0,
    this.wisdom = 10,
    this.wisdomModifier = 0,
    this.charisma = 10,
    this.charismaModifier = 0,
  });
}

/// Editable saving-throw values and proficiency selections.
class CreatureSavingThrowsDraft {
  int? strength;
  bool isStrProf = false;
  int? dexterity;
  bool isDexProf = false;
  int? constitution;
  bool isConProf = false;
  int? intelligence;
  bool isIntProf = false;
  int? wisdom;
  bool isWisProf = false;
  int? charisma;
  bool isChaProf = false;

  CreatureSavingThrowsDraft({
    this.strength,
    this.dexterity,
    this.constitution,
    this.intelligence,
    this.wisdom,
    this.charisma,

    required this.isStrProf,
    required this.isDexProf,
    required this.isConProf,
    required this.isIntProf,
    required this.isWisProf,
    required this.isChaProf,
  });
}

/// Editable skill values and proficiency selections.
class CreatureSkillsDraft {
  String? athletics;
  bool? isAthleticsProf;
  String? acrobatics;
  bool? isAcrobaticsProf;
  String? sleightOfHand;
  bool? isSleightOfHandProf;
  String? stealth;
  bool? isStealthProf;
  String? arcana;
  bool? isArcanaProf;
  String? history;
  bool? isHistoryProf;
  String? investigation;
  bool? isInvestigationProf;
  String? nature;
  bool? isNatureProf;
  String? religion;
  bool? isReligionProf;
  String? animalHandling;
  bool? isAnimalHandlingProf;
  String? insight;
  bool? isInsightProf;
  String? medicine;
  bool? isMedicineProf;
  String? perception;
  bool? isPerceptionProf;
  String? persuasion;
  bool? isPersuasionProf;
  String? survival;
  bool? isSurvivalProf;
  String? deception;
  bool? isDeceptionProf;
  String? intimidation;
  bool? isIntimidationProf;
  String? performance;
  bool? isPerformanceProf;

  CreatureSkillsDraft({
    this.athletics,
    this.isAthleticsProf,
    this.acrobatics,
    this.isAcrobaticsProf,
    this.sleightOfHand,
    this.isSleightOfHandProf,
    this.stealth,
    this.isStealthProf,
    this.arcana,
    this.isArcanaProf,
    this.history,
    this.isHistoryProf,
    this.investigation,
    this.isInvestigationProf,
    this.nature,
    this.isNatureProf,
    this.religion,
    this.isReligionProf,
    this.animalHandling,
    this.isAnimalHandlingProf,
    this.insight,
    this.isInsightProf,
    this.medicine,
    this.isMedicineProf,
    this.perception,
    this.isPerceptionProf,
    this.persuasion,
    this.isPersuasionProf,
    this.survival,
    this.isSurvivalProf,
    this.deception,
    this.isDeceptionProf,
    this.intimidation,
    this.isIntimidationProf,
    this.performance,
    this.isPerformanceProf,
  });
}

/// One editable action with its action category.
class CreatureActionDraft {
  String name;
  String description;
  ActionType? type;

  CreatureActionDraft({
    this.name = '',
    this.description = '',
    this.type = ActionType.action,
  });
}

/// One named passive trait and its descriptive text.
class CreatureTraitDraft {
  String name;
  String description;

  CreatureTraitDraft({this.name = '', this.description = ''});
}

/// Editable legendary-group regional effects shown in the stat block.
class CreatureRegionalEffectDraft {
  String blurb;
  List<String>? bulletPoints;
  String? blurbEnd;

  CreatureRegionalEffectDraft({
    this.blurb = '',
    this.bulletPoints,
    this.blurbEnd,
  });
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moonscribe/theme/apptheme.dart';
import 'package:moonscribe/components/statblock.dart';

class StatblockEditorForm extends StatefulWidget {
  const StatblockEditorForm({super.key, this.creature, this.onSubmit});

  final Creature? creature;
  final void Function(Creature)? onSubmit;

  @override
  State<StatblockEditorForm> createState() => _StatblockEditorForm();
}

class _StatblockEditorForm extends State<StatblockEditorForm> {
  final _formKey = GlobalKey<FormState>();
  late final CreatureDraft _draft;
  bool isStrChecked = false;
  bool isDexChecked = false;
  bool isConChecked = false;
  bool isIntChecked = false;
  bool isWisChecked = false;
  bool isChaChecked = false;

  bool isAcrobatics = false;
  bool isAnimalHandling = false;
  bool isArcana = false;
  bool isAthletics = false;
  bool isDeception = false;
  bool isHistory = false;
  bool isInsight = false;
  bool isIntimidation = false;
  bool isInvestigation = false;
  bool isMedicine = false;
  bool isNature = false;
  bool isPerception = false;
  bool isPerformance = false;
  bool isPersuasion = false;
  bool isReligion = false;
  bool isSleightHand = false;
  bool isStealth = false;
  bool isSurvival = false;

  double smallBoxWidth = 120;
  double checkBoxWidth = 50;
  double checkBoxTableHeight = 400;
  double columnWidth = 120 * 2;

  @override
  void initState() {
    super.initState();
  }

  void _submit() {
    final form = _formKey.currentState!;
    if (!form.validate()) return;
    form.save();

    // final creature = Creature();
    _draft.savingThrows!.isDexProf = isDexChecked;

    // widget.onSubmit(creature);
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.creature;

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Form(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardSelected,
            borderRadius: BorderRadius.circular(AppSpacing.cornerRadiusMedium),
          ),
          padding: EdgeInsets.all(AppSpacing.spacingSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StatblockSection(
                child: TextField(
                  style: Theme.of(context).textTheme.titleLarge,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name",
                    labelStyle: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              StatblockSection(
                child: Row(
                  children: [
                    Expanded(
                      child: StatblockEditSmallText(
                        labelText: "Size",
                        startingValue: c?.size,
                        onSaved: (v) => _draft.size = v,
                      ),
                    ),
                    Expanded(
                      child: StatblockEditSmallText(
                        labelText: "Type",
                        startingValue: c?.type,
                        onSaved: (v) => _draft.type = v,
                      ),
                    ),
                    Expanded(
                      child: StatblockEditSmallText(
                        labelText: "Alignment",
                        startingValue: c?.alignment,
                        onSaved: (v) => _draft.alignment = v,
                      ),
                    ),
                  ],
                ),
              ),
              StatblockSection(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: StatblockEditSmallText(
                            labelText: "Armor Class",
                            startingValue: c?.armorClass.ac.toString(),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onSaved: (v) =>
                                _draft.armorClass!.ac = int.tryParse(v) ?? 0,
                          ),
                        ),
                        Expanded(
                          child: StatblockEditSmallText(
                            labelText: "Armor Type",
                            startingValue: c?.armorClass.type,
                            onSaved: (v) => _draft.armorClass!.type = v,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: StatblockEditSmallText(
                            labelText: "Hit Points",
                            startingValue: c?.hitPoints.toString(),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onSaved: (v) =>
                                _draft.hitPoints = int.tryParse(v) ?? 0,
                          ),
                        ),
                        Expanded(
                          child: StatblockEditSmallText(
                            labelText: "Formula (eg: 8d6 + 5)",
                            startingValue: c?.hitPointFormula,
                            onSaved: (v) => _draft.hitPointFormula = v,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: StatblockEditSmallText(
                            labelText: "Walk Speed (ft)",
                            startingValue: c?.speed.walk.toString(),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onSaved: (v) =>
                                _draft.speed!.walk = int.tryParse(v) ?? 0,
                          ),
                        ),
                        Expanded(
                          child: StatblockEditSmallText(
                            labelText: "Fly Speed (ft)",
                            startingValue: c?.speed.fly.toString(),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onSaved: (v) =>
                                _draft.speed!.fly = int.tryParse(v) ?? 0,
                          ),
                        ),
                        Expanded(
                          child: StatblockEditSmallText(
                            labelText: "Climb Speed (ft)",
                            startingValue: c?.speed.climb.toString(),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onSaved: (v) =>
                                _draft.speed!.climb = int.tryParse(v) ?? 0,
                          ),
                        ),
                        Expanded(
                          child: StatblockEditSmallText(
                            labelText: "Swim Speed (ft)",
                            startingValue: c?.speed.swim.toString(),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onSaved: (v) =>
                                _draft.speed!.swim = int.tryParse(v) ?? 0,
                          ),
                        ),
                        Expanded(
                          child: StatblockEditSmallText(
                            labelText: "Burrow Speed (ft)",
                            startingValue: c?.speed.burrow.toString(),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onSaved: (v) =>
                                _draft.speed!.burrow = int.tryParse(v) ?? 0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              StatblockSection(
                child: Row(
                  children: [
                    SizedBox(
                      height: checkBoxTableHeight,
                      width: columnWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          StatblockLabelRow(
                            dataOne: 'Score',
                            dataTwo: 'Proficient',
                            alignment: TextAlign.center,
                            width: smallBoxWidth,
                          ),
                          Row(
                            children: [
                              StatblockEditSmallText(
                                width: smallBoxWidth,
                                labelText: "Str",
                                startingValue: c?.abilityScores.strength
                                    .toString(),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onSaved: (v) => _draft.abilityScores!.strength =
                                    int.tryParse(v) ?? 0,
                              ),
                              SizedBox(
                                width: smallBoxWidth,
                                child: StatblockCheckbox(
                                  initialValue: isStrChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      isStrChecked = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              StatblockEditSmallText(
                                width: smallBoxWidth,
                                labelText: "Dex",
                                startingValue: c?.abilityScores.dexterity
                                    .toString(),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onSaved: (v) =>
                                    _draft.abilityScores!.dexterity =
                                        int.tryParse(v) ?? 0,
                              ),
                              SizedBox(
                                width: smallBoxWidth,
                                child: StatblockCheckbox(
                                  initialValue: isDexChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      isDexChecked = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              StatblockEditSmallText(
                                width: smallBoxWidth,
                                labelText: "Con",
                                startingValue: c?.abilityScores.constitution
                                    .toString(),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onSaved: (v) =>
                                    _draft.abilityScores!.constitution =
                                        int.tryParse(v) ?? 0,
                              ),
                              SizedBox(
                                width: smallBoxWidth,
                                child: StatblockCheckbox(
                                  initialValue: isConChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      isConChecked = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              StatblockEditSmallText(
                                width: smallBoxWidth,
                                labelText: "Int",
                                startingValue: c?.abilityScores.intelligence
                                    .toString(),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onSaved: (v) =>
                                    _draft.abilityScores!.intelligence =
                                        int.tryParse(v) ?? 0,
                              ),
                              SizedBox(
                                width: smallBoxWidth,
                                child: StatblockCheckbox(
                                  initialValue: isIntChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      isIntChecked = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              StatblockEditSmallText(
                                width: smallBoxWidth,
                                labelText: "Wis",
                                startingValue: c?.abilityScores.wisdom
                                    .toString(),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onSaved: (v) => _draft.abilityScores!.wisdom =
                                    int.tryParse(v) ?? 0,
                              ),
                              SizedBox(
                                width: smallBoxWidth,
                                child: StatblockCheckbox(
                                  initialValue: isWisChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      isWisChecked = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              StatblockEditSmallText(
                                width: smallBoxWidth,
                                labelText: "Cha",
                                startingValue: c?.abilityScores.charisma
                                    .toString(),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onSaved: (v) => _draft.abilityScores!.charisma =
                                    int.tryParse(v) ?? 0,
                              ),
                              SizedBox(
                                width: smallBoxWidth,
                                child: StatblockCheckbox(
                                  initialValue: isChaChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      isChaChecked = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    StatblockVerticalDivider(height: checkBoxTableHeight),
                    SizedBox(
                      height: checkBoxTableHeight,
                      width: columnWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          StatblockLabelRow(
                            dataOne: 'Skill',
                            dataTwo: 'Proficient',
                            alignment: TextAlign.center,
                            width: smallBoxWidth,
                          ),
                          StatblockCheckboxRow(
                            label: 'Acrobatics',
                            initalValue: isAcrobatics,
                            width: smallBoxWidth,
                            onChanged: (value) => setState(() {
                              isAcrobatics = value;
                            }),
                          ),
                          StatblockCheckboxRow(
                            label: 'Animal Handling',
                            initalValue: isAnimalHandling,
                            width: smallBoxWidth,
                            onChanged: (value) => setState(() {
                              isAnimalHandling = value;
                            }),
                          ),
                          StatblockCheckboxRow(
                            label: 'Arcana',
                            initalValue: isArcana,
                            width: smallBoxWidth,
                            onChanged: (value) => setState(() {
                              isArcana = value;
                            }),
                          ),
                          StatblockCheckboxRow(
                            label: 'Athletics',
                            initalValue: isAthletics,
                            width: smallBoxWidth,
                            onChanged: (value) => setState(() {
                              isAthletics = value;
                            }),
                          ),
                          StatblockCheckboxRow(
                            label: 'Deception',
                            initalValue: isDeception,
                            width: smallBoxWidth,
                            onChanged: (value) => setState(() {
                              isDeception = value;
                            }),
                          ),
                          StatblockCheckboxRow(
                            label: 'History',
                            initalValue: isHistory,
                            width: smallBoxWidth,
                            onChanged: (value) => setState(() {
                              isHistory = value;
                            }),
                          ),
                          StatblockCheckboxRow(
                            label: 'Insight',
                            initalValue: isInsight,
                            width: smallBoxWidth,
                            onChanged: (value) => setState(() {
                              isInsight = value;
                            }),
                          ),
                          StatblockCheckboxRow(
                            label: 'Intimidation',
                            initalValue: isIntimidation,
                            width: smallBoxWidth,
                            onChanged: (value) => setState(() {
                              isIntimidation = value;
                            }),
                          ),
                          StatblockCheckboxRow(
                            label: 'Investigation',
                            initalValue: isInvestigation,
                            width: smallBoxWidth,
                            onChanged: (value) => setState(() {
                              isInvestigation = value;
                            }),
                          ),
                        ],
                      ),
                    ),
                    StatblockVerticalDivider(height: checkBoxTableHeight),
                    SizedBox(
                      height: checkBoxTableHeight,
                      width: columnWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          StatblockLabelRow(
                            dataOne: 'Skill',
                            dataTwo: 'Proficient',
                            alignment: TextAlign.center,
                            width: smallBoxWidth,
                          ),
                          StatblockCheckboxRow(
                            label: 'Medicine',
                            initalValue: isMedicine,
                            width: smallBoxWidth,
                            onChanged: (value) => setState(() {
                              isMedicine = value;
                            }),
                          ),
                          StatblockCheckboxRow(
                            label: 'Nature',
                            initalValue: isNature,
                            width: smallBoxWidth,
                            onChanged: (value) => setState(() {
                              isNature = value;
                            }),
                          ),
                          StatblockCheckboxRow(
                            label: 'Perception',
                            initalValue: isPerception,
                            width: smallBoxWidth,
                            onChanged: (value) => setState(() {
                              isPerception = value;
                            }),
                          ),
                          StatblockCheckboxRow(
                            label: 'Performance',
                            initalValue: isPerformance,
                            width: smallBoxWidth,
                            onChanged: (value) => setState(() {
                              isPerformance = value;
                            }),
                          ),
                          StatblockCheckboxRow(
                            label: 'Persuasion',
                            initalValue: isPersuasion,
                            width: smallBoxWidth,
                            onChanged: (value) => setState(() {
                              isPersuasion = value;
                            }),
                          ),
                          StatblockCheckboxRow(
                            label: 'Religion',
                            initalValue: isReligion,
                            width: smallBoxWidth,
                            onChanged: (value) => setState(() {
                              isReligion = value;
                            }),
                          ),
                          StatblockCheckboxRow(
                            label: 'Sleight of Hand',
                            initalValue: isSleightHand,
                            width: smallBoxWidth,
                            onChanged: (value) => setState(() {
                              isSleightHand = value;
                            }),
                          ),
                          StatblockCheckboxRow(
                            label: 'Stealth',
                            initalValue: isStealth,
                            width: smallBoxWidth,
                            onChanged: (value) => setState(() {
                              isStealth = value;
                            }),
                          ),
                          StatblockCheckboxRow(
                            label: 'Survival',
                            initalValue: isSurvival,
                            width: smallBoxWidth,
                            onChanged: (value) => setState(() {
                              isSurvival = value;
                            }),
                          ),
                        ],
                      ),
                    ),
                    StatblockVerticalDivider(height: checkBoxTableHeight),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsGeometry.symmetric(
                          horizontal: AppSpacing.spacingMedium,
                        ),
                        child: SizedBox(
                          height: checkBoxTableHeight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: StatblockEditSmallText(
                                  labelText: 'Senses',
                                  startingValue: c?.senses.toString(),
                                  onSaved: (value) => _draft.senses = value,
                                  maxLines: 4,
                                ),
                              ),
                              Expanded(
                                child: StatblockEditSmallText(
                                  labelText: 'Languages',
                                  startingValue: c?.languages.toString(),
                                  onSaved: (value) => _draft.languages = value,
                                  maxLines: 4,
                                ),
                              ),
                              Expanded(
                                child: StatblockEditSmallText(
                                  labelText: 'Challenge Rating',
                                  startingValue: c?.languages.toString(),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  onSaved: (value) =>
                                      _draft.challengeRating!.cr = value,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StatblockSection(
                child: Row(
                  children: [
                    if (c?.traits != null) ...[
                      ...c!.traits.map(
                        (trait) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StatblockEditSmallText(
                              labelText: 'Name',
                              startingValue: trait.name,
                              onSaved: (value) => _draft.alignment = value,
                            ),
                            StatblockSmallText(data: trait.description),
                            const SizedBox(height: AppSpacing.spacingMedium),
                          ],
                        ),
                      ),
                    ] else ...[
                      Column(
                        children: [
                          StatblockEditSmallText(
                            labelText: 'Name',
                            startingValue: '',
                            onSaved: (value) => _draft.alignment = value,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ****************
/// Statblock Classes
/// ***************

class CreatureDraft {
  String name;
  String size;
  String type;
  String alignment;
  CreatureArmorClassDraft? armorClass;
  int hitPoints;
  String hitPointFormula;
  CreatureCRDraft? challengeRating;
  CreatureSpeedDraft? speed;
  CreatureAbilityScoresDraft? abilityScores;
  CreatureSkillsDraft? skills;
  String senses;
  String languages;
  CreatureSavingThrowsDraft? savingThrows;
  CreatureSpellcastingDraft? spellCasting;
  List<CreatureActionDraft>? actions;
  List<CreatureTraitDraft>? traits;
  CreatureRegionalEffectDraft? regionalEffect;

  int? id;

  CreatureDraft({
    this.name = '',
    this.size = '',
    this.type = '',
    this.alignment = '',
    this.armorClass,
    this.hitPoints = 1,
    this.hitPointFormula = '',
    this.challengeRating,
    this.speed,
    this.abilityScores,
    this.skills,
    this.senses = '',
    this.languages = '',
    this.savingThrows,
    this.spellCasting,
    this.actions,
    this.traits,
    this.regionalEffect,
    this.id,
  });
}

class SpellLevelDraft {
  int? slots;
  List<String>? spells;

  SpellLevelDraft({this.slots, this.spells});
}

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

class CreatureArmorClassDraft {
  int ac;
  String type;

  CreatureArmorClassDraft({this.ac = 10, this.type = ''});
}

class CreatureCRDraft {
  String cr;
  String? lair;
  String? coven;
  int? _xpOverride;

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

class CreatureSkillsDraft {
  String? athletics;
  String? acrobatics;
  String? sleightOfHand;
  String? stealth;
  String? arcana;
  String? history;
  String? investigation;
  String? nature;
  String? religion;
  String? animalHandling;
  String? insight;
  String? medicine;
  String? perception;
  String? survival;
  String? deception;
  String? intimidation;
  String? performance;

  CreatureSkillsDraft({
    this.athletics,
    this.acrobatics,
    this.sleightOfHand,
    this.stealth,
    this.arcana,
    this.history,
    this.investigation,
    this.nature,
    this.religion,
    this.animalHandling,
    this.insight,
    this.medicine,
    this.perception,
    this.survival,
    this.deception,
    this.intimidation,
    this.performance,
  });
}

class CreatureActionDraft {
  String name;
  String description;
  ActionType? type;

  CreatureActionDraft({this.name = '', this.description = '', this.type});
}

class CreatureTraitDraft {
  String name;
  String description;

  CreatureTraitDraft({this.name = '', this.description = ''});
}

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

/// ****************
/// Statblock Components
/// ***************

class StatblockEditSmallText extends StatelessWidget {
  const StatblockEditSmallText({
    super.key,
    required this.labelText,
    required this.onSaved,
    required this.startingValue,
    this.required = false,
    this.keyboardType,
    this.inputFormatters,
    this.width,
    this.maxLines,
  });

  final String labelText;
  final void Function(String) onSaved;
  final String? startingValue;
  final bool required;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final double? width;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: AppSpacing.spacingSmall,
          top: AppSpacing.spacingSmall,
        ),
        child: TextFormField(
          maxLines: maxLines,
          initialValue: startingValue,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: Theme.of(context).textTheme.labelSmall,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: labelText,
            labelStyle: Theme.of(context).textTheme.titleSmall,
          ),
          validator: (v) => required && (v == null || v.trim().isEmpty)
              ? '$labelText is required'
              : null,
          onSaved: (v) => onSaved((v ?? '').trim()),
        ),
      ),
    );
  }
}

class StatblockCheckbox extends StatefulWidget {
  const StatblockCheckbox({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  final bool initialValue;
  final ValueChanged<bool> onChanged;

  @override
  State<StatblockCheckbox> createState() => _StatblockCheckboxState();
}

class _StatblockCheckboxState extends State<StatblockCheckbox> {
  late bool _checked;

  @override
  void initState() {
    super.initState();
    _checked = widget.initialValue;
  }

  bool get checked => _checked;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      activeColor: AppColors.primary,
      checkColor: Colors.white,
      value: _checked,
      onChanged: (bool? value) {
        if (value == null) return;
        setState(() {
          _checked = value;
        });
        widget.onChanged(_checked);
      },
    );
  }
}

class StatblockLabelRow extends StatelessWidget {
  const StatblockLabelRow({
    super.key,
    required this.dataOne,
    required this.dataTwo,
    this.alignment,
    this.width,
  });

  final String dataOne;
  final String dataTwo;
  final TextAlign? alignment;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: width,
              child: Text(
                dataOne,
                textAlign: alignment,
                style: Theme.of(context).textTheme.headlineSmall,
              ), // StatblockSmallText(data: dataOne, alignment: alignment),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: width,
              child: Text(
                dataTwo,
                textAlign: alignment,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class StatblockCheckboxRow extends StatelessWidget {
  const StatblockCheckboxRow({
    super.key,
    required this.label,
    required this.initalValue,
    required this.onChanged,
    this.width = 100,
  });

  final String label;
  final bool initalValue;
  final ValueChanged<bool> onChanged;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: width,
          child: StatblockSmallText(data: label, alignment: TextAlign.center),
        ),
        SizedBox(
          width: width,
          child: StatblockCheckbox(
            initialValue: initalValue,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

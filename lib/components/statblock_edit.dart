import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moonscribe/models/creature.dart';
import 'package:moonscribe/models/creature_draft.dart';
import 'package:moonscribe/theme/apptheme.dart';
import 'package:moonscribe/components/statblock.dart';
import 'package:moonscribe/components/creature_calculations.dart';

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

  double smallBoxWidth = 150;
  double checkBoxWidth = 50;
  double checkBoxTableHeight = 455;
  double columnWidth = 150 * 2;

  double buttonWidth = 30;
  double buttonHeight = 35;

  @override
  void initState() {
    super.initState();

    final traits = widget.creature?.traits ?? const <CreatureTrait>[];
    final actions = widget.creature?.actions ?? const <CreatureAction>[];
    final spellcasting = widget.creature?.spellCasting;
    final armorClass = widget.creature?.armorClass;
    final challengeRating = widget.creature?.challengeRating;
    final abilityScore = widget.creature?.abilityScores;
    final savingThrows = widget.creature?.savingThrows;

    isStrChecked = savingThrows?.isStrProf ?? false;
    isDexChecked = savingThrows?.isDexProf ?? false;
    isConChecked = savingThrows?.isConProf ?? false;
    isIntChecked = savingThrows?.isIntProf ?? false;
    isWisChecked = savingThrows?.isWisProf ?? false;
    isChaChecked = savingThrows?.isChaProf ?? false;

    _draft = CreatureDraft(
      armorClass: CreatureArmorClassDraft(
        ac: armorClass?.ac,
        type: armorClass?.type ?? '',
      ),
      challengeRating: CreatureCRDraft(cr: challengeRating?.cr ?? ''),
      abilityScores: CreatureAbilityScoresDraft(
        strength: abilityScore?.strength ?? 10,
        strengthModifier: abilityScore?.strengthModifier ?? 0,
        dexterity: abilityScore?.dexterity ?? 10,
        dexterityModifier: abilityScore?.dexterityModifier ?? 0,
        constitution: abilityScore?.constitution ?? 10,
        constitutionModifier: abilityScore?.constitutionModifier ?? 0,
        intelligence: abilityScore?.intelligence ?? 10,
        intelligenceModifier: abilityScore?.intelligenceModifier ?? 0,
        wisdom: abilityScore?.wisdom ?? 10,
        wisdomModifier: abilityScore?.wisdomModifier ?? 0,
        charisma: abilityScore?.charisma ?? 10,
        charismaModifier: abilityScore?.charismaModifier ?? 0,
      ),
      savingThrows: CreatureSavingThrowsDraft(
        strength: savingThrows?.strength,
        dexterity: savingThrows?.dexterity,
        constitution: savingThrows?.constitution,
        intelligence: savingThrows?.intelligence,
        wisdom: savingThrows?.wisdom,
        charisma: savingThrows?.charisma,
        isStrProf: savingThrows?.strength != null,
        isDexProf: savingThrows?.dexterity != null,
        isConProf: savingThrows?.constitution != null,
        isIntProf: savingThrows?.intelligence != null,
        isWisProf: savingThrows?.wisdom != null,
        isChaProf: savingThrows?.charisma != null,
      ),
      traits: traits
          .map(
            (trait) => CreatureTraitDraft(
              name: trait.name,
              description: trait.description,
            ),
          )
          .toList(),
      actions: actions
          .map(
            (action) => CreatureActionDraft(
              name: action.name,
              description: action.description,
              type: action.type,
            ),
          )
          .toList(),
      speed: CreatureSpeedDraft(
        walk: widget.creature?.speed.walk,
        fly: widget.creature?.speed.fly,
        climb: widget.creature?.speed.climb,
        swim: widget.creature?.speed.swim,
        burrow: widget.creature?.speed.burrow,
      ),
      spellCasting: CreatureSpellcastingDraft(
        name: spellcasting?.name ?? '',
        headerEntries: spellcasting?.headerEntries ?? '',
        footerEntries: spellcasting?.footerEntries,
        ability: spellcasting?.ability ?? '',
        spells: {
          for (var level = 0; level <= 9; level++)
            level: SpellLevelDraft(
              slots: spellcasting?.spells?[level]?.slots,
              spells: List<String>.of(
                spellcasting?.spells?[level]?.spells ?? const <String>[],
              ),
            ),
        },
        innateSpell:
            spellcasting?.innateSpell?.map(
              (uses, spells) => MapEntry(uses, List<String>.of(spells)),
            ) ??
            {},
      ),
    );
  }

  void _addTrait() {
    setState(() => _draft.traits!.add(CreatureTraitDraft()));
  }

  void _addAction() {
    setState(() => _draft.actions!.add(CreatureActionDraft()));
  }

  void _submit() {
    final form = _formKey.currentState!;
    if (!form.validate()) return;
    form.save();

    // final creature = Creature();
    _draft.savingThrows.isDexProf = isDexChecked;
    _draft.savingThrows.isStrProf = isStrChecked;
    _draft.savingThrows.isConProf = isConChecked;
    _draft.savingThrows.isIntProf = isIntChecked;
    _draft.savingThrows.isWisProf = isWisChecked;
    _draft.savingThrows.isChaProf = isChaChecked;

    _draft.abilityScores.strengthModifier = abilityModifier(
      _draft.abilityScores.strength,
    );
    _draft.abilityScores.dexterityModifier = abilityModifier(
      _draft.abilityScores.dexterity,
    );
    _draft.abilityScores.constitutionModifier = abilityModifier(
      _draft.abilityScores.constitution,
    );
    _draft.abilityScores.intelligenceModifier = abilityModifier(
      _draft.abilityScores.intelligence,
    );
    _draft.abilityScores.wisdomModifier = abilityModifier(
      _draft.abilityScores.wisdom,
    );
    _draft.abilityScores.charismaModifier = abilityModifier(
      _draft.abilityScores.charisma,
    );

    final parsedChallengeRating = tryParseFraction(_draft.challengeRating.cr);
    _draft.proficiencyBonus = parsedChallengeRating == null
        ? 2
        : proficiencyBonusCalc(parsedChallengeRating).toDouble();

    _draft.savingThrows.strength = savingThrowBonus(
      abilityScore: _draft.abilityScores.strength,
      proficient: _draft.savingThrows.isStrProf,
      proficiencyBonus: 2,
    );

    widget.onSubmit?.call(_draft.toCreature());
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.creature;

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Form(
        key: _formKey,
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
                child: ElevatedButton(onPressed: _submit, child: Text('Save')),
              ),
              StatblockSection(
                child: TextFormField(
                  style: Theme.of(context).textTheme.titleLarge,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name",
                    labelStyle: Theme.of(context).textTheme.titleMedium,
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Name is required'
                      : null,
                  onSaved: (value) => _draft.name = value!,
                ),
              ),
              StatblockSection(
                child: Row(
                  children: [
                    Expanded(
                      child: StatblockEditSmallText(
                        labelText: "Size",
                        startingValue: c?.size,
                        onSaved: (value) => _draft.size = value,
                      ),
                    ),
                    Expanded(
                      child: StatblockEditSmallText(
                        labelText: "Type",
                        startingValue: c?.type,
                        onSaved: (value) => _draft.type = value,
                      ),
                    ),
                    Expanded(
                      child: StatblockEditSmallText(
                        labelText: "Alignment",
                        startingValue: c?.alignment,
                        onSaved: (value) => _draft.alignment = value,
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
                            required: true,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onSaved: (value) =>
                                _draft.armorClass.ac = int.tryParse(value),
                          ),
                        ),
                        Expanded(
                          child: StatblockEditSmallText(
                            labelText: "Armor Type",
                            startingValue: c?.armorClass.type,
                            onSaved: (value) => _draft.armorClass.type = value,
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
                            required: true,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onSaved: (value) =>
                                _draft.hitPoints = int.tryParse(value) ?? 0,
                          ),
                        ),
                        Expanded(
                          child: StatblockEditSmallText(
                            labelText: "Formula (eg: 8d6 + 5)",
                            startingValue: c?.hitPointFormula,
                            onSaved: (value) => _draft.hitPointFormula = value,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: StatblockEditSmallText(
                            labelText: "Walk Speed (ft)",
                            startingValue: c?.speed.walk?.toString(),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onSaved: (value) =>
                                _draft.speed.walk = int.tryParse(value),
                          ),
                        ),
                        Expanded(
                          child: StatblockEditSmallText(
                            labelText: "Fly Speed (ft)",
                            startingValue: c?.speed.fly?.toString(),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onSaved: (value) =>
                                _draft.speed.fly = int.tryParse(value),
                          ),
                        ),
                        Expanded(
                          child: StatblockEditSmallText(
                            labelText: "Climb Speed (ft)",
                            startingValue: c?.speed.climb?.toString(),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onSaved: (value) =>
                                _draft.speed.climb = int.tryParse(value),
                          ),
                        ),
                        Expanded(
                          child: StatblockEditSmallText(
                            labelText: "Swim Speed (ft)",
                            startingValue: c?.speed.swim?.toString(),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onSaved: (value) =>
                                _draft.speed.swim = int.tryParse(value),
                          ),
                        ),
                        Expanded(
                          child: StatblockEditSmallText(
                            labelText: "Burrow Speed (ft)",
                            startingValue: c?.speed.burrow?.toString(),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onSaved: (value) =>
                                _draft.speed.burrow = int.tryParse(value),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // ---------- RESPONSIVE SECTION (Wrap) ----------
              StatblockSection(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    const double gap = AppSpacing.spacingMedium;

                    // Width left over after three fixed columns and their gaps.
                    final double remaining =
                        constraints.maxWidth - (columnWidth * 3) - (gap * 3);

                    // If the senses block fits on the same line, let it fill
                    // the rest. Otherwise it wraps and gets a normal column
                    // width (never wider than the available space).
                    final double maxAvailable =
                        constraints.maxWidth < columnWidth
                        ? constraints.maxWidth
                        : columnWidth;
                    final double sensesWidth = remaining >= columnWidth
                        ? remaining
                        : maxAvailable;

                    return Wrap(
                      spacing: gap,
                      runSpacing: gap,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        // ----- Column 1: ability scores + saving throws -----
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
                                    onSaved: (value) =>
                                        _draft.abilityScores.strength =
                                            int.tryParse(value) ?? 0,
                                  ),
                                  SizedBox(
                                    width: smallBoxWidth,
                                    child: StatblockCheckbox(
                                      initialValue:
                                          c?.savingThrows.isStrProf ??
                                          isStrChecked,
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
                                    onSaved: (value) =>
                                        _draft.abilityScores.dexterity =
                                            int.tryParse(value) ?? 0,
                                  ),
                                  SizedBox(
                                    width: smallBoxWidth,
                                    child: StatblockCheckbox(
                                      initialValue:
                                          c?.savingThrows.isDexProf ??
                                          isDexChecked,
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
                                    onSaved: (value) =>
                                        _draft.abilityScores.constitution =
                                            int.tryParse(value) ?? 0,
                                  ),
                                  SizedBox(
                                    width: smallBoxWidth,
                                    child: StatblockCheckbox(
                                      initialValue:
                                          c?.savingThrows.isConProf ??
                                          isConChecked,
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
                                    onSaved: (value) =>
                                        _draft.abilityScores.intelligence =
                                            int.tryParse(value) ?? 0,
                                  ),
                                  SizedBox(
                                    width: smallBoxWidth,
                                    child: StatblockCheckbox(
                                      initialValue:
                                          c?.savingThrows.isIntProf ??
                                          isIntChecked,
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
                                    onSaved: (value) =>
                                        _draft.abilityScores.wisdom =
                                            int.tryParse(value) ?? 0,
                                  ),
                                  SizedBox(
                                    width: smallBoxWidth,
                                    child: StatblockCheckbox(
                                      initialValue:
                                          c?.savingThrows.isWisProf ??
                                          isWisChecked,
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
                                    onSaved: (value) =>
                                        _draft.abilityScores.charisma =
                                            int.tryParse(value) ?? 0,
                                  ),
                                  SizedBox(
                                    width: smallBoxWidth,
                                    child: StatblockCheckbox(
                                      initialValue:
                                          c?.savingThrows.isChaProf ??
                                          isChaChecked,
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
                        if (remaining >= columnWidth) StatblockVerticalDivider(height: checkBoxTableHeight),
                        // ----- Column 2: skills (first half) -----
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
                                initalValue:
                                    c?.skills?.isAcrobaticsProf ?? isAcrobatics,
                                width: smallBoxWidth,
                                onChanged: (value) => setState(() {
                                  isAcrobatics = value;
                                }),
                              ),
                              StatblockCheckboxRow(
                                label: 'Animal Handling',
                                initalValue:
                                    c?.skills?.isAnimalHandlingProf ??
                                    isAnimalHandling,
                                width: smallBoxWidth,
                                onChanged: (value) => setState(() {
                                  isAnimalHandling = value;
                                }),
                              ),
                              StatblockCheckboxRow(
                                label: 'Arcana',
                                initalValue:
                                    c?.skills?.isArcanaProf ?? isArcana,
                                width: smallBoxWidth,
                                onChanged: (value) => setState(() {
                                  isArcana = value;
                                }),
                              ),
                              StatblockCheckboxRow(
                                label: 'Athletics',
                                initalValue:
                                    c?.skills?.isAthleticsProf ?? isAthletics,
                                width: smallBoxWidth,
                                onChanged: (value) => setState(() {
                                  isAthletics = value;
                                }),
                              ),
                              StatblockCheckboxRow(
                                label: 'Deception',
                                initalValue:
                                    c?.skills?.isDeceptionProf ?? isDeception,
                                width: smallBoxWidth,
                                onChanged: (value) => setState(() {
                                  isDeception = value;
                                }),
                              ),
                              StatblockCheckboxRow(
                                label: 'History',
                                initalValue:
                                    c?.skills?.isHistoryProf ?? isHistory,
                                width: smallBoxWidth,
                                onChanged: (value) => setState(() {
                                  isHistory = value;
                                }),
                              ),
                              StatblockCheckboxRow(
                                label: 'Insight',
                                initalValue:
                                    c?.skills?.isInsightProf ?? isInsight,
                                width: smallBoxWidth,
                                onChanged: (value) => setState(() {
                                  isInsight = value;
                                }),
                              ),
                              StatblockCheckboxRow(
                                label: 'Intimidation',
                                initalValue:
                                    c?.skills?.isIntimidationProf ??
                                    isIntimidation,
                                width: smallBoxWidth,
                                onChanged: (value) => setState(() {
                                  isIntimidation = value;
                                }),
                              ),
                              StatblockCheckboxRow(
                                label: 'Investigation',
                                initalValue:
                                    c?.skills?.isInvestigationProf ??
                                    isInvestigation,
                                width: smallBoxWidth,
                                onChanged: (value) => setState(() {
                                  isInvestigation = value;
                                }),
                              ),
                            ],
                          ),
                        ),
                        if (remaining >= columnWidth)
                          StatblockVerticalDivider(height: checkBoxTableHeight),
                        // ----- Column 3: skills (second half) -----
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
                                initalValue:
                                    c?.skills?.isMedicineProf ?? isMedicine,
                                width: smallBoxWidth,
                                onChanged: (value) => setState(() {
                                  isMedicine = value;
                                }),
                              ),
                              StatblockCheckboxRow(
                                label: 'Nature',
                                initalValue:
                                    c?.skills?.isNatureProf ?? isNature,
                                width: smallBoxWidth,
                                onChanged: (value) => setState(() {
                                  isNature = value;
                                }),
                              ),
                              StatblockCheckboxRow(
                                label: 'Perception',
                                initalValue:
                                    c?.skills?.isPerceptionProf ?? isPerception,
                                width: smallBoxWidth,
                                onChanged: (value) => setState(() {
                                  isPerception = value;
                                }),
                              ),
                              StatblockCheckboxRow(
                                label: 'Performance',
                                initalValue:
                                    c?.skills?.isPerformanceProf ??
                                    isPerformance,
                                width: smallBoxWidth,
                                onChanged: (value) => setState(() {
                                  isPerformance = value;
                                }),
                              ),
                              StatblockCheckboxRow(
                                label: 'Persuasion',
                                initalValue:
                                    c?.skills?.isPersuasionProf ?? isPersuasion,
                                width: smallBoxWidth,
                                onChanged: (value) => setState(() {
                                  isPersuasion = value;
                                }),
                              ),
                              StatblockCheckboxRow(
                                label: 'Religion',
                                initalValue:
                                    c?.skills?.isReligionProf ?? isReligion,
                                width: smallBoxWidth,
                                onChanged: (value) => setState(() {
                                  isReligion = value;
                                }),
                              ),
                              StatblockCheckboxRow(
                                label: 'Sleight of Hand',
                                initalValue:
                                    c?.skills?.isSleightOfHandProf ??
                                    isSleightHand,
                                width: smallBoxWidth,
                                onChanged: (value) => setState(() {
                                  isSleightHand = value;
                                }),
                              ),
                              StatblockCheckboxRow(
                                label: 'Stealth',
                                initalValue:
                                    c?.skills?.isStealthProf ?? isStealth,
                                width: smallBoxWidth,
                                onChanged: (value) => setState(() {
                                  isStealth = value;
                                }),
                              ),
                              StatblockCheckboxRow(
                                label: 'Survival',
                                initalValue:
                                    c?.skills?.isSurvivalProf ?? isSurvival,
                                width: smallBoxWidth,
                                onChanged: (value) => setState(() {
                                  isSurvival = value;
                                }),
                              ),
                            ],
                          ),
                        ),
                        if (remaining >= columnWidth)
                          StatblockVerticalDivider(height: checkBoxTableHeight),
                        // ----- Block 4: senses / languages / CR -----
                        SizedBox(
                          height: checkBoxTableHeight,
                          width: sensesWidth,
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
                                  startingValue: c?.challengeRating.cr
                                      .toString(),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  onSaved: (value) =>
                                      _draft.challengeRating.cr = value,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              // ---------- END RESPONSIVE SECTION ----------
              StatblockSection(
                child: SpellCastingTile(
                  creatureDraft: _draft,
                  creature: c,
                  onSaved: (value) => _draft.spellCasting!.name = value,
                ),
              ),
              StatblockSection(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsetsGeometry.symmetric(
                            horizontal: AppSpacing.spacingSmall,
                            vertical: AppSpacing.spacingSmall,
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(buttonWidth, buttonHeight),
                            ),
                            onPressed: _addTrait,
                            child: Text(
                              '+',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          child: Center(
                            child: Text(
                              'Traits',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ..._draft.traits!.asMap().entries.map((entry) {
                      final index = entry.key;
                      final trait = entry.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StatblockEditSmallText(
                            labelText: 'Name',
                            startingValue: trait.name,
                            onSaved: (value) =>
                                _draft.traits![index].name = value,
                          ),
                          StatblockEditSmallText(
                            labelText: 'Description',
                            startingValue: trait.description,
                            onSaved: (value) =>
                                _draft.traits![index].description = value,
                            maxLines: 4,
                          ),
                          const SizedBox(height: AppSpacing.spacingMedium),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              StatblockSection(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsetsGeometry.symmetric(
                            horizontal: AppSpacing.spacingSmall,
                            vertical: AppSpacing.spacingSmall,
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(buttonWidth, buttonHeight),
                            ),
                            onPressed: _addAction,
                            child: Text(
                              '+',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          child: Center(
                            child: Text(
                              'Actions',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ..._draft.actions!.asMap().entries.map((entry) {
                      final index = entry.key;
                      final action = entry.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StatblockEditSmallText(
                            labelText: 'Name',
                            startingValue: action.name,
                            onSaved: (value) =>
                                _draft.actions![index].name = value,
                          ),
                          DropdownMenu<ActionType>(
                            initialSelection: ActionType.action,
                            onSelected: (ActionType? value) {
                              setState(
                                () => _draft.actions![index].type = value,
                              );
                            },
                            textStyle: Theme.of(context).textTheme.titleSmall,
                            dropdownMenuEntries: ActionType.values
                                .map(
                                  (choice) => DropdownMenuEntry<ActionType>(
                                    value: choice,
                                    label: choice.label,
                                  ),
                                )
                                .toList(),
                          ),
                          StatblockEditSmallText(
                            labelText: 'Description',
                            startingValue: action.description,
                            onSaved: (value) =>
                                _draft.actions![index].description = value,
                            maxLines: 4,
                          ),
                          const SizedBox(height: AppSpacing.spacingMedium),
                        ],
                      );
                    }),
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
          validator: (value) =>
              required && (value == null || value.trim().isEmpty)
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

class SpellCastingTile extends StatefulWidget {
  const SpellCastingTile({
    super.key,
    required this.onSaved,
    required this.creatureDraft,
    this.creature,
  });
  final ValueChanged<String> onSaved;
  final Creature? creature;
  final CreatureDraft creatureDraft;

  @override
  State<SpellCastingTile> createState() => _SpellCastingTileState();
}

class _SpellCastingTileState extends State<SpellCastingTile> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      maintainState: true,
      title: Text(
        'Spellcasting',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      children: <Widget>[
        for (var level = 0; level <= 9; level++)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(
                  start: AppSpacing.spacingSmall,
                ),
                child: SizedBox(
                  width: 95,
                  child: StatblockSmallText(
                    data: spellLevelNames[level]!,
                    alignment: TextAlign.start,
                  ),
                ),
              ),
              Expanded(
                child: StatblockEditSmallText(
                  labelText: 'Spell Names (comma-separated)',
                  onSaved: (value) {
                    widget.creatureDraft.spellCasting!.spells![level]!.spells =
                        value
                            .split(',')
                            .map((spell) => spell.trim())
                            .where((spell) => spell.isNotEmpty)
                            .toList();
                  },
                  startingValue: widget
                      .creatureDraft
                      .spellCasting!
                      .spells![level]!
                      .spells
                      ?.join(', '),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

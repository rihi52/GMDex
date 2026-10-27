import 'package:flutter/material.dart';
import 'package:gmdex/models/creature.dart';
import 'package:gmdex/components/creature_calculations.dart';
import 'package:gmdex/theme/apptheme.dart';

class CreatureStatBlock extends StatelessWidget {
  final Creature? creature;
  final VoidCallback? onEditPressed;
  final VoidCallback? onCopyPressed;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onNotesPressed;

  const CreatureStatBlock({
    super.key,
    required this.creature,
    this.onEditPressed,
    this.onCopyPressed,
    this.onDeletePressed,
    this.onNotesPressed,
  });

  Widget _abilityScores(BuildContext context) {
    final a = creature!.abilityScores;
    final scores = <(String, int, int)>[
      ('STR', a.strength, a.strengthModifier),
      ('DEX', a.dexterity, a.dexterityModifier),
      ('CON', a.constitution, a.constitutionModifier),
      ('INT', a.intelligence, a.intelligenceModifier),
      ('WIS', a.wisdom, a.wisdomModifier),
      ('CHA', a.charisma, a.charismaModifier),
    ];

    Widget cell(String label, int score, int mod) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        StatblockSmallText(data: '$score (${mod >= 0 ? '+' : ''}$mod)'),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 500;

        if (!compact) {
          return Row(
            children: [
              for (var i = 0; i < scores.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.abilityBoxes),
                cell(scores[i].$1, scores[i].$2, scores[i].$3),
              ],
            ],
          );
        }

        // Narrow: ~10% smaller, small fixed gaps, and each cell can shrink
        // further if there still isn't enough room.
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(0.9)),
          child: Row(
            children: [
              for (var i = 0; i < scores.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.spacingLarge),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: cell(scores[i].$1, scores[i].$2, scores[i].$3),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double topButtonWidth = 110;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: topButtonWidth,
                  child: ElevatedButton(
                    onPressed: onEditPressed,
                    child: Text(
                      'Edit',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                SizedBox(
                  width: topButtonWidth,
                  child: ElevatedButton(
                    onPressed: onCopyPressed,
                    child: Text(
                      'Copy',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                SizedBox(
                  width: topButtonWidth,
                  child: ElevatedButton(
                    onPressed: onDeletePressed,
                    child: Text(
                      'Delete',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                if (onNotesPressed != null)
                  SizedBox(
                    width: topButtonWidth,
                    child: ElevatedButton(
                      onPressed: onNotesPressed,
                      child: Text(
                        'Notes',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
              ],
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
            StatblockSection(child: _abilityScores(context)),
            StatblockSection(
              child: Column(
                children: [
                  if (creature!.savingThrows.strength != null ||
                      creature!.savingThrows.dexterity != null ||
                      creature!.savingThrows.constitution != null ||
                      creature!.savingThrows.intelligence != null ||
                      creature!.savingThrows.wisdom != null ||
                      creature!.savingThrows.charisma != null)
                    Row(
                      children: [
                        Text(
                          'Saving Throws: ',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        StatblockSmallText(
                          data: [
                            if (creature!.savingThrows.strength != null)
                              'Str ${creature!.savingThrows.strength! >= 0 ? '+' : ''}${creature!.savingThrows.strength}',
                            if (creature!.savingThrows.dexterity != null)
                              'Dex ${creature!.savingThrows.dexterity! >= 0 ? '+' : ''}${creature!.savingThrows.dexterity}',
                            if (creature!.savingThrows.constitution != null)
                              'Con ${creature!.savingThrows.constitution! >= 0 ? '+' : ''}${creature!.savingThrows.constitution}',
                            if (creature!.savingThrows.intelligence != null)
                              'Int ${creature!.savingThrows.intelligence! >= 0 ? '+' : ''}${creature!.savingThrows.intelligence}',
                            if (creature!.savingThrows.wisdom != null)
                              'Wis ${creature!.savingThrows.wisdom! >= 0 ? '+' : ''}${creature!.savingThrows.wisdom}',
                            if (creature!.savingThrows.charisma != null)
                              'Cha ${creature!.savingThrows.charisma! >= 0 ? '+' : ''}${creature!.savingThrows.charisma}',
                          ].join(', '),
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
                            '   Prof Bonus: +${creature?.proficiencyBonus?.toInt() ?? proficiencyBonusCalc(tryParseFraction(creature!.challengeRating.cr) ?? 2)}',
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
                      // Each level is one Text.rich so the spell list wraps
                      // under the label when the screen is narrow.
                      ...creature!.spellCasting!.spells!.entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppSpacing.spacingSmall,
                          ),
                          child: Text.rich(
                            TextSpan(
                              style: Theme.of(context).textTheme.labelSmall,
                              children: [
                                TextSpan(
                                  // key is the spell level, reads from const.
                                  // Cantrips (0) are "at will", other levels show slots.
                                  text:
                                      '${spellLevelNames[entry.key] ?? "${entry.key}th level"}${entry.key == 0 ? ' (at will): ' : ' (${entry.value.slots} slots): '}',
                                ),
                                TextSpan(text: entry.value.spells.join(', ')),
                              ],
                            ),
                          ),
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

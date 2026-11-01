import 'package:flutter/material.dart';
import 'package:gmdex/models/creature.dart' show crToXp;
import 'package:gmdex/models/difficulty_calculator_ruleset.dart';
import 'package:gmdex/theme/apptheme.dart';

class DifficultyCalculator extends StatelessWidget {
  /// One entry per player character (their level, 1-20).
  final List<int> partyLevels;

  /// Base XP of each individual monster. Three goblins = [50, 50, 50].
  final List<int> monsterXp;

  /// One entry per monster. Null means its CR could not be read.
  final List<double?> monsterCr;
  final DifficultyCalculatorRuleset ruleset;

  const DifficultyCalculator({
    super.key,
    required this.partyLevels,
    required this.monsterXp,
    this.monsterCr = const [],
    this.ruleset = DifficultyCalculatorRuleset.dnd2014,
  });

  @override
  Widget build(BuildContext context) {
    if (ruleset == DifficultyCalculatorRuleset.fleeMortals) {
      return _buildFleeMortals(context);
    }

    final goals = _partyGoals(partyLevels);
    final xp = calculateEncounterXp(
      partyLevels: partyLevels,
      monsterXp: monsterXp,
    );
    final difficulty = _rateEncounter(goals, xp.adjustedXp);

    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _StatRow('Difficulty (2014 5e):', _label(difficulty)),
                  _StatRow('Total XP:', '${xp.totalXp}'),
                  _StatRow('Adjusted XP:', '${xp.adjustedXp}'),
                ],
              ),
            ),
          ),
          const VerticalDivider(
            color: AppColors.primary,
            width: 5,
            thickness: 1,
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('XP Goals'),
                  _StatRow('Easy:', '${goals.easy}'),
                  _StatRow('Medium:', '${goals.medium}'),
                  _StatRow('Hard:', '${goals.hard}'),
                  _StatRow('Deadly:', '${goals.deadly}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFleeMortals(BuildContext context) {
    final encounter = calculateFleeMortalsEncounter(
      partyLevels: partyLevels,
      monsterCr: monsterCr,
    );

    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  const Text('Flee, Mortals!'),
                  _StatRow('Difficulty:', encounter.difficulty),
                  _StatRow('Total CR:', _formatCr(encounter.totalCr)),
                ],
              ),
            ),
          ),
          const VerticalDivider(
            color: AppColors.primary,
            width: 5,
            thickness: 1,
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  const Text('CR Budget'),
                  _StatRow('Easy:', _formatCr(encounter.budgets.easy)),
                  _StatRow('Standard:', _formatCr(encounter.budgets.standard)),
                  _StatRow('Hard:', _formatCr(encounter.budgets.hard)),
                  _StatRow('One Creature Cap:', '${encounter.budgets.crCap}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Raw and encounter-adjusted XP for a party facing a set of monsters.
class EncounterXp {
  const EncounterXp({required this.totalXp, required this.adjustedXp});

  final int totalXp;
  final int adjustedXp;
}

/// Calculates encounter XP using the same monster-count multiplier as the UI.
EncounterXp calculateEncounterXp({
  required List<int> partyLevels,
  required List<int> monsterXp,
}) {
  final totalXp = monsterXp.fold<int>(0, (total, xp) => total + xp);
  return EncounterXp(
    totalXp: totalXp,
    adjustedXp: _adjustedXp(monsterXp, partyLevels.length),
  );
}

class EncounterCrBudgets {
  const EncounterCrBudgets({
    required this.easy,
    required this.standard,
    required this.hard,
    required this.crCap,
  });

  final double easy;
  final double standard;
  final double hard;
  final int crCap;
}

class FleeMortalsEncounter {
  const FleeMortalsEncounter({
    required this.totalCr,
    required this.budgets,
    required this.difficulty,
  });

  final double totalCr;
  final EncounterCrBudgets budgets;
  final String difficulty;
}

/// Estimates encounter difficulty directly from CR, without converting to XP.
///
/// Estimates encounter difficulty by summing the CR thresholds for each
/// character's level.
FleeMortalsEncounter calculateFleeMortalsEncounter({
  required List<int> partyLevels,
  required List<double?> monsterCr,
}) {
  final totalCr = monsterCr.fold<double>(0, (total, cr) => total + (cr ?? 0));
  final partyLevelSum = partyLevels.fold<int>(
    0,
    (total, level) => total + level.clamp(1, 20),
  );
  final averagePartyLevel = partyLevels.isNotEmpty
      ? (partyLevelSum / partyLevels.length).floor()
      : 1;
  var easyBudget = 0.0;
  var standardBudget = 0.0;
  var hardBudget = 0.0;
  for (final level in partyLevels) {
    final thresholds = crThresholdsByLevel[level.clamp(1, 20)]!;
    easyBudget += thresholds.easy;
    standardBudget += thresholds.standard;
    hardBudget += thresholds.hard;
  }

  final budgets = EncounterCrBudgets(
    easy: easyBudget,
    standard: standardBudget,
    hard: hardBudget,
    crCap: crThresholdsByLevel[averagePartyLevel]!.crCap,
  );

  final difficulty = switch (true) {
    _ when monsterCr.isEmpty => 'No monsters',
    _ when partyLevels.isEmpty => 'Add players',
    _ when monsterCr.any((cr) => cr == null) => 'CR unavailable',
    _ when totalCr <= budgets.easy => 'Easy',
    _ when totalCr <= budgets.standard => 'Standard',
    _ when totalCr <= budgets.hard => 'Hard',
    _ => 'Beyond Hard',
  };

  return FleeMortalsEncounter(
    totalCr: totalCr,
    budgets: budgets,
    difficulty: difficulty,
  );
}

class CrThresholds {
  final double easy;
  final double standard;
  final double hard;
  final int crCap;

  const CrThresholds(this.easy, this.standard, this.hard, this.crCap);
}

const Map<int, CrThresholds> crThresholdsByLevel = {
  1: CrThresholds(.125, .125, .25, 1),
  2: CrThresholds(.125, .25, .5, 3),
  3: CrThresholds(.25, .5, .75, 4),
  4: CrThresholds(.5, .75, 1, 6),
  5: CrThresholds(1, 1.5, 2.5, 8),
  6: CrThresholds(1.5, 2, 3, 9),
  7: CrThresholds(2, 2.5, 3.5, 10),
  8: CrThresholds(2.5, 3, 4, 12),
  9: CrThresholds(3, 3.5, 4.5, 13),
  10: CrThresholds(3.5, 4, 5, 15),
  11: CrThresholds(4, 4.5, 5.5, 16),
  12: CrThresholds(4.5, 5, 6, 17),
  13: CrThresholds(5, 5.5, 6.5, 19),
  14: CrThresholds(5.5, 6, 7, 20),
  15: CrThresholds(6, 6.5, 7.5, 22),
  16: CrThresholds(6.5, 7, 8, 24),
  17: CrThresholds(7, 7.5, 8.5, 25),
  18: CrThresholds(7.5, 8, 9, 26),
  19: CrThresholds(8, 8.5, 9.5, 28),
  20: CrThresholds(8.5, 9, 10, 30),
};

/// Resolves a creature's XP override or the XP associated with its CR.
int xpForChallengeRating(String? challengeRating, {int? xpOverride}) {
  if (xpOverride != null) return xpOverride;
  final xp = crToXp[challengeRating];
  return xp == null ? 0 : int.parse(xp.replaceAll(',', ''));
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  const _StatRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            // overflow: TextOverflow.clip,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }
}

// ---------- data ----------

enum Difficulty { trivial, easy, medium, hard, deadly }

class XpThresholds {
  final int easy;
  final int medium;
  final int hard;
  final int deadly;
  const XpThresholds(this.easy, this.medium, this.hard, this.deadly);
}

const Map<int, XpThresholds> xpThresholdsByLevel = {
  1: XpThresholds(25, 50, 75, 100),
  2: XpThresholds(50, 100, 150, 200),
  3: XpThresholds(75, 150, 225, 400),
  4: XpThresholds(125, 250, 375, 500),
  5: XpThresholds(250, 500, 750, 1100),
  6: XpThresholds(300, 600, 900, 1400),
  7: XpThresholds(350, 750, 1100, 1700),
  8: XpThresholds(450, 900, 1400, 2100),
  9: XpThresholds(550, 1100, 1600, 2400),
  10: XpThresholds(600, 1200, 1900, 2800),
  11: XpThresholds(800, 1600, 2400, 3600),
  12: XpThresholds(1000, 2000, 3000, 4500),
  13: XpThresholds(1100, 2200, 3400, 5100),
  14: XpThresholds(1250, 2500, 3800, 5700),
  15: XpThresholds(1400, 2800, 4300, 6400),
  16: XpThresholds(1600, 3200, 4800, 7200),
  17: XpThresholds(2000, 3900, 5900, 8800),
  18: XpThresholds(2100, 4200, 6300, 9500),
  19: XpThresholds(2400, 4900, 7300, 10900),
  20: XpThresholds(2800, 5700, 8500, 12700),
};

const List<double> _multipliers = [0.5, 1, 1.5, 2, 2.5, 3, 4, 5];

// ---------- math ----------

/// Sums each party member's thresholds. Levels are clamped to 1-20.
XpThresholds _partyGoals(List<int> partyLevels) {
  var easy = 0, medium = 0, hard = 0, deadly = 0;
  for (final level in partyLevels) {
    final t = xpThresholdsByLevel[level.clamp(1, 20)]!;
    easy += t.easy;
    medium += t.medium;
    hard += t.hard;
    deadly += t.deadly;
  }
  return XpThresholds(easy, medium, hard, deadly);
}

/// Monster-count multiplier, shifted one step for small or large parties.
double _encounterMultiplier(int monsterCount, int partySize) {
  var i = switch (monsterCount) {
    <= 1 => 1,
    2 => 2,
    <= 6 => 3,
    <= 10 => 4,
    <= 14 => 5,
    _ => 6,
  };
  if (partySize < 3) i += 1;
  if (partySize >= 6) i -= 1;
  return _multipliers[i.clamp(0, _multipliers.length - 1)];
}

int _adjustedXp(List<int> monsterXp, int partySize) {
  if (monsterXp.isEmpty) return 0;
  final raw = monsterXp.fold<int>(0, (a, b) => a + b);
  return (raw * _encounterMultiplier(monsterXp.length, partySize)).round();
}

Difficulty _rateEncounter(XpThresholds goals, int adjustedXp) {
  if (adjustedXp >= goals.deadly && goals.deadly > 0) return Difficulty.deadly;
  if (adjustedXp >= goals.hard && goals.hard > 0) return Difficulty.hard;
  if (adjustedXp >= goals.medium && goals.medium > 0) return Difficulty.medium;
  if (adjustedXp >= goals.easy && goals.easy > 0) return Difficulty.easy;
  return Difficulty.trivial;
}

String _label(Difficulty d) => d.name[0].toUpperCase() + d.name.substring(1);

String _formatCr(double cr) {
  if (cr == cr.roundToDouble()) return cr.toStringAsFixed(0);
  return cr
      .toStringAsFixed(2)
      .replaceFirst(RegExp(r'0+$'), '')
      .replaceFirst(RegExp(r'\.$'), '');
}

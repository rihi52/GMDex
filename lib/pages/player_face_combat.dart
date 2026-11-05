import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gmdex/components/responsive_layout.dart';
import 'package:gmdex/models/combat.dart';
import 'package:gmdex/my_flutter_app_icons.dart';
import 'package:gmdex/theme/apptheme.dart';

/// One combatant row shown in the player-facing initiative window.
class PlayerViewRow {
  const PlayerViewRow({
    required this.name,
    required this.initiative,
    required this.isActive,
    this.isCreature = false,
    this.currentHitPoints = 0,
    this.maxHitPoints = 0,
    this.conditions = const [],
  });

  final String name;
  final int? initiative;
  final bool isActive;
  final bool isCreature;
  final int currentHitPoints;
  final int maxHitPoints;
  final List<String> conditions;

  factory PlayerViewRow.fromCombatant(
    Combatant combatant, {
    String maskedName = 'Enemy',
  }) {
    final conditions = <String>[
      if (combatant.isBlinded) 'Blinded',
      if (combatant.isCharmed) 'Charmed',
      if (combatant.isDeafened) 'Deafened',
      if (combatant.exhaustionLevel > 0)
        'Exhaustion ${combatant.exhaustionLevel}',
      if (combatant.isFrightened) 'Frightened',
      if (combatant.isGrappled) 'Grappled',
      if (combatant.isIncapacitated) 'Incapacitated',
      if (combatant.isInvisible) 'Invisible',
      if (combatant.isParalyzed) 'Paralyzed',
      if (combatant.isPetrified) 'Petrified',
      if (combatant.isPoisoned) 'Poisoned',
      if (combatant.isProne) 'Prone',
      if (combatant.isRestrained) 'Restrained',
      if (combatant.isStunned) 'Stunned',
      if (combatant.isUnconscious) 'Unconscious',
    ];
    return PlayerViewRow(
      name: combatant.isPlayer || combatant.isUnmasked
          ? combatant.name
          : maskedName,
      initiative: combatant.initiative,
      isActive: combatant.isTurn,
      isCreature: !combatant.isPlayer,
      currentHitPoints: combatant.currentHitPoints ?? combatant.maxHitPoints,
      maxHitPoints: combatant.maxHitPoints,
      conditions: List.unmodifiable(conditions),
    );
  }
}

final ValueNotifier<List<PlayerViewRow>> _rows = ValueNotifier(const []);

void updatePlayerFacingCombat(List<PlayerViewRow> rows) {
  _rows.value = List.unmodifiable(rows);
}

class PlayerFacingCombatPage extends StatefulWidget {
  const PlayerFacingCombatPage({super.key});

  @override
  State<PlayerFacingCombatPage> createState() => _PlayerFacingCombatPageState();
}

class _PlayerFacingCombatPageState extends State<PlayerFacingCombatPage> {
  final _scrollController = ScrollController();
  final _activeRowKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _rows.addListener(_scheduleActiveRowScroll);
    _scheduleActiveRowScroll();
  }

  @override
  void dispose() {
    _rows.removeListener(_scheduleActiveRowScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _scheduleActiveRowScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final activeRowContext = _activeRowKey.currentContext;
      if (activeRowContext == null) return;
      unawaited(
        Scrollable.ensureVisible(
          activeRowContext,
          alignment: 0.5,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        bottom: ResponsiveLayout.isNarrow(
          MediaQuery.sizeOf(context).width,
          breakpoint: ResponsiveBreakpoints.navigation,
        ),
        child: ValueListenableBuilder<List<PlayerViewRow>>(
          valueListenable: _rows,
          builder: (context, rows, _) {
            if (rows.isEmpty) {
              return Center(
                child: Text(
                  'Waiting for combat to start...',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              );
            }
            return SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppSpacing.spacingLarge),
              child: Column(
                children: [
                  for (final row in rows)
                    _PlayerViewTile(
                      key: row.isActive ? _activeRowKey : null,
                      row: row,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PlayerViewTile extends StatelessWidget {
  const _PlayerViewTile({super.key, required this.row});

  final PlayerViewRow row;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleLarge;
    final conditions = [
      for (final condition in row.conditions)
        Chip(
          label: Text(condition),
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 480;
        final backgroundColor = row.isCreature
            ? AppColors.creatureCard
            : AppColors.playerCard;
        return Container(
          margin: const EdgeInsets.symmetric(vertical: AppSpacing.spacingSmall),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: row.isActive
                      ? Color.alphaBlend(
                          Colors.white.withValues(alpha: 0.3),
                          backgroundColor,
                        )
                      : backgroundColor,
                  borderRadius: BorderRadius.circular(
                    AppSpacing.cornerRadiusMedium,
                  ),
                  border: Border.all(
                    color: row.isActive
                        ? AppColors.cardHighlight
                        : Colors.transparent,
                    width: 4,
                  ),
                ),
                child: compact
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 64,
                                child: Text(
                                  row.initiative?.toString() ?? '-',
                                  style: style,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  row.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: style,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: AppSpacing.spacingSmall,
                            ),
                            child: Wrap(
                              spacing: AppSpacing.spacingSmall,
                              runSpacing: AppSpacing.spacingSmall,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: conditions,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          SizedBox(
                            width: 64,
                            child: Text(
                              row.initiative?.toString() ?? '-',
                              style: style,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(row.name, style: style),
                                    const SizedBox(width: 50),
                                    if (row.currentHitPoints <= 0)
                                      Transform.scale(
                                        scale: 2,
                                        child: Icon(MyFlutterApp.death),
                                      ),
                                  ],
                                ),
                                if (conditions.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: AppSpacing.spacingSmall,
                                    ),
                                    child: Wrap(
                                      spacing: AppSpacing.spacingSmall,
                                      runSpacing: AppSpacing.spacingSmall,
                                      children: conditions,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.spacingSmall),
                        ],
                      ),
              ),
              // if (row.currentHitPoints <= 0)
              //   Positioned.fill(
              //     child: IgnorePointer(
              //       child: Center(child: Container(height: 5, color: Colors.red)),
              //     ),
              //   ),
            ],
          ),
        );
      },
    );
  }
}

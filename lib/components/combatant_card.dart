// Combatant cards and condition controls shared by encounter building and play.
//
// Builder cards edit participant quantities/initiative; runtime cards also
// support hit-point expressions and communicate initiative changes upward.
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:gmdex/theme/apptheme.dart';
import 'package:gmdex/models/combat.dart';
import 'package:gmdex/models/turn_highlight_preference.dart';
import 'package:gmdex/components/status_button.dart';

/// Participant controls shown while assembling an encounter.
class BuildCombatantCard extends StatelessWidget {
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback onDelete;
  final ValueChanged<int>? onQuantityChanged;

  final Combatant combatant;

  const BuildCombatantCard({
    super.key,
    required this.combatant,
    this.selected = false,
    this.onTap,
    required this.onDelete,
    this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacingSmall),
      child: ListTile(
        selected: selected,
        onTap: onTap,
        tileColor: AppColors.cardBackground,
        selectedTileColor: AppColors.cardSelected,
        selectedColor: AppColors.accent,
        subtitle: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: AppSpacing.spacingMedium,
                  ),
                  child: ElevatedButton(
                    onPressed: onDelete,
                    style: ElevatedButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.bodySmall,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.spacingSmall,
                      ),
                      minimumSize: Size(60, 40),
                    ),
                    // icon: const Icon(Icons.remove),
                    child: const Icon(Icons.delete),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.only(
                    left: AppSpacing.spacingMedium,
                  ),
                  child: SizedBox(
                    width: 75,
                    child: TextFormField(
                      maxLines: 1,
                      initialValue: combatant.initiative.toString(),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: Theme.of(context).textTheme.labelSmall,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Init',
                        labelStyle: Theme.of(context).textTheme.labelSmall,
                      ),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? 'Initiative is required'
                          : null,
                      onSaved: (value) =>
                          combatant.initiative = int.tryParse(value!) ?? 0,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: AppSpacing.spacingMedium,
                    ),
                    child: Text(
                      combatant.name,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.only(
                    right: AppSpacing.spacingMedium,
                  ),
                  child: SizedBox(
                    width: 75,
                    child: TextFormField(
                      maxLines: 1,
                      initialValue: combatant.quantity.toString(),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: Theme.of(context).textTheme.labelSmall,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Quantity',
                        labelStyle: Theme.of(context).textTheme.labelSmall,
                      ),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? 'Quantity is required'
                          : null,
                      onChanged: (value) {
                        final quantity = int.tryParse(value) ?? 0;
                        combatant.quantity = quantity;
                        onQuantityChanged?.call(quantity);
                      },
                      onSaved: (value) =>
                          combatant.quantity = int.tryParse(value!) ?? 0,
                    ),
                  ),
                ),
              ],
            ),
            _CombatantStatusSection(combatant: combatant),
          ],
        ),
      ),
    );
  }
}

const statuses = {
  'Blinded',
  'Charmed',
  'Deafened',
  'Frightened',
  'Grappled',
  'Incapacitated',
  'Invisible',
  'Paralyzed',
  'Petrified',
  'Poisoned',
  'Prone',
  'Restrained',
  'Stunned',
  'Unconscious',
};

Widget _combatantStatuses(Combatant combatant, {VoidCallback? onChanged}) {
  void update(VoidCallback change) {
    change();
    onChanged?.call();
  }

  // Bind each condition button directly to the combatant's mutable state.
  StatusButton status({
    required String label,
    required bool selected,
    required ValueChanged<bool> onChanged,
  }) {
    return StatusButton(
      label: statuses.lookup(label) ?? label,
      initiallySelected: selected,
      onChanged: onChanged,
      fillColor: AppColors.primary,
      height: 20,
    );
  }

  return Wrap(
    runSpacing: AppSpacing.spacingSmall,
    spacing: AppSpacing.spacingSmall,
    children: [
      status(
        label: 'Blinded',
        selected: combatant.isBlinded,
        onChanged: (value) => update(() => combatant.isBlinded = value),
      ),
      status(
        label: 'Charmed',
        selected: combatant.isCharmed,
        onChanged: (value) => update(() => combatant.isCharmed = value),
      ),
      status(
        label: 'Deafened',
        selected: combatant.isDeafened,
        onChanged: (value) => update(() => combatant.isDeafened = value),
      ),
      CountFillButton(
        label: 'Exhaustion',
        tooltip: 'Exhaustion',
        layers: 6,
        initialCount: combatant.exhaustionLevel,
        fillColor: AppColors.primary,
        height: 20,
        onChanged: (value) => update(() => combatant.exhaustionLevel = value),
      ),
      status(
        label: 'Frightened',
        selected: combatant.isFrightened,
        onChanged: (value) => update(() => combatant.isFrightened = value),
      ),
      status(
        label: 'Grappled',
        selected: combatant.isGrappled,
        onChanged: (value) => update(() => combatant.isGrappled = value),
      ),
      status(
        label: 'Incapacitated',
        selected: combatant.isIncapacitated,
        onChanged: (value) => update(() => combatant.isIncapacitated = value),
      ),
      status(
        label: 'Invisible',
        selected: combatant.isInvisible,
        onChanged: (value) => update(() => combatant.isInvisible = value),
      ),
      status(
        label: 'Paralyzed',
        selected: combatant.isParalyzed,
        onChanged: (value) => update(() => combatant.isParalyzed = value),
      ),
      status(
        label: 'Petrified',
        selected: combatant.isPetrified,
        onChanged: (value) => update(() => combatant.isPetrified = value),
      ),
      status(
        label: 'Poisoned',
        selected: combatant.isPoisoned,
        onChanged: (value) => update(() => combatant.isPoisoned = value),
      ),
      status(
        label: 'Prone',
        selected: combatant.isProne,
        onChanged: (value) => update(() => combatant.isProne = value),
      ),
      status(
        label: 'Restrained',
        selected: combatant.isRestrained,
        onChanged: (value) => update(() => combatant.isRestrained = value),
      ),
      status(
        label: 'Stunned',
        selected: combatant.isStunned,
        onChanged: (value) => update(() => combatant.isStunned = value),
      ),
      status(
        label: 'Unconscious',
        selected: combatant.isUnconscious,
        onChanged: (value) => update(() => combatant.isUnconscious = value),
      ),
    ],
  );
}

/// Collapsible list of conditions for one combatant.
class _CombatantStatusSection extends StatefulWidget {
  const _CombatantStatusSection({required this.combatant});

  final Combatant combatant;

  @override
  State<_CombatantStatusSection> createState() =>
      _CombatantStatusSectionState();
}

class _CombatantStatusSectionState extends State<_CombatantStatusSection> {
  bool get _hasActiveConditions {
    final combatant = widget.combatant;
    return combatant.exhaustionLevel > 0 ||
        combatant.isBlinded ||
        combatant.isCharmed ||
        combatant.isDeafened ||
        combatant.isFrightened ||
        combatant.isGrappled ||
        combatant.isIncapacitated ||
        combatant.isInvisible ||
        combatant.isParalyzed ||
        combatant.isPetrified ||
        combatant.isPoisoned ||
        combatant.isProne ||
        combatant.isRestrained ||
        combatant.isStunned ||
        combatant.isUnconscious;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      maintainState: true,
      dense: true,
      tilePadding: EdgeInsets.zero,
      visualDensity: const VisualDensity(vertical: -4),
      minTileHeight: 32,
      childrenPadding: const EdgeInsets.only(bottom: AppSpacing.spacingSmall),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Conditions', style: Theme.of(context).textTheme.bodySmall),
          if (_hasActiveConditions) ...[
            const SizedBox(width: AppSpacing.spacingSmall),
            const Tooltip(
              message: 'Active conditions',
              child: Icon(
                Icons.circle,
                size: 8,
                color: AppColors.primary,
                semanticLabel: 'Active conditions',
              ),
            ),
          ],
        ],
      ),
      children: [
        _combatantStatuses(widget.combatant, onChanged: () => setState(() {})),
      ],
    );
  }
}

/// Runtime participant row with hit-point and initiative editing.
class RunCombatantCard extends StatefulWidget {
  final bool selected;
  final bool isActiveTurn;
  final VoidCallback? onTap;
  final VoidCallback onDelete;
  final ValueChanged<int?> onInitiativeChanged;

  final Combatant combatant;

  const RunCombatantCard({
    super.key,
    required this.combatant,
    this.selected = false,
    this.isActiveTurn = false,
    this.onTap,
    required this.onDelete,
    required this.onInitiativeChanged,
  });

  @override
  State<RunCombatantCard> createState() => _RunCombatantCardState();
}

class _RunCombatantCardState extends State<RunCombatantCard> {
  final _hitPointsFieldKey = GlobalKey<FormFieldState<String>>();
  late final TextEditingController _hitPointsController;

  @override
  void initState() {
    super.initState();
    _hitPointsController = TextEditingController(
      text: (widget.combatant.currentHitPoints ?? widget.combatant.maxHitPoints)
          .toString(),
    );
  }

  @override
  void dispose() {
    _hitPointsController.dispose();
    super.dispose();
  }

  void _normalizeHitPoints() {
    // Resolve a valid expression to one integer before storing it in combat.
    final value = _evaluateHitPointExpression(_hitPointsController.text);
    if (value == null) {
      _hitPointsFieldKey.currentState?.validate();
      return;
    }

    widget.combatant.currentHitPoints = value;
    _hitPointsController.value = TextEditingValue(
      text: value.toString(),
      selection: TextSelection.collapsed(offset: value.toString().length),
    );
    _hitPointsFieldKey.currentState?.validate();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: turnHighlightEnabled,
      builder: (context, highlightEnabled, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.spacingMedium,
            vertical: AppSpacing.spacingSmall,
          ),
          selected: widget.selected,
          onTap: widget.onTap,
          visualDensity: const VisualDensity(vertical: -1),
          minVerticalPadding: 0,
          tileColor: AppColors.cardBackground,
          selectedTileColor: AppColors.cardSelected,
          selectedColor: AppColors.accent,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: highlightEnabled && widget.isActiveTurn
                  ? Colors.red
                  : Colors.transparent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          subtitle: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: widget.onDelete,
                    style: ElevatedButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.bodySmall,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.spacingSmall,
                      ),
                      minimumSize: Size(46, 36),
                    ),
                    // icon: const Icon(Icons.remove),
                    child: const Icon(Icons.delete),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: AppSpacing.spacingSmall,
                    ),
                    child: SizedBox(
                      height: 44,
                      width: 72,
                      child: TextFormField(
                        maxLines: 1,
                        initialValue: widget.combatant.initiative.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: Theme.of(context).textTheme.labelSmall,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixText: 'Init ',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.spacingSmall,
                            vertical: AppSpacing.spacingMedium,
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Initiative is required'
                            : null,
                        onSaved: (value) => widget.combatant.initiative =
                            int.tryParse(value!) ?? 0,
                        onChanged: (value) =>
                            widget.onInitiativeChanged(int.tryParse(value)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.spacingMedium,
                      ),
                      child: Text(
                        widget.combatant.name,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: AppSpacing.spacingMedium,
                    ),
                    child: SizedBox(
                      height: 44,
                      width: 75,
                      child: TextFormField(
                        key: _hitPointsFieldKey,
                        controller: _hitPointsController,
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9+\-\s]'),
                          ),
                        ],
                        style: Theme.of(context).textTheme.labelSmall,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixText: 'HP ',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 10,
                          ),
                        ),
                        validator: (value) =>
                            _evaluateHitPointExpression(value) == null
                            ? 'Enter a valid HP calculation'
                            : null,
                        onFieldSubmitted: (_) => _normalizeHitPoints(),
                        onSaved: (value) {
                          final hitPoints = _evaluateHitPointExpression(value);
                          if (hitPoints != null) {
                            widget.combatant.currentHitPoints = hitPoints;
                            _hitPointsController.text = hitPoints.toString();
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 35,
                    child: Text(widget.combatant.maxHitPoints.toString()),
                  ),
                ],
              ),

              _CombatantStatusSection(combatant: widget.combatant),
            ],
          ),
        ),
      ),
    );
  }
}

int? _evaluateHitPointExpression(String? input) {
  // Parse only signed integer terms joined by + or -; no code evaluation is used.
  final expression = input?.replaceAll(RegExp(r'\s+'), '') ?? '';
  if (expression.isEmpty) return null;

  var index = 0;
  var sign = 1;
  if (expression[index] == '+' || expression[index] == '-') {
    if (expression[index] == '-') sign = -1;
    index++;
  }

  final firstNumberStart = index;
  while (index < expression.length && _isDigit(expression.codeUnitAt(index))) {
    index++;
  }
  if (firstNumberStart == index) return null;
  var total = sign * int.parse(expression.substring(firstNumberStart, index));

  while (index < expression.length) {
    final operator = expression[index];
    if (operator != '+' && operator != '-') return null;
    index++;

    final numberStart = index;
    while (index < expression.length &&
        _isDigit(expression.codeUnitAt(index))) {
      index++;
    }
    if (numberStart == index) return null;

    final operand = int.parse(expression.substring(numberStart, index));
    total += operator == '+' ? operand : -operand;
  }
  return total;
}

bool _isDigit(int character) => character >= 48 && character <= 57;

class PlayerFacingCombatantCard extends StatelessWidget {
  final bool selected;
  final bool isActiveTurn;
  final VoidCallback? onTap;
  final VoidCallback onDelete;
  final ValueChanged<int?> onInitiativeChanged;

  final Combatant combatant;

  const PlayerFacingCombatantCard({
    super.key,
    required this.combatant,
    this.selected = false,
    this.isActiveTurn = false,
    this.onTap,
    required this.onDelete,
    required this.onInitiativeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacingSmall),
      child: ListTile(
        selected: selected,
        onTap: onTap,
        tileColor: AppColors.cardBackground,
        selectedTileColor: AppColors.cardSelected,
        selectedColor: AppColors.accent,
        subtitle: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: AppSpacing.spacingMedium,
                  ),
                  child: ElevatedButton(
                    onPressed: onDelete,
                    style: ElevatedButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.bodySmall,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.spacingSmall,
                      ),
                      minimumSize: Size(60, 40),
                    ),
                    // icon: const Icon(Icons.remove),
                    child: const Icon(Icons.delete),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.only(
                    left: AppSpacing.spacingMedium,
                  ),
                  child: SizedBox(
                    width: 75,
                    child: TextField(
                      maxLines: 1,
                      readOnly: true,
                      controller: TextEditingController(
                        text: combatant.initiative.toString(),
                      ),
                      style: Theme.of(context).textTheme.labelSmall,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Inititiative',
                        labelStyle: Theme.of(context).textTheme.labelSmall,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: AppSpacing.spacingMedium,
                    ),
                    child: Text(
                      combatant.name,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.only(
                    right: AppSpacing.spacingMedium,
                  ),
                  child: SizedBox(width: 75),
                ),
              ],
            ),
            _CombatantStatusSection(combatant: combatant),
          ],
        ),
      ),
    );
  }
}

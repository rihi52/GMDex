// Summary card and detail panel used when browsing saved encounters.
//
// Encounter actions are injected by the page so this component remains
// independent of database writes and route management.
import 'package:flutter/material.dart';
import 'package:gmdex/models/combat.dart';
import 'package:gmdex/theme/apptheme.dart';

class EncounterCard extends StatelessWidget {
  /// Shows an encounter name, participant count, and selection state.
  const EncounterCard({
    super.key,
    required this.encounter,
    this.selected = false,
    this.onTap,
  });

  final SavedEncounter encounter;
  final bool selected;
  final VoidCallback? onTap;

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
        title: Text(
          encounter.name,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        subtitle: Text(
          '${encounter.combatantCount} combatants',
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ),
    );
  }
}

class EncounterDetails extends StatelessWidget {
  /// Shows encounter metadata and the actions available for that encounter.
  const EncounterDetails({
    super.key,
    required this.encounter,
    this.onStartPressed,
    this.onEditPressed,
    this.onCopyPressed,
    this.onDeletePressed,
    this.onNotesPressed,
  });

  final SavedEncounter encounter;
  final VoidCallback? onStartPressed;
  final VoidCallback? onEditPressed;
  final VoidCallback? onCopyPressed;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onNotesPressed;

  @override
  Widget build(BuildContext context) {
    const topButtonWidth = 110.0;

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardSelected,
          borderRadius: BorderRadius.circular(AppSpacing.cornerRadiusMedium),
        ),
        padding: const EdgeInsets.all(AppSpacing.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: AppSpacing.spacingMedium,
              runSpacing: AppSpacing.spacingMedium,
              children: [
                SizedBox(
                  width: topButtonWidth,
                  child: ElevatedButton(
                    onPressed: onStartPressed,
                    child: Text(
                      'Start',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                SizedBox(
                  width: topButtonWidth,
                  child: ElevatedButton(
                    onPressed: onEditPressed,
                    child: Text(
                      'Edit',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                SizedBox(
                  width: topButtonWidth,
                  child: ElevatedButton(
                    onPressed: onCopyPressed,
                    child: Text(
                      'Copy',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                SizedBox(
                  width: topButtonWidth,
                  child: ElevatedButton(
                    onPressed: onDeletePressed,
                    child: Text(
                      'Delete',
                      style: Theme.of(context).textTheme.bodyLarge,
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
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
              ],
            ),
            Text(encounter.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.spacingMedium),
            Text(
              'Players: ${encounter.playerCount}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'Creatures: ${encounter.creatureCount}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (encounter.notes.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.spacingMedium),
              Text('Notes', style: Theme.of(context).textTheme.titleSmall),
              Text(
                encounter.notes,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

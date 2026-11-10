// Read-only player details panel and drawer composition for player notes.
//
// Actions are callbacks supplied by the owning page, keeping persistence and
// navigation outside this presentation component.
import 'package:flutter/material.dart';
import 'package:gmdex/components/notes_drawer.dart';
import 'package:gmdex/database/database.dart';
import 'package:gmdex/theme/apptheme.dart';
import 'package:gmdex/components/dividers.dart';

class PlayerDetails extends StatelessWidget {
  /// Displays the selected player's fields and any available actions.
  const PlayerDetails({
    super.key,
    required this.player,
    this.onEditPressed,
    this.onCopyPressed,
    this.onDeletePressed,
    this.onNotesPressed,
  });

  final PlayerRow? player;
  final VoidCallback? onEditPressed;
  final VoidCallback? onCopyPressed;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onNotesPressed;

  @override
  Widget build(BuildContext context) {
    final selectedPlayer = player;
    final double topButtonWidth = 110;

    if (selectedPlayer == null) {
      return const Center(child: Text('Select a player to view details.'));
    }

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardSelected,
          borderRadius: BorderRadius.circular(AppSpacing.cornerRadiusMedium),
        ),
        padding: const EdgeInsets.all(AppSpacing.spacingSmall),
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
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      child: NotesLabel(
                        hasNotes:
                            selectedPlayer.pNotes?.trim().isNotEmpty == true,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
              ],
            ),
            Text(
              selectedPlayer.pName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.spacingMedium),
            _detail(context, 'Class:', selectedPlayer.pClass),
            HorizontalDivider(),
            _detail(context, 'Level:', selectedPlayer.pLevel?.toString()),
            HorizontalDivider(),
            _detail(
              context,
              'Hit Points:',
              selectedPlayer.pHitPoints?.toString(),
            ),
            HorizontalDivider(),
            _detail(
              context,
              'Armor Class:',
              selectedPlayer.pArmorClass?.toString(),
            ),
            HorizontalDivider(),
            _detail(
              context,
              'Passive Perception:',
              selectedPlayer.pPassivePerception?.toString(),
            ),
            HorizontalDivider(),
            _detail(
              context,
              'Original Campaign:',
              selectedPlayer.pOriginalCampaign,
            ),
            if (selectedPlayer.pNotes?.isNotEmpty == true) HorizontalDivider(),
            if (selectedPlayer.pNotes?.isNotEmpty == true)
              _detail(context, 'Notes:', selectedPlayer.pNotes),
          ],
        ),
      ),
    );
  }

  Widget _detail(BuildContext context, String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacingSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text(label, style: Theme.of(context).textTheme.titleSmall),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.labelSmall),
          ),
        ],
      ),
    );
  }
}

class PlayerNestedDrawer extends StatelessWidget {
  /// Pairs player details with the shared notes editor in a drawer.
  const PlayerNestedDrawer({
    super.key,
    required this.player,
    required this.onNotesSaved,
    this.onEditPressed,
    this.onCopyPressed,
    this.onDeletePressed,
    this.maxWidth,
  });

  final PlayerRow player;
  final Future<void> Function(PlayerRow, String) onNotesSaved;
  final VoidCallback? onEditPressed;
  final VoidCallback? onCopyPressed;
  final VoidCallback? onDeletePressed;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return NotesPageViewDrawer(
      maxWidth: maxWidth,
      detailsLabel: 'Details',
      details: Padding(
        padding: const EdgeInsets.all(AppSpacing.spacingMedium),
        child: PlayerDetails(
          player: player,
          onEditPressed: onEditPressed,
          onCopyPressed: onCopyPressed,
          onDeletePressed: onDeletePressed,
        ),
      ),
      initialValue: player.pNotes ?? '',
      onSaved: (value) => onNotesSaved(player, value),
    );
  }
}

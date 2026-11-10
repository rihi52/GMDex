// Read-only spell details panel matching the player details presentation.
import 'package:flutter/material.dart';
import 'package:gmdex/components/dividers.dart';
import 'package:gmdex/database/database.dart';
import 'package:gmdex/models/spell.dart';
import 'package:gmdex/theme/apptheme.dart';

class SpellDetails extends StatelessWidget {
  const SpellDetails({super.key, required this.spell, this.onNotesPressed});

  final SpellRow? spell;
  final VoidCallback? onNotesPressed;

  @override
  Widget build(BuildContext context) {
    final selectedSpell = spell;
    if (selectedSpell == null) {
      return const Center(child: Text('Select a spell to view details.'));
    }

    final details = Spell.fromRow(selectedSpell);
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
            if (onNotesPressed != null)
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 110,
                  child: ElevatedButton(
                    onPressed: onNotesPressed,
                    child: Text(
                      'Notes',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              ),
            Text(details.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.spacingMedium),
            _detail(context, 'Level:', details.level),
            const HorizontalDivider(),
            _detail(context, 'School:', details.school),
            const HorizontalDivider(),
            _detail(context, 'Source:', details.source),
            const HorizontalDivider(),
            _detail(context, 'Casting Time:', details.castingTime),
            const HorizontalDivider(),
            _detail(context, 'Range:', details.range),
            const HorizontalDivider(),
            _detail(context, 'Components:', details.components),
            const HorizontalDivider(),
            _detail(context, 'Duration:', details.duration),
            if (details.description.isNotEmpty) ...[
              const HorizontalDivider(),
              _section(context, 'Description', details.description),
            ],
            if (details.higherLevel case final higherLevel?) ...[
              const HorizontalDivider(),
              _section(context, 'At Higher Levels', higherLevel),
            ],
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

  Widget _section(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacingSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.spacingSmall),
          Text(value, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}

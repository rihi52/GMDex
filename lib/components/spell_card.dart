// Compact selectable spell row for spell browsing lists.
//
// The parent owns selection and navigation; this widget only presents the
// supplied spell fields and forwards an optional tap callback.
import 'package:flutter/material.dart';
import 'package:gmdex/models/spell.dart';
import 'package:gmdex/theme/apptheme.dart';

class SpellCard extends StatelessWidget {
  final bool selected;
  final VoidCallback? onTap;

  final String name;
  final int level;
  final String school;

  const SpellCard({
    super.key,
    required this.name,
    required this.level,
    required this.school,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        selected: selected,
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacingLarge,
          vertical: AppSpacing.spacingSmall,
        ),
        tileColor: AppColors.cardBackground,
        selectedTileColor: AppColors.cardSelected,
        selectedColor: AppColors.accent,
        subtitle: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  level == 0 ? 'Cantrip' : 'Level $level',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  spellSchoolName(school),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

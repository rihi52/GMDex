import 'package:flutter/material.dart';
import 'package:moonscribe/theme/apptheme.dart';
import 'package:moonscribe/models/combat.dart';

class CombatantCard extends StatelessWidget {
  final bool selected;
  final VoidCallback? onTap;

  final Combatant combatant;

  const CombatantCard({
    super.key,
    required this.combatant,
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
        tileColor: AppColors.cardBackground,
        selectedTileColor: AppColors.cardSelected,
        selectedColor: AppColors.accent,
        subtitle: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Initiative: ${combatant.initiative}', style: Theme.of(context).textTheme.bodySmall),
                Text(combatant.name, style: Theme.of(context).textTheme.bodySmall),                
                Text('HitPoints: ${combatant.quantity}', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
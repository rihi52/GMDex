import 'package:flutter/material.dart';
import 'package:moonscribe/theme/apptheme.dart';

class PlayerCard extends StatelessWidget {
  final bool selected;
  final VoidCallback? onTap;
  final String name;
  final String pClass;
  final int level;
  final String? originalCampaign;

  const PlayerCard({
    super.key,
    required this.name,
    required this.pClass,
    required this.level,
    this.originalCampaign,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(name, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(pClass, style: Theme.of(context).textTheme.bodySmall),
                Text('Level $level', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Origin: $originalCampaign', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
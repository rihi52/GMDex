import 'package:flutter/material.dart';
import 'package:moonscribe/theme/apptheme.dart';
class CreatureCard extends StatelessWidget {
  final bool selected;
  final VoidCallback? onTap;

  final String name;
  final String type;
  final String size;
  final String cr;
  final String source;

  const CreatureCard({
    super.key,
    required this.name,
    required this.type,
    required this.size,
    required this.cr,
    required this.source,
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
                Text(type, style: Theme.of(context).textTheme.bodySmall),
                Text(size, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('CR $cr', style: Theme.of(context).textTheme.bodySmall),
                Text(source, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
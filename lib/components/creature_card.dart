import 'package:flutter/material.dart';
import '../theme/apptheme.dart';

class CreatureCard extends StatelessWidget {
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
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.hoverGrey,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      width: 350,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(name, style: AppTheme.dark().textTheme.bodySmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(type, style: AppTheme.dark().textTheme.bodySmall),
                Text(size, style: AppTheme.dark().textTheme.bodySmall),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('CR: $cr', style: AppTheme.dark().textTheme.bodySmall),
                Text(source, style: AppTheme.dark().textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CreatureCards extends StatelessWidget {
  final bool selected;
  final VoidCallback? onTap;

  final String name;
  final String type;
  final String size;
  final String cr;
  final String source;

  const CreatureCards({
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
    return Padding( padding: const EdgeInsets.symmetric(vertical: 6),
      child:ListTile(
      selected: selected,
      onTap: onTap,
      tileColor: AppColors.cardBackground,
      selectedTileColor:  AppColors.cardSelected,
      selectedColor: AppColors.accent,
      subtitle: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(name, style: Theme.of(context).textTheme.bodySmall)
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(type, style: Theme.of(context).textTheme.bodySmall),
            Text(size, style: Theme.of(context).textTheme.bodySmall),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('CR $cr', style: Theme.of(context).textTheme.bodySmall),
            Text(source, style: Theme.of(context).textTheme.bodySmall),
          ]),
        ],
      ),
    ),
    );
  }
}

// ListTile(
//   selected: _selectedIndex == 1,
//   title: const Text('Create'),
//   shape: RoundedRectangleBorder(
//     borderRadius: BorderRadius.circular(8),
//     side: BorderSide(
//       color: _selectedIndex == 1
//           ? AppColors.hoverGrey
//           : Colors.transparent,
//       width: 1,
//     ),
//   ),
//   onTap: () => setState(() => _selectedIndex = 1),
// ),

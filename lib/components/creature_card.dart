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
    return ListTile(
      selected: selected,
      onTap: () {},
      title: Text(name, style: AppTheme.dark().textTheme.bodySmall),
      subtitle: Column(
        children: [
          Row(
            children: [
              Text(type),
              Text(size),
            ]
          ),
          Row(
            children: [
              Text('CR $cr'),
              Text(source),
            ]
          ),
        ],
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
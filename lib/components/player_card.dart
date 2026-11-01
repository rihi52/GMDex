// Compact selectable summary of a player character for browse lists.
//
// The parent owns selection and navigation; this widget only presents the
// supplied character fields and forwards an optional tap callback.
import 'package:flutter/material.dart';
import 'package:gmdex/theme/apptheme.dart';

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
      child: Wrap(
        children: [
          ListTile(
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
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      Text(
                        pClass,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        'Level $level',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Origin: ${originalCampaign ?? ''}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

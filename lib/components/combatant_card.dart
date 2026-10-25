import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:moonscribe/theme/apptheme.dart';
import 'package:moonscribe/models/combat.dart';

class CombatantCard extends StatelessWidget {
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback onDelete;


  final Combatant combatant;

  const CombatantCard({
    super.key,
    required this.combatant,
    this.selected = false,
    this.onTap,
    required this.onDelete,
  });

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
        subtitle: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: AppSpacing.spacingMedium),
                  child: ElevatedButton(
                    onPressed: onDelete,
                    style: ElevatedButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.bodySmall,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.spacingSmall,
                      ),
                      minimumSize: Size(60, 40),
                    ),
                    // icon: const Icon(Icons.remove),
                    child: const Icon(Icons.delete),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.only(
                    left: AppSpacing.spacingMedium,
                  ),
                  child: SizedBox(
                    width: 75,
                    child: TextFormField(
                      maxLines: 1,
                      initialValue: combatant.initiative.toString(),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: Theme.of(context).textTheme.labelSmall,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Initiative',
                        labelStyle: Theme.of(context).textTheme.titleSmall,
                      ),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? 'Initiative is required'
                          : null,
                      onSaved: (value) =>
                          combatant.initiative = int.tryParse(value!) ?? 0,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: AppSpacing.spacingMedium,
                    ),
                    child: Text(
                      combatant.name,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.only(
                    right: AppSpacing.spacingMedium,
                  ),
                  child: SizedBox(
                    width: 75,
                    child: TextFormField(
                      maxLines: 1,
                      initialValue: combatant.quantity.toString(),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: Theme.of(context).textTheme.labelSmall,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Quantity',
                        labelStyle: Theme.of(context).textTheme.titleSmall,
                      ),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? 'Quantity is required'
                          : null,
                      onSaved: (value) =>
                          combatant.quantity = int.tryParse(value!) ?? 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

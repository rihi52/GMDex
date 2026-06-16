import 'package:flutter/material.dart';
import 'package:moonscribe/theme/apptheme.dart';

class StartCombatPage extends StatefulWidget {
  const StartCombatPage({super.key});

  @override
  State<StartCombatPage> createState() => _StartCombatPageState();
}

class _StartCombatPageState extends State<StartCombatPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StartCombat'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              children: [ /* Cards for Combatants */
                Container(
                  padding: const EdgeInsets.only(
                bottom: AppSpacing.spacingSmall,
                top: AppSpacing.spacingSmall,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.primary, width: 1),
                ),
              ),
                )
              ],
            ),
            ),
          Expanded( /* Statblock */
            flex: 6,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                bottom: AppSpacing.spacingSmall,
                top: AppSpacing.spacingSmall,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.primary, width: 1),
                ),
              ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
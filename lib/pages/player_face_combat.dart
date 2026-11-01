import 'package:flutter/material.dart';
import 'package:gmdex/theme/apptheme.dart';

/// One row on the players' screen: only what players may see.
class PlayerViewRow {
  const PlayerViewRow({
    required this.name,
    required this.initiative,
    required this.isActive,
  });

  final String name;
  final int? initiative;
  final bool isActive;
}

final ValueNotifier<List<PlayerViewRow>> _rows = ValueNotifier(const []);

class PlayerFacingCombatPage extends StatefulWidget {
  const PlayerFacingCombatPage({super.key});

  @override
  State<PlayerFacingCombatPage> createState() => _PlayerFacingCombatPageState();
}

class _PlayerFacingCombatPageState extends State<PlayerFacingCombatPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<List<PlayerViewRow>>(
        valueListenable: _rows,
        builder: (context, rows, _) {
          if (rows.isEmpty) {
            return Center(
              child: Text(
                'Waiting for combat to start...',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.spacingLarge),
            itemCount: rows.length,
            itemBuilder: (context, index) => _PlayerViewTile(row: rows[index]),
          );
        },
      ),
    );
  }
}

class _PlayerViewTile extends StatelessWidget {
  const _PlayerViewTile({required this.row});

  final PlayerViewRow row;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.headlineMedium;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.spacingSmall),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: row.isActive ? AppColors.cardSelected : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.cornerRadiusMedium),
        border: Border.all(
          color: row.isActive ? AppColors.accent : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(row.initiative?.toString() ?? '-', style: style),
          ),
          Expanded(child: Text(row.name, style: style)),
        ],
      ),
    );
  }
}

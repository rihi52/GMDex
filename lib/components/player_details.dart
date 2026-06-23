import 'package:flutter/material.dart';

class PlayerDetails extends StatelessWidget {
  final PlayerDisplay? player;

  const PlayerDetails({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView();
  }
}

class PlayerDisplay {
  final String name;
  final String pClass;
  final int level;
  final String originalCampaign;

  final int id;

  const PlayerDisplay({
    required this.name,
    required this.pClass,
    required this.level,
    required this.originalCampaign,
    required this.id,
  });
}

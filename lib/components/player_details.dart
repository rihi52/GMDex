import 'package:flutter/material.dart';
import '../theme/apptheme.dart';

class PlayerDetails extends StatelessWidget {
  final Player? player;

  const PlayerDetails({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(

    );
  }
}

class Player {
  final String name;
  final String pClass;
  final int level;
  final String originalCampaign;

  final int id;

  const Player({
    required this.name,
    required this.pClass,
    required this.level,
    required this.originalCampaign,
    required this.id,
  });
}
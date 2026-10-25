

class Encounter {
  final String name;
  final List<Combatant> combatants;
  final int currentTurnIndex;

  const Encounter ({
    required this.name,
    required this.currentTurnIndex,
    required this.combatants,
  });
}

class Combatant {
  final String name;
  final bool isPlayer;
  final int maxHitPoints;
  final int currentHitPoints;
  int? initiative;
  final int? armorClass;
  int quantity;

  Combatant({
    required this.name,
    required this.isPlayer,
    required this.maxHitPoints,
    required this.currentHitPoints,
    required this.initiative,
    required this.quantity,
    this.armorClass,
  });
}
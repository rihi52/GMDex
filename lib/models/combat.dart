

class Encounter {
  final String? name;
  final List<Combatant> combatants;
  final int currentTurnIndex;

  const Encounter ({
    this.name,
    required this.currentTurnIndex,
    required this.combatants,
  });
}

class Combatant {
  final String name;
  final bool isPlayer;
  final int maxHitPoints;
  final int currentHitPoints;
  final int initiative;
  final int? armorClass;
  final int quantity;

  const Combatant({
    required this.name,
    required this.isPlayer,
    required this.maxHitPoints,
    required this.currentHitPoints,
    required this.initiative,
    required this.quantity,
    this.armorClass,
  });
}
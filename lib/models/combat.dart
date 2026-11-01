/// In-memory encounter and combatant models used by encounter editing and play.
///
/// These types intentionally stay independent of Drift so combat state can be
/// manipulated by the UI and mapped to database rows at the persistence layer.
class Encounter {
  final int? id;
  final String name;
  final List<Combatant> combatants;
  final int currentTurnIndex;
  final String? encounterNotes;
  final bool hasStarted;

  const Encounter({
    this.id,
    required this.name,
    required this.currentTurnIndex,
    required this.combatants,
    this.encounterNotes,
    this.hasStarted = false,
  });
}

/// Lightweight encounter summary used in browse lists.
class SavedEncounter {
  final int id;
  final String name;
  final String notes;
  final int playerCount;
  final int creatureCount;

  const SavedEncounter({
    required this.id,
    required this.name,
    required this.notes,
    required this.playerCount,
    required this.creatureCount,
  });

  int get combatantCount => playerCount + creatureCount;
}

/// Mutable form-oriented encounter shape used while assembling an encounter.
class EncounterDraft {
  String name;
  List<Combatant>? combatants;
  int? currentTurnIndex;
  String? encounterNotes;

  EncounterDraft({
    required this.name,
    required this.currentTurnIndex,
    required this.combatants,
    this.encounterNotes,
  });
}

/// A player or creature instance participating in an encounter.
///
/// Runtime combat fields are mutable so the initiative tracker can update
/// hit points, conditions, and turn state before saving the encounter.
class Combatant {
  final String name;
  final bool isPlayer;
  final int maxHitPoints;
  int? currentHitPoints;
  int? initiative;
  final int? armorClass;
  int quantity;
  final int? playerId;
  final int? creatureId;
  bool isBlinded;
  bool isCharmed;
  bool isDeafened;
  int exhaustionLevel;
  bool isFrightened;
  bool isGrappled;
  bool isIncapacitated;
  bool isInvisible;
  bool isParalyzed;
  bool isPetrified;
  bool isPoisoned;
  bool isProne;
  bool isRestrained;
  bool isStunned;
  bool isUnconscious;
  bool isTurn;
  bool isUnmasked;

  Combatant({
    required this.name,
    required this.isPlayer,
    required this.maxHitPoints,
    this.currentHitPoints,
    required this.initiative,
    required this.quantity,
    this.armorClass,
    this.playerId,
    this.creatureId,
    this.isBlinded = false,
    this.isCharmed = false,
    this.isDeafened = false,
    this.exhaustionLevel = 0,
    this.isFrightened = false,
    this.isGrappled = false,
    this.isIncapacitated = false,
    this.isInvisible = false,
    this.isParalyzed = false,
    this.isPetrified = false,
    this.isPoisoned = false,
    this.isProne = false,
    this.isRestrained = false,
    this.isStunned = false,
    this.isUnconscious = false,
    this.isTurn = false,
    this.isUnmasked = false,
  });
}

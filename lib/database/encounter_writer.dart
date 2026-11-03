// Maps encounter-domain objects to and from the normalized Drift tables.
//
// Saving replaces an encounter's participant links atomically, while loading
// rebuilds the ordered combatant list and its associated combat state.
import 'package:drift/drift.dart';
import 'package:gmdex/components/difficulty_calculator.dart';
import 'package:gmdex/database/database.dart';
import 'package:gmdex/models/combat.dart';

/// Inserts an encounter or atomically replaces an existing encounter's data.
Future<int> saveEncounter(
  AppDatabase db,
  Encounter encounter, {
  int? existingId,
}) {
  return db.transaction(() async {
    final xp = await _calculateEncounterXp(db, encounter.combatants);
    final encounterId = existingId;
    if (encounterId == null) {
      final insertedId = await db
          .into(db.encounters)
          .insert(
            EncountersCompanion.insert(
              name: encounter.name,
              notes: encounter.encounterNotes ?? '',
              totalXp: Value(xp.totalXp),
              adjustedXp: Value(xp.adjustedXp),
              hasStarted: Value(encounter.hasStarted),
            ),
          );
      await _saveCombatants(
        db,
        insertedId,
        encounter.combatants,
        encounter.currentTurnIndex,
      );
      return insertedId;
    }

    final updated =
        await (db.update(
          db.encounters,
        )..where((row) => row.id.equals(encounterId))).write(
          EncountersCompanion(
            name: Value(encounter.name),
            notes: Value(encounter.encounterNotes ?? ''),
            totalXp: Value(xp.totalXp),
            adjustedXp: Value(xp.adjustedXp),
            updatedAt: Value(DateTime.now()),
            hasStarted: Value(encounter.hasStarted),
          ),
        );
    if (updated != 1) {
      throw StateError('Encounter $encounterId no longer exists.');
    }
    await (db.delete(
      db.encounterPlayers,
    )..where((row) => row.encounterId.equals(encounterId))).go();
    await (db.delete(
      db.encounterCreatures,
    )..where((row) => row.encounterId.equals(encounterId))).go();
    await _saveCombatants(
      db,
      encounterId,
      encounter.combatants,
      encounter.currentTurnIndex,
    );
    return encounterId;
  });
}

Future<EncounterXp> _calculateEncounterXp(
  AppDatabase db,
  List<Combatant> combatants,
) async {
  final playerIds = combatants
      .where((combatant) => combatant.isPlayer && combatant.playerId != null)
      .map((combatant) => combatant.playerId!)
      .toSet();
  final creatureIds = combatants
      .where((combatant) => !combatant.isPlayer && combatant.creatureId != null)
      .map((combatant) => combatant.creatureId!)
      .toSet();

  final players = playerIds.isEmpty
      ? <PlayerRow>[]
      : await (db.select(
          db.players,
        )..where((player) => player.pId.isIn(playerIds))).get();
  final creatures = creatureIds.isEmpty
      ? <CreatureRow>[]
      : await (db.select(
          db.creatures,
        )..where((creature) => creature.id.isIn(creatureIds))).get();
  final playerLevels = {
    for (final player in players) player.pId: player.pLevel,
  };
  final creaturesById = {
    for (final creature in creatures) creature.id: creature,
  };

  final partyLevels = [
    for (final combatant in combatants)
      if (combatant.isPlayer) playerLevels[combatant.playerId] ?? 1,
  ];
  final monsterXp = [
    for (final combatant in combatants)
      if (!combatant.isPlayer)
        for (var i = 0; i < combatant.quantity; i++)
          xpForChallengeRating(
            creaturesById[combatant.creatureId]?.challengeRating,
            xpOverride: creaturesById[combatant.creatureId]?.xpOverride,
          ),
  ];

  return calculateEncounterXp(partyLevels: partyLevels, monsterXp: monsterXp);
}

/// Writes each participant and their current turn/condition state.
///
/// Creature quantity is represented as one encounter-creature row per
/// instance, while a player row retains its quantity field.
Future<void> _saveCombatants(
  AppDatabase db,
  int encounterId,
  List<Combatant> combatants,
  int currentTurnIndex,
) async {
  for (var index = 0; index < combatants.length; index++) {
    final combatant = combatants[index];
    final isTurn = index == currentTurnIndex;
    if (combatant.isPlayer) {
      final playerId = combatant.playerId;
      if (playerId == null) {
        throw ArgumentError(
          'Player combatant "${combatant.name}" has no database id.',
        );
      }
      await db
          .into(db.encounterPlayers)
          .insert(
            EncounterPlayersCompanion.insert(
              encounterId: encounterId,
              playerId: playerId,
              initiative: combatant.initiative ?? 0,
              quantity: combatant.quantity,
              currentHitpoints: Value(
                combatant.currentHitPoints ?? combatant.maxHitPoints,
              ),
              isBlinded: Value(combatant.isBlinded),
              isCharmed: Value(combatant.isCharmed),
              isDeafened: Value(combatant.isDeafened),
              exhaustionLevel: Value(combatant.exhaustionLevel),
              isFrightened: Value(combatant.isFrightened),
              isGrappled: Value(combatant.isGrappled),
              isIncapacitated: Value(combatant.isIncapacitated),
              isInvisible: Value(combatant.isInvisible),
              isParalyzed: Value(combatant.isParalyzed),
              isPetrified: Value(combatant.isPetrified),
              isPoisoned: Value(combatant.isPoisoned),
              isProne: Value(combatant.isProne),
              isRestrained: Value(combatant.isRestrained),
              isStunned: Value(combatant.isStunned),
              isUnconscious: Value(combatant.isUnconscious),
              isTurn: Value(isTurn),
            ),
          );
    } else {
      final creatureId = combatant.creatureId;
      if (creatureId == null) {
        throw ArgumentError(
          'Creature combatant "${combatant.name}" has no database id.',
        );
      }
      for (var i = 0; i < combatant.quantity; i++) {
        await db
            .into(db.encounterCreatures)
            .insert(
              EncounterCreaturesCompanion.insert(
                encounterId: encounterId,
                creatureId: creatureId,
                initiative: combatant.initiative ?? 0,
                currentHitpoints:
                    combatant.currentHitPoints ?? combatant.maxHitPoints,
                isBlinded: Value(combatant.isBlinded),
                isCharmed: Value(combatant.isCharmed),
                isDeafened: Value(combatant.isDeafened),
                exhaustionLevel: Value(combatant.exhaustionLevel),
                isFrightened: Value(combatant.isFrightened),
                isGrappled: Value(combatant.isGrappled),
                isIncapacitated: Value(combatant.isIncapacitated),
                isInvisible: Value(combatant.isInvisible),
                isParalyzed: Value(combatant.isParalyzed),
                isPetrified: Value(combatant.isPetrified),
                isPoisoned: Value(combatant.isPoisoned),
                isProne: Value(combatant.isProne),
                isRestrained: Value(combatant.isRestrained),
                isStunned: Value(combatant.isStunned),
                isUnconscious: Value(combatant.isUnconscious),
                isTurn: Value(isTurn && i == 0),
                isUnmasked: Value(combatant.isUnmasked),
                nameOverride: Value(combatant.name),
              ),
            );
      }
    }
  }
}

/// Reconstructs an encounter from its metadata and participant link rows.
///
/// Returns null if the requested encounter no longer exists; dangling player
/// or creature references are treated as data-integrity errors.
Future<Encounter?> loadEncounter(AppDatabase db, int encounterId) async {
  final row = await (db.select(
    db.encounters,
  )..where((encounter) => encounter.id.equals(encounterId))).getSingleOrNull();
  if (row == null) return null;

  final combatants = <Combatant>[];
  final playerLinks = await (db.select(
    db.encounterPlayers,
  )..where((link) => link.encounterId.equals(encounterId))).get();
  for (final link in playerLinks) {
    final player = await (db.select(
      db.players,
    )..where((player) => player.pId.equals(link.playerId))).getSingleOrNull();
    if (player == null) {
      throw StateError('Encounter $encounterId references a missing player.');
    }
    combatants.add(
      Combatant(
        name: player.pName,
        isPlayer: true,
        currentHitPoints: link.currentHitpoints,
        maxHitPoints: player.pHitPoints ?? 0,
        initiative: link.initiative,
        quantity: link.quantity,
        playerId: player.pId,
        isBlinded: link.isBlinded,
        isCharmed: link.isCharmed,
        isDeafened: link.isDeafened,
        exhaustionLevel: link.exhaustionLevel,
        isFrightened: link.isFrightened,
        isGrappled: link.isGrappled,
        isIncapacitated: link.isIncapacitated,
        isInvisible: link.isInvisible,
        isParalyzed: link.isParalyzed,
        isPetrified: link.isPetrified,
        isPoisoned: link.isPoisoned,
        isProne: link.isProne,
        isRestrained: link.isRestrained,
        isStunned: link.isStunned,
        isUnconscious: link.isUnconscious,
        isTurn: link.isTurn,
      ),
    );
  }

  final creatureLinks = await (db.select(
    db.encounterCreatures,
  )..where((link) => link.encounterId.equals(encounterId))).get();
  for (final link in creatureLinks) {
    final creature =
        await (db.select(db.creatures)
              ..where((creature) => creature.id.equals(link.creatureId)))
            .getSingleOrNull();
    if (creature == null) {
      throw StateError('Encounter $encounterId references a missing creature.');
    }
    final maxHitPoints = creature.hitPoints ?? 0;
    combatants.add(
      Combatant(
        name: link.nameOverride ?? creature.name,
        isPlayer: false,
        currentHitPoints: link.currentHitpoints,
        maxHitPoints: maxHitPoints,
        initiative: link.initiative,
        quantity: 1,
        creatureId: creature.id,
        isBlinded: link.isBlinded,
        isCharmed: link.isCharmed,
        isDeafened: link.isDeafened,
        exhaustionLevel: link.exhaustionLevel,
        isFrightened: link.isFrightened,
        isGrappled: link.isGrappled,
        isIncapacitated: link.isIncapacitated,
        isInvisible: link.isInvisible,
        isParalyzed: link.isParalyzed,
        isPetrified: link.isPetrified,
        isPoisoned: link.isPoisoned,
        isProne: link.isProne,
        isRestrained: link.isRestrained,
        isStunned: link.isStunned,
        isUnconscious: link.isUnconscious,
        isTurn: link.isTurn,
        isUnmasked: link.isUnmasked,
      ),
    );
  }

  final savedTurnIndex = combatants.indexWhere((combatant) => combatant.isTurn);
  return Encounter(
    id: row.id,
    name: row.name,
    currentTurnIndex: savedTurnIndex < 0 ? 0 : savedTurnIndex,
    combatants: combatants,
    encounterNotes: row.notes,
    hasStarted: row.hasStarted,
  );
}

/// Saves notes and updates the encounter's modification timestamp.
Future<void> saveEncounterNotes(
  AppDatabase db,
  int encounterId,
  String notes,
) async {
  final updated =
      await (db.update(
        db.encounters,
      )..where((row) => row.id.equals(encounterId))).write(
        EncountersCompanion(
          notes: Value(notes.trim()),
          updatedAt: Value(DateTime.now()),
        ),
      );
  if (updated != 1) {
    throw StateError('Encounter $encounterId no longer exists.');
  }
}

/// Deletes an encounter; linked participant rows are removed by cascades.
Future<int> deleteEncounter(AppDatabase db, int encounterId) {
  return (db.delete(
    db.encounters,
  )..where((row) => row.id.equals(encounterId))).go();
}

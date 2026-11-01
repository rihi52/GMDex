// Drift schema for player characters, creatures, encounters, and related data.
//
// The table definitions are the source of truth for generated row types and
// query APIs. Run Drift code generation after changing this file; do not edit
// `database.g.dart` directly.
import 'package:drift/drift.dart';

part 'database.g.dart';

/// Player-character records managed by the Players screen.
@DataClassName('PlayerRow')
@TableIndex(name: 'idx_player_name', columns: {#pName})
class Players extends Table {
  IntColumn get pId => integer().autoIncrement()();
  TextColumn get pName => text()();
  TextColumn get pClass => text()();
  IntColumn get pLevel => integer().nullable()();
  IntColumn get pHitPoints => integer().nullable()();
  IntColumn get pArmorClass => integer().nullable()();
  IntColumn get pPassivePerception => integer().nullable()();
  TextColumn get pOriginalCampaign => text().nullable()();
  TextColumn get pNotes => text().nullable()();
}

/// Saved encounter metadata; participant links live in their own tables.
@DataClassName('EncounterRow')
@TableIndex(name: 'idx_encounter_name', columns: {#name})
@TableIndex(name: 'idx_encounter_updated_at', columns: {#updatedAt})
class Encounters extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get notes => text()();
  IntColumn get totalXp => integer().nullable()();
  IntColumn get adjustedXp => integer().nullable()();
  BoolColumn get hasStarted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Creature instances and their combat state within a saved encounter.
@DataClassName('EncounterCreaturesRow')
@TableIndex(
  name: 'idx_encounter_creature_encounter_initiative',
  columns: {#encounterId, #initiative},
)
@TableIndex(name: 'idx_encounter_creature_creature', columns: {#creatureId})
class EncounterCreatures extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get encounterId =>
      integer().references(Encounters, #id, onDelete: KeyAction.cascade)();
  IntColumn get creatureId =>
      integer().references(Creatures, #id, onDelete: KeyAction.cascade)();
  IntColumn get initiative => integer()();
  IntColumn get currentHitpoints => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isBlinded => boolean().withDefault(const Constant(false))();
  BoolColumn get isCharmed => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeafened => boolean().withDefault(const Constant(false))();
  IntColumn get exhaustionLevel => integer().withDefault(const Constant(0))();
  BoolColumn get isFrightened => boolean().withDefault(const Constant(false))();
  BoolColumn get isGrappled => boolean().withDefault(const Constant(false))();
  BoolColumn get isIncapacitated =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isInvisible => boolean().withDefault(const Constant(false))();
  BoolColumn get isParalyzed => boolean().withDefault(const Constant(false))();
  BoolColumn get isPetrified => boolean().withDefault(const Constant(false))();
  BoolColumn get isPoisoned => boolean().withDefault(const Constant(false))();
  BoolColumn get isProne => boolean().withDefault(const Constant(false))();
  BoolColumn get isRestrained => boolean().withDefault(const Constant(false))();
  BoolColumn get isStunned => boolean().withDefault(const Constant(false))();
  BoolColumn get isUnconscious =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isTurn => boolean().withDefault(const Constant(false))();
  BoolColumn get isUnmasked => boolean().withDefault(const Constant(false))();
}

/// Player instances and their combat state within a saved encounter.
@DataClassName('EncounterPlayersRow')
@TableIndex(
  name: 'idx_encounter_player_encounter_initiative',
  columns: {#encounterId, #initiative},
)
@TableIndex(name: 'idx_encounter_player_player', columns: {#playerId})
class EncounterPlayers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get encounterId =>
      integer().references(Encounters, #id, onDelete: KeyAction.cascade)();
  IntColumn get playerId =>
      integer().references(Players, #pId, onDelete: KeyAction.cascade)();
  IntColumn get initiative => integer()();
  IntColumn get quantity => integer()();
  IntColumn get currentHitpoints => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isBlinded => boolean().withDefault(const Constant(false))();
  BoolColumn get isCharmed => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeafened => boolean().withDefault(const Constant(false))();
  IntColumn get exhaustionLevel => integer().withDefault(const Constant(0))();
  BoolColumn get isFrightened => boolean().withDefault(const Constant(false))();
  BoolColumn get isGrappled => boolean().withDefault(const Constant(false))();
  BoolColumn get isIncapacitated =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isInvisible => boolean().withDefault(const Constant(false))();
  BoolColumn get isParalyzed => boolean().withDefault(const Constant(false))();
  BoolColumn get isPetrified => boolean().withDefault(const Constant(false))();
  BoolColumn get isPoisoned => boolean().withDefault(const Constant(false))();
  BoolColumn get isProne => boolean().withDefault(const Constant(false))();
  BoolColumn get isRestrained => boolean().withDefault(const Constant(false))();
  BoolColumn get isStunned => boolean().withDefault(const Constant(false))();
  BoolColumn get isUnconscious =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isTurn => boolean().withDefault(const Constant(false))();
}

/// Creature notes, stored separately from the core creature row.
@DataClassName('NoteRow')
@TableIndex(name: 'idx_note_creature', columns: {#creatureId})
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get creatureId =>
      integer().references(Creatures, #id, onDelete: KeyAction.cascade)();
  TextColumn get body => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// DataClassName avoids clashing with your Creature model class.
/// Core creature identity and stat-block fields.
@DataClassName('CreatureRow')
@TableIndex(
  name: 'idx_creature_name_source',
  columns: {#name, #source},
  unique: true,
)
@TableIndex(name: 'idx_creature_cr', columns: {#challengeRating})
@TableIndex(name: 'idx_creature_type', columns: {#type})
class Creatures extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get source => text().withDefault(const Constant(''))();
  IntColumn get page => integer().nullable()();
  BoolColumn get isSrd => boolean().withDefault(const Constant(false))();

  // Display text ('Medium', 'Neutral Good'), same as your Creature model,
  // so creatures made in the editor store the same way as imported ones.
  TextColumn get size => text().nullable()();
  TextColumn get type => text().nullable()();
  TextColumn get typeTags => text().nullable()();
  TextColumn get alignment => text().nullable()();

  IntColumn get armorClass => integer().nullable()(); // first ac entry
  TextColumn get armorClassType => text().nullable()();
  TextColumn get armorClassOther =>
      text().nullable()(); // '15 (with mage armor)'
  IntColumn get hitPoints => integer().nullable()();
  TextColumn get hitPointFormula => text().nullable()();

  IntColumn get speedWalk => integer().nullable()();
  IntColumn get speedFly => integer().nullable()();
  IntColumn get speedSwim => integer().nullable()();
  IntColumn get speedClimb => integer().nullable()();
  IntColumn get speedBurrow => integer().nullable()();

  IntColumn get strength => integer().withDefault(const Constant(10))();
  IntColumn get dexterity => integer().withDefault(const Constant(10))();
  IntColumn get constitution => integer().withDefault(const Constant(10))();
  IntColumn get intelligence => integer().withDefault(const Constant(10))();
  IntColumn get wisdom => integer().withDefault(const Constant(10))();
  IntColumn get charisma => integer().withDefault(const Constant(10))();

  IntColumn get passivePerception => integer().nullable()();

  TextColumn get challengeRating => text().nullable()(); // '1/4', '10'
  TextColumn get challengeRatingLair => text().nullable()();
  TextColumn get challengeRatingCoven => text().nullable()();
  IntColumn get xpOverride => integer().nullable()();

  TextColumn get damageVulnerabilities => text().nullable()();
  TextColumn get damageResistances => text().nullable()();
  TextColumn get damageImmunities => text().nullable()();
  TextColumn get conditionImmunities => text().nullable()();

  IntColumn get legendaryGroupId => integer().nullable().references(
    LegendaryGroups,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get legendaryGroupName => text().nullable()();
  TextColumn get legendaryGroupSource => text().nullable()();
}

/// Ordered creature actions, including reactions and legendary actions.
@DataClassName('CreatureActionRow')
@TableIndex(name: 'idx_action_creature', columns: {#creatureId})
class CreatureActions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get creatureId =>
      integer().references(Creatures, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get description => text()();
  IntColumn get sortOrder => integer()();
  // 'action', 'bonus', 'reaction', 'legendary', 'special', 'villain'
  TextColumn get kind => text()();
}

/// Ordered passive traits belonging to a creature.
@DataClassName('CreatureTraitRow')
@TableIndex(name: 'idx_trait_creature', columns: {#creatureId})
class CreatureTraits extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get creatureId =>
      integer().references(Creatures, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get description => text()();
  IntColumn get sortOrder => integer()();
}

/// Creature spellcasting blocks, which own their spell rows.
@DataClassName('CreatureSpellcastingRow')
@TableIndex(name: 'idx_spellcasting_creature', columns: {#creatureId})
class CreatureSpellcastings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get creatureId =>
      integer().references(Creatures, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()(); // 'Spellcasting' / 'Innate Spellcasting'
  TextColumn get headerText => text().nullable()();
  TextColumn get footerText => text().nullable()();
  TextColumn get ability => text().nullable()(); // 'int', 'wis', ...
  TextColumn get hiddenUses =>
      text().nullable()(); // JSON `hidden`, e.g. 'will'
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

/// Spells and spell slots attached to a spellcasting block.
@DataClassName('CreatureSpellRow')
@TableIndex(name: 'idx_spell_spellcasting', columns: {#spellcastingId})
class CreatureSpells extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get spellcastingId => integer().references(
    CreatureSpellcastings,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get spellName => text()();
  // Exactly one of these two is set:
  IntColumn get spellLevel => integer().nullable()(); // 0 = cantrip
  TextColumn get uses => text().nullable()(); // 'will', '1e', '2e', '3', ...
  IntColumn get slots => integer().nullable()(); // leveled spells only
  IntColumn get sortOrder => integer()();
}

/// Per-ability saving-throw bonuses for each creature.
@DataClassName('CreatureSaveRow')
class CreatureSaves extends Table {
  IntColumn get creatureId =>
      integer().references(Creatures, #id, onDelete: KeyAction.cascade)();
  TextColumn get ability =>
      text()(); // 'str', 'dex', 'con', 'int', 'wis', 'cha'
  IntColumn get bonus => integer()(); // JSON '+6' parsed to 6

  @override
  Set<Column> get primaryKey => {creatureId, ability};
}

/// Per-skill bonuses for each creature.
@DataClassName('CreatureSkillRow')
class CreatureSkills extends Table {
  IntColumn get creatureId =>
      integer().references(Creatures, #id, onDelete: KeyAction.cascade)();
  TextColumn get skill =>
      text()(); // camelCase: 'sleightOfHand', 'animalHandling'
  IntColumn get bonus => integer()();

  @override
  Set<Column> get primaryKey => {creatureId, skill};
}

/// Individual senses retained in their original display order.
@DataClassName('CreatureSenseRow')
class CreatureSenses extends Table {
  IntColumn get creatureId =>
      integer().references(Creatures, #id, onDelete: KeyAction.cascade)();
  TextColumn get sense => text()();

  @override
  Set<Column> get primaryKey => {creatureId, sense};
}

/// Individual languages associated with each creature.
@DataClassName('CreatureLanguageRow')
class CreatureLanguages extends Table {
  IntColumn get creatureId =>
      integer().references(Creatures, #id, onDelete: KeyAction.cascade)();
  TextColumn get language => text()();

  @override
  Set<Column> get primaryKey => {creatureId, language};
}

/// Environment tags used to classify where a creature is found.
@DataClassName('CreatureEnvironmentRow')
class CreatureEnvironments extends Table {
  IntColumn get creatureId =>
      integer().references(Creatures, #id, onDelete: KeyAction.cascade)();
  TextColumn get environment => text()();

  @override
  Set<Column> get primaryKey => {creatureId, environment};
}

/// Legendary-group metadata shared by one or more creatures.
@DataClassName('LegendaryGroupRow')
@TableIndex(
  name: 'idx_legendary_group_name_source',
  columns: {#name, #source},
  unique: true,
)
class LegendaryGroups extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get source => text()();
  IntColumn get page => integer().nullable()();
}

/// Ordered lair/regional text entries belonging to a legendary group.
@DataClassName('LegendaryGroupEntryRow')
@TableIndex(name: 'idx_group_entry_group', columns: {#groupId})
class LegendaryGroupEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get groupId =>
      integer().references(LegendaryGroups, #id, onDelete: KeyAction.cascade)();
  TextColumn get section => text()(); // 'lair' or 'regional'
  // 'text' = paragraph, 'bullet' = list item, 'entry' = named block
  TextColumn get kind => text()();
  TextColumn get title => text().nullable()(); // named items / named blocks
  TextColumn get body => text()();
  IntColumn get sortOrder => integer()();
}

/// Opens the generated Drift query API and owns schema migrations.
@DriftDatabase(
  tables: [
    Players,
    Encounters,
    EncounterCreatures,
    EncounterPlayers,
    Notes,
    Creatures,
    CreatureActions,
    CreatureTraits,
    CreatureSpellcastings,
    CreatureSpells,
    CreatureSaves,
    CreatureSkills,
    CreatureSenses,
    CreatureLanguages,
    CreatureEnvironments,
    LegendaryGroups,
    LegendaryGroupEntries,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Creates a database connection backed by Drift's executor.
  AppDatabase(super.e);

  /// Removes all stored records while preserving the database schema.
  Future<void> clearData() async {
    await transaction(() async {
      for (final table in allTables.toList().reversed) {
        await delete(table).go();
      }
      await customStatement('DELETE FROM sqlite_sequence');
    });
  }

  @override
  int get schemaVersion => 14;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    // Apply each schema transition in version order for existing installations.
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        // Create everything new (tables and indexes), leave players alone.
        for (final entity in allSchemaEntities) {
          if (entity != players) await m.create(entity);
        }
      } else if (from < 3) {
        await m.create(encounters);
        await m.create(encounterCreatures);
        await m.create(encounterPlayers);
      }
      if (from < 3) {
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_player_name ON players (p_name)',
        );
      }
      if (from < 4) {
        await m.addColumn(players, players.pNotes);
      }
      if (from >= 3 && from < 5) {
        await customStatement('''
          CREATE TABLE encounter_creatures_new (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            encounter_id INTEGER NOT NULL
              REFERENCES encounters (id) ON DELETE CASCADE,
            creature_id INTEGER NOT NULL
              REFERENCES creatures (id) ON DELETE CASCADE,
            initiative INTEGER NOT NULL,
            current_hitpoints INTEGER NOT NULL,
            created_at INTEGER NOT NULL
              DEFAULT (CAST(strftime('%s', 'now') AS INTEGER) * 1000),
            updated_at INTEGER NOT NULL
              DEFAULT (CAST(strftime('%s', 'now') AS INTEGER) * 1000)
          )
        ''');
        await customStatement('''
          WITH RECURSIVE expanded (
            id, encounter_id, creature_id, initiative, current_hitpoints,
            created_at, updated_at, copy_number, quantity
          ) AS (
            SELECT
              ec.id,
              ec.encounter_id,
              ec.creature_id,
              ec.initiative,
              COALESCE(c.hit_points, 0),
              CASE
                WHEN typeof(ec.created_at) = 'integer' THEN ec.created_at
                ELSE CAST(strftime('%s', ec.created_at) AS INTEGER) * 1000
              END,
              CASE
                WHEN typeof(ec.updated_at) = 'integer' THEN ec.updated_at
                ELSE CAST(strftime('%s', ec.updated_at) AS INTEGER) * 1000
              END,
              1,
              ec.quantity
            FROM encounter_creatures ec
            LEFT JOIN creatures c ON c.id = ec.creature_id
            UNION ALL
            SELECT
              NULL,
              encounter_id,
              creature_id,
              initiative,
              current_hitpoints,
              created_at,
              updated_at,
              copy_number + 1,
              quantity
            FROM expanded
            WHERE copy_number < quantity
          )
          INSERT INTO encounter_creatures_new (
            id, encounter_id, creature_id, initiative, current_hitpoints,
            created_at, updated_at
          )
          SELECT
            id, encounter_id, creature_id, initiative, current_hitpoints,
            created_at, updated_at
          FROM expanded
          WHERE copy_number <= quantity
        ''');
        await customStatement('''
          DROP INDEX IF EXISTS idx_encounter_creature_encounter_initiative
        ''');
        await customStatement(
          'DROP INDEX IF EXISTS idx_encounter_creature_creature',
        );
        await customStatement('DROP TABLE encounter_creatures');
        await customStatement(
          'ALTER TABLE encounter_creatures_new RENAME TO encounter_creatures',
        );
        await customStatement('''
          CREATE INDEX idx_encounter_creature_encounter_initiative
          ON encounter_creatures (encounter_id, initiative)
        ''');
        await customStatement('''
          CREATE INDEX idx_encounter_creature_creature
          ON encounter_creatures (creature_id)
        ''');
      }
      if (from >= 3 && from < 6) {
        await m.addColumn(encounterPlayers, encounterPlayers.currentHitpoints);
        await customStatement('''
          UPDATE encounter_players
          SET current_hitpoints = COALESCE(
            (SELECT p_hit_points
             FROM players
             WHERE players.p_id = encounter_players.player_id),
            0
          )
        ''');
      }
      if (from >= 3 && from < 7) {
        await m.addColumn(encounterCreatures, encounterCreatures.isBlinded);
        await m.addColumn(encounterCreatures, encounterCreatures.isCharmed);
        await m.addColumn(encounterCreatures, encounterCreatures.isDeafened);
        await m.addColumn(
          encounterCreatures,
          encounterCreatures.exhaustionLevel,
        );
        await m.addColumn(encounterCreatures, encounterCreatures.isFrightened);
        await m.addColumn(encounterCreatures, encounterCreatures.isGrappled);
        await m.addColumn(
          encounterCreatures,
          encounterCreatures.isIncapacitated,
        );
        await m.addColumn(encounterCreatures, encounterCreatures.isInvisible);
        await m.addColumn(encounterCreatures, encounterCreatures.isParalyzed);
        await m.addColumn(encounterCreatures, encounterCreatures.isPetrified);
        await m.addColumn(encounterCreatures, encounterCreatures.isPoisoned);
        await m.addColumn(encounterCreatures, encounterCreatures.isProne);
        await m.addColumn(encounterCreatures, encounterCreatures.isRestrained);
        await m.addColumn(encounterCreatures, encounterCreatures.isStunned);
        await m.addColumn(encounterCreatures, encounterCreatures.isUnconscious);

        await m.addColumn(encounterPlayers, encounterPlayers.isBlinded);
        await m.addColumn(encounterPlayers, encounterPlayers.isCharmed);
        await m.addColumn(encounterPlayers, encounterPlayers.isDeafened);
        await m.addColumn(encounterPlayers, encounterPlayers.exhaustionLevel);
        await m.addColumn(encounterPlayers, encounterPlayers.isFrightened);
        await m.addColumn(encounterPlayers, encounterPlayers.isGrappled);
        await m.addColumn(encounterPlayers, encounterPlayers.isIncapacitated);
        await m.addColumn(encounterPlayers, encounterPlayers.isInvisible);
        await m.addColumn(encounterPlayers, encounterPlayers.isParalyzed);
        await m.addColumn(encounterPlayers, encounterPlayers.isPetrified);
        await m.addColumn(encounterPlayers, encounterPlayers.isPoisoned);
        await m.addColumn(encounterPlayers, encounterPlayers.isProne);
        await m.addColumn(encounterPlayers, encounterPlayers.isRestrained);
        await m.addColumn(encounterPlayers, encounterPlayers.isStunned);
        await m.addColumn(encounterPlayers, encounterPlayers.isUnconscious);
      }
      if (from >= 3 && from < 8) {
        await m.addColumn(encounterCreatures, encounterCreatures.isTurn);
        await m.addColumn(encounterPlayers, encounterPlayers.isTurn);
      }
      // Versions before 3 create the encounter table with the current schema.
      if (from >= 3 && from < 9) {
        await m.addColumn(encounters, encounters.totalXp);
        await m.addColumn(encounters, encounters.adjustedXp);
      }
      if (from >= 3 && from < 11) {
        await m.addColumn(encounters, encounters.hasStarted);
      }
      if (from < 12) {
        await m.addColumn(players, players.pPassivePerception);
      }
      if (from >= 2 && from < 13) {
        await m.addColumn(creatures, creatures.legendaryGroupName);
        await m.addColumn(creatures, creatures.legendaryGroupSource);
        await customStatement('''
          UPDATE creatures
          SET legendary_group_id = (
            SELECT legendary_groups.id
            FROM legendary_groups
            WHERE legendary_groups.name = creatures.name
              AND (
                lower(legendary_groups.source) = lower(creatures.source)
                OR instr(
                  ',' || lower(creatures.source) || ',',
                  ',' || lower(legendary_groups.source) || ','
                ) > 0
                OR (
                  SELECT COUNT(*)
                  FROM legendary_groups AS candidates
                  WHERE candidates.name = creatures.name
                ) = 1
              )
            LIMIT 1
          )
          WHERE legendary_group_id IS NULL
        ''');
        await customStatement('''
          UPDATE creatures
          SET legendary_group_name = (
                SELECT name FROM legendary_groups
                WHERE id = creatures.legendary_group_id
              ),
              legendary_group_source = (
                SELECT source FROM legendary_groups
                WHERE id = creatures.legendary_group_id
              )
          WHERE legendary_group_id IS NOT NULL
            AND legendary_group_name IS NULL
        ''');
      }
      if (from < 14) {
        await m.addColumn(encounterCreatures, encounterCreatures.isUnmasked);
      }
    },
    beforeOpen: (details) async {
      // SQLite ignores foreign keys unless this is on, so the
      // onDelete: cascade rules would silently do nothing.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

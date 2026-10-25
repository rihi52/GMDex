import 'package:drift/drift.dart';

part 'database.g.dart';

class Players extends Table {
  IntColumn get pId => integer().autoIncrement()();
  TextColumn get pName => text()();
  TextColumn get pClass => text()();
  IntColumn get pLevel => integer().nullable()();
  IntColumn get pHitPoints => integer().nullable()();
  IntColumn get pArmorClass => integer().nullable()();
  TextColumn get pOriginalCampaign => text().nullable()();
}

// DataClassName avoids clashing with your existing Creature, CreatureTrait,
// CreatureAction and CreatureSpellcasting model classes.
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
  TextColumn get armorClassOther => text().nullable()(); // '15 with mage armor'
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
}

@DataClassName('CreatureActionRow')
@TableIndex(name: 'idx_action_creature', columns: {#creatureId})
class CreatureActions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get creatureId =>
      integer().references(Creatures, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get description => text()(); // was `text`
  IntColumn get sortOrder => integer()();
  // 'action', 'bonus', 'reaction', 'legendary'
  TextColumn get kind => text()();
}

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
  TextColumn get hiddenUses => text().nullable()(); // JSON `hidden`, e.g. 'will'
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

@DataClassName('CreatureSpellRow')
@TableIndex(name: 'idx_spell_spellcasting', columns: {#spellcastingId})
class CreatureSpells extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get spellcastingId => integer()
      .references(CreatureSpellcastings, #id, onDelete: KeyAction.cascade)();
  TextColumn get spellName => text()();
  // Exactly one of these two is set:
  IntColumn get spellLevel => integer().nullable()(); // 0 = cantrip
  TextColumn get uses => text().nullable()(); // 'will', '1e', '2e', '3', ...
  IntColumn get slots => integer().nullable()(); // leveled spells only
  IntColumn get sortOrder => integer()();
}

@DataClassName('CreatureSaveRow')
class CreatureSaves extends Table {
  IntColumn get creatureId =>
      integer().references(Creatures, #id, onDelete: KeyAction.cascade)();
  TextColumn get ability => text()(); // 'str', 'dex', ...
  IntColumn get bonus => integer()(); // was text '+6'

  @override
  Set<Column> get primaryKey => {creatureId, ability};
}

@DataClassName('CreatureSkillRow')
class CreatureSkills extends Table {
  IntColumn get creatureId =>
      integer().references(Creatures, #id, onDelete: KeyAction.cascade)();
  TextColumn get skill => text()(); // 'sleight of hand', ...
  IntColumn get bonus => integer()();

  @override
  Set<Column> get primaryKey => {creatureId, skill};
}

@DataClassName('CreatureSenseRow')
class CreatureSenses extends Table {
  IntColumn get creatureId =>
      integer().references(Creatures, #id, onDelete: KeyAction.cascade)();
  TextColumn get sense => text()();

  @override
  Set<Column> get primaryKey => {creatureId, sense};
}

@DataClassName('CreatureLanguageRow')
class CreatureLanguages extends Table {
  IntColumn get creatureId =>
      integer().references(Creatures, #id, onDelete: KeyAction.cascade)();
  TextColumn get language => text()();

  @override
  Set<Column> get primaryKey => {creatureId, language};
}

@DataClassName('CreatureEnvironmentRow')
class CreatureEnvironments extends Table {
  IntColumn get creatureId =>
      integer().references(Creatures, #id, onDelete: KeyAction.cascade)();
  TextColumn get environment => text()();

  @override
  Set<Column> get primaryKey => {creatureId, environment};
}

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

@DataClassName('LegendaryGroupEntryRow')
@TableIndex(name: 'idx_group_entry_group', columns: {#groupId})
class LegendaryGroupEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get groupId => integer()
      .references(LegendaryGroups, #id, onDelete: KeyAction.cascade)();
  TextColumn get section => text()(); // 'lair' or 'regional'
  // 'text' = paragraph, 'bullet' = list item, 'entry' = named block
  TextColumn get kind => text()();
  TextColumn get title => text().nullable()(); // named items / named blocks
  TextColumn get body => text()();
  IntColumn get sortOrder => integer()();
}

@DriftDatabase(tables: [
  Players,
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
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        // Create everything new (tables and indexes), leave players alone.
        for (final entity in allSchemaEntities) {
          if (entity != players) await m.create(entity);
        }
      }
    },
    beforeOpen: (details) async {
      // SQLite ignores foreign keys unless this is on, so the
      // onDelete: cascade rules would silently do nothing.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
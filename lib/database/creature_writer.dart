// Saves editable creature stat blocks and their normalized child records.
//
// The writer preserves import-only metadata on updates, while replacing the
// child records controlled by the editor in a single transaction.
import 'package:drift/drift.dart' show BooleanExpressionOperators, InsertMode, Value;

import 'package:gmdex/components/creature_calculations.dart';
import 'package:gmdex/database/database.dart' hide CreatureSkills;
import 'package:gmdex/models/creature.dart';

/// Thrown when another creature already has this name and source.
class CreatureNameTaken implements Exception {
  /// Creates a conflict error for a name/source pair already in use.
  CreatureNameTaken(this.name);
  final String name;

  @override
  String toString() => 'A creature named "$name" already exists.';
}

const _typeToKind = <ActionType, String>{
  ActionType.action: 'action',
  ActionType.bonusAction: 'bonus',
  ActionType.reaction: 'reaction',
  ActionType.legendary: 'legendary',
  ActionType.special: 'special',
  ActionType.villainAction: 'villain',
};

String? _blank(String? s) {
  final t = s?.trim();
  return (t == null || t.isEmpty) ? null : t;
}

int? _nz(int? v) => (v == null || v == 0) ? null : v;

int _mod(int score) => ((score - 10) / 2).floor();

List<String> _split(String? s) => (s ?? '')
    .split(',')
    .map((e) => e.trim())
    .where((e) => e.isNotEmpty)
    .toList();

/// Inserts a new creature, or updates one in place when [existingId] is given.
/// Returns the creature's id. Throws [CreatureNameTaken] on a name clash.
/// Inserts or updates a creature and its editor-managed child data.
///
/// A creature's name must be unique within its source. Existing records retain
/// their source and import-only metadata; new records use [newSource].
Future<int> saveCreature(
  AppDatabase db,
  Creature c, {
  int? existingId,
  String newSource = 'Custom',
}) {
  return db.transaction(() async {
    final name = c.name.trim();

    // Updates keep the row's current source; new creatures get newSource.
    var source = newSource;
    if (existingId != null) {
      final current = await (db.select(
        db.creatures,
      )..where((r) => r.id.equals(existingId))).getSingle();
      source = current.source;
    }

    final clash =
        await (db.select(db.creatures)..where(
              (r) =>
                  r.name.equals(name) &
                  r.source.equals(source) &
                  r.id.equals(existingId ?? -1).not(),
            ))
            .getSingleOrNull();
    if (clash != null) throw CreatureNameTaken(name);

    // Only the columns the editor knows about. On update, everything else
    // (source, page, damage lists, group link, ...) is left as it was.
    final fields = CreaturesCompanion(
      name: Value(name),
      size: Value(_blank(c.size)),
      type: Value(_blank(c.type)),
      alignment: Value(_blank(c.alignment)),
      armorClass: Value(c.armorClass.ac),
      armorClassType: Value(_blank(c.armorClass.type)),
      hitPoints: Value(c.hitPoints),
      hitPointFormula: Value(_blank(c.hitPointFormula)),
      speedWalk: Value(_nz(c.speed.walk)),
      speedFly: Value(_nz(c.speed.fly)),
      speedClimb: Value(_nz(c.speed.climb)),
      speedSwim: Value(_nz(c.speed.swim)),
      speedBurrow: Value(_nz(c.speed.burrow)),
      strength: Value(c.abilityScores.strength),
      dexterity: Value(c.abilityScores.dexterity),
      constitution: Value(c.abilityScores.constitution),
      intelligence: Value(c.abilityScores.intelligence),
      wisdom: Value(c.abilityScores.wisdom),
      charisma: Value(c.abilityScores.charisma),
      challengeRating: Value(_blank(c.challengeRating.cr)),
      challengeRatingLair: Value(_blank(c.challengeRating.lair)),
      challengeRatingCoven: Value(_blank(c.challengeRating.coven)),
    );

    final int id;
    if (existingId == null) {
      id = await db
          .into(db.creatures)
          .insert(fields.copyWith(source: Value(source)));
    } else {
      id = existingId;
      await (db.update(db.creatures)..where((r) => r.id.equals(id))).write(fields);
      await _clearChildren(db, id);
    }

    await _insertChildren(db, id, c);
    return id;
  });
}

/// Deletes only the child rows rebuilt by the editor before reinserting them.
///
/// Notes, environment rows, and legendary-group associations are intentionally
/// preserved because this editor does not own those fields.
Future<void> _clearChildren(AppDatabase db, int id) async {
  await (db.delete(db.creatureActions)..where((t) => t.creatureId.equals(id))).go();
  await (db.delete(db.creatureTraits)..where((t) => t.creatureId.equals(id))).go();
  await (db.delete(db.creatureSaves)..where((t) => t.creatureId.equals(id))).go();
  await (db.delete(db.creatureSkills)..where((t) => t.creatureId.equals(id))).go();
  await (db.delete(db.creatureSenses)..where((t) => t.creatureId.equals(id))).go();
  await (db.delete(db.creatureLanguages)..where((t) => t.creatureId.equals(id))).go();
  // Spells go with their spellcasting block (ON DELETE CASCADE).
  await (db.delete(db.creatureSpellcastings)..where((t) => t.creatureId.equals(id))).go();
  // Environments, notes and legendary-group rows are not touched.
}

/// Converts nested model values into the creature's normalized child tables.
///
/// This includes proficiency rows, senses/languages, traits, actions, and
/// spellcasting data; list order is persisted for presentation.
Future<void> _insertChildren(AppDatabase db, int id, Creature c) async {
  final a = c.abilityScores;
  final pb =
      c.proficiencyBonus?.toInt() ??
      proficiencyBonusCalc(tryParseFraction(c.challengeRating.cr) ?? 0).toInt();

  // ----- saves: one row per ticked proficiency -----
  final st = c.savingThrows;
  final saveDefs = <(String, bool?, int)>[
    ('str', st.isStrProf, _mod(a.strength)),
    ('dex', st.isDexProf, _mod(a.dexterity)),
    ('con', st.isConProf, _mod(a.constitution)),
    ('int', st.isIntProf, _mod(a.intelligence)),
    ('wis', st.isWisProf, _mod(a.wisdom)),
    ('cha', st.isChaProf, _mod(a.charisma)),
  ];
  final saves = [
    for (final (key, prof, mod) in saveDefs)
      if (prof == true)
        CreatureSavesCompanion.insert(
          creatureId: id,
          ability: key,
          bonus: mod + pb,
        ),
  ];

  // ----- skills: keep an existing '+13' if there is one, else compute -----
  final skills = <CreatureSkillsCompanion>[];
  final sk = c.skills;
  if (sk != null) {
    final defs = <(String, String?, bool?, int)>[
      ('athletics', sk.athletics, sk.isAthleticsProf, _mod(a.strength)),
      ('acrobatics', sk.acrobatics, sk.isAcrobaticsProf, _mod(a.dexterity)),
      ('sleightOfHand', sk.sleightOfHand, sk.isSleightOfHandProf, _mod(a.dexterity)),
      ('stealth', sk.stealth, sk.isStealthProf, _mod(a.dexterity)),
      ('arcana', sk.arcana, sk.isArcanaProf, _mod(a.intelligence)),
      ('history', sk.history, sk.isHistoryProf, _mod(a.intelligence)),
      ('investigation', sk.investigation, sk.isInvestigationProf, _mod(a.intelligence)),
      ('nature', sk.nature, sk.isNatureProf, _mod(a.intelligence)),
      ('religion', sk.religion, sk.isReligionProf, _mod(a.intelligence)),
      ('animalHandling', sk.animalHandling, sk.isAnimalHandlingProf, _mod(a.wisdom)),
      ('insight', sk.insight, sk.isInsightProf, _mod(a.wisdom)),
      ('medicine', sk.medicine, sk.isMedicineProf, _mod(a.wisdom)),
      ('perception', sk.perception, sk.isPerceptionProf, _mod(a.wisdom)),
      ('survival', sk.survival, sk.isSurvivalProf, _mod(a.wisdom)),
      ('deception', sk.deception, sk.isDeceptionProf, _mod(a.charisma)),
      ('intimidation', sk.intimidation, sk.isIntimidationProf, _mod(a.charisma)),
      ('performance', sk.performance, sk.isPerformanceProf, _mod(a.charisma)),
      ('persuasion', sk.persuasion, sk.isPersuasionProf, _mod(a.charisma)),
    ];
    for (final (key, value, prof, mod) in defs) {
      if (prof != true) continue;
      skills.add(
        CreatureSkillsCompanion.insert(
          creatureId: id,
          skill: key,
          bonus: int.tryParse(value ?? '') ?? (mod + pb),
        ),
      );
    }
  }

  // ----- senses & languages (stored joined with ', ' in the model) -----
  final senses = [
    for (final s in _split(c.senses))
      CreatureSensesCompanion.insert(creatureId: id, sense: s),
  ];
  final languages = [
    for (final s in _split(c.languages))
      CreatureLanguagesCompanion.insert(creatureId: id, language: s),
  ];

  // ----- traits -----
  final traits = <CreatureTraitsCompanion>[];
  var traitOrder = 0;
  for (final t in c.traits ?? const <CreatureTrait>[]) {
    if (t.name.trim().isEmpty && t.description.trim().isEmpty) continue;
    traits.add(
      CreatureTraitsCompanion.insert(
        creatureId: id,
        name: t.name.trim(),
        description: t.description.trim(),
        sortOrder: traitOrder++,
      ),
    );
  }

  // ----- actions (sortOrder counts within each kind) -----
  final actions = <CreatureActionsCompanion>[];
  final counters = <String, int>{};
  for (final act in c.actions ?? const <CreatureAction>[]) {
    final kind = _typeToKind[act.type];
    if (kind == null) continue; // lair / blurb are not stored here
    if (act.name.trim().isEmpty && act.description.trim().isEmpty) continue;
    actions.add(
      CreatureActionsCompanion.insert(
        creatureId: id,
        name: act.name.trim(),
        description: act.description.trim(),
        sortOrder: counters.update(kind, (v) => v + 1, ifAbsent: () => 0),
        kind: kind,
      ),
    );
  }

  await db.batch((b) {
    b.insertAll(db.creatureSaves, saves);
    b.insertAll(db.creatureSkills, skills);
    b.insertAll(db.creatureSenses, senses, mode: InsertMode.insertOrIgnore);
    b.insertAll(db.creatureLanguages, languages, mode: InsertMode.insertOrIgnore);
    b.insertAll(db.creatureTraits, traits);
    b.insertAll(db.creatureActions, actions);
  });

  // ----- spellcasting: one block, only if there are spells -----
  final sc = c.spellCasting;
  if (sc == null) return;

  final leveled = sc.spells ?? const <int, SpellLevel>{};
  final innate = sc.innateSpell ?? const <String, List<String>>{};
  final hasSpells =
      leveled.values.any((l) => l.spells.any((s) => s.trim().isNotEmpty)) ||
      innate.values.any((l) => l.any((s) => s.trim().isNotEmpty));
  if (!hasSpells) return;

  final blockId = await db
      .into(db.creatureSpellcastings)
      .insert(
        CreatureSpellcastingsCompanion.insert(
          creatureId: id,
          name: _blank(sc.name) ?? 'Spellcasting',
          headerText: Value(_blank(sc.headerEntries)),
          footerText: Value(_blank(sc.footerEntries)),
          ability: Value(_blank(sc.ability)),
        ),
      );

  final rows = <CreatureSpellsCompanion>[];
  var order = 0;
  for (final level in (leveled.keys.toList()..sort())) {
    final lvl = leveled[level]!;
    for (final s in lvl.spells) {
      if (s.trim().isEmpty) continue;
      rows.add(
        CreatureSpellsCompanion.insert(
          spellcastingId: blockId,
          spellName: s.trim(),
          sortOrder: order++,
          spellLevel: Value(level),
          slots: Value(level == 0 ? null : lvl.slots),
        ),
      );
    }
  }
  for (final e in innate.entries) {
    for (final s in e.value) {
      if (s.trim().isEmpty) continue;
      rows.add(
        CreatureSpellsCompanion.insert(
          spellcastingId: blockId,
          spellName: s.trim(),
          sortOrder: order++,
          uses: Value(e.key),
        ),
      );
    }
  }
  await db.batch((b) => b.insertAll(db.creatureSpells, rows));
}
// Reconstructs full creature domain objects from normalized Drift rows.
//
// Related records are loaded in presentation order and converted to the model
// shape consumed by stat blocks and the creature editor.
import 'package:drift/drift.dart' show CustomExpression, OrderingTerm;

import 'package:gmdex/components/creature_calculations.dart';
import 'package:gmdex/database/database.dart' hide CreatureSkills;
import 'package:gmdex/models/creature.dart';

// Same order your old parseCreature produced.
const _kindToType = <String, ActionType>{
  'action': ActionType.action,
  'legendary': ActionType.legendary,
  'bonus': ActionType.bonusAction,
  'reaction': ActionType.reaction,
  'special': ActionType.special,
  'villain': ActionType.villainAction,
};

/// Loads one creature and its related records into the UI-facing model.
Future<Creature?> loadCreature(AppDatabase db, int id) async {
  final row = await (db.select(
    db.creatures,
  )..where((c) => c.id.equals(id))).getSingleOrNull();
  if (row == null) return null;

  final actionRows =
      await (db.select(db.creatureActions)
            ..where((a) => a.creatureId.equals(id))
            ..orderBy([(a) => OrderingTerm.asc(a.sortOrder)]))
          .get();

  final traitRows =
      await (db.select(db.creatureTraits)
            ..where((t) => t.creatureId.equals(id))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  final saveRows = await (db.select(
    db.creatureSaves,
  )..where((s) => s.creatureId.equals(id))).get();

  final skillRows = await (db.select(
    db.creatureSkills,
  )..where((s) => s.creatureId.equals(id))).get();

  // rowid keeps the order they had in the JSON.
  final senseRows =
      await (db.select(db.creatureSenses)
            ..where((s) => s.creatureId.equals(id))
            ..orderBy([
              (_) => OrderingTerm.asc(CustomExpression<int>('rowid')),
            ]))
          .get();

  final languageRows =
      await (db.select(db.creatureLanguages)
            ..where((l) => l.creatureId.equals(id))
            ..orderBy([
              (_) => OrderingTerm.asc(CustomExpression<int>('rowid')),
            ]))
          .get();

  final blocks =
      await (db.select(db.creatureSpellcastings)
            ..where((s) => s.creatureId.equals(id))
            ..orderBy([(s) => OrderingTerm.asc(s.sortOrder)]))
          .get();
  final spellsByBlock = <int, List<CreatureSpellRow>>{};
  for (final b in blocks) {
    spellsByBlock[b.id] =
        await (db.select(db.creatureSpells)
              ..where((s) => s.spellcastingId.equals(b.id))
              ..orderBy([(s) => OrderingTerm.asc(s.sortOrder)]))
            .get();
  }

  final groupId = row.legendaryGroupId;
  final groupRows = groupId == null
      ? <LegendaryGroupEntryRow>[]
      : await (db.select(db.legendaryGroupEntries)
              ..where((e) => e.groupId.equals(groupId))
              ..orderBy([(e) => OrderingTerm.asc(e.sortOrder)]))
            .get();
  final lairRows = groupRows.where((e) => e.section == 'lair').toList();
  final regionalRows = groupRows.where((e) => e.section == 'regional').toList();

  // Several notes can exist per creature; the model holds one, so use the latest.
  final note =
      await (db.select(db.notes)
            ..where((n) => n.creatureId.equals(id))
            ..orderBy([(n) => OrderingTerm.desc(n.updatedAt)])
            ..limit(1))
          .getSingleOrNull();

  // ----- saves -----
  final saves = {for (final s in saveRows) s.ability: s.bonus};

  // ----- skills -----
  final skills = {for (final s in skillRows) s.skill: s.bonus};
  String? sk(String key) {
    final v = skills[key];
    return v == null ? null : _signed(v);
  }

  bool hasSkill(String key) => skills.containsKey(key);

  // ----- actions (grouped by kind, then in file order) -----
  final actions = <CreatureAction>[
    for (final entry in _kindToType.entries)
      for (final a in actionRows.where((a) => a.kind == entry.key))
        CreatureAction(
          name: a.name,
          description: a.description,
          type: entry.value,
        ),
    if (lairRows.isNotEmpty)
      CreatureAction(
        name: '',
        description: _renderEntries(lairRows),
        type: ActionType.lair,
      ),
  ];

  final crText = row.challengeRating ?? '0';

  return Creature(
    id: row.id,
    name: row.name,
    size: row.size,
    type: row.type,
    alignment: row.alignment,
    armorClass: CreatureArmorClass(
      ac: row.armorClass ?? 0,
      type: row.armorClassType ?? 'Natural',
    ),
    hitPoints: row.hitPoints ?? 0,
    hitPointFormula: row.hitPointFormula ?? '',
    challengeRating: CreatureCR(
      cr: crText,
      lair: row.challengeRatingLair,
      coven: row.challengeRatingCoven,
      xpOverride: row.xpOverride,
    ),
    proficiencyBonus: proficiencyBonusCalc(
      tryParseFraction(crText) ?? 0,
    ).toDouble(),
    speed: CreatureSpeed(
      walk: row.speedWalk,
      fly: row.speedFly,
      climb: row.speedClimb,
      swim: row.speedSwim,
      burrow: row.speedBurrow,
    ),
    abilityScores: CreatureAbilityScores(
      strength: row.strength,
      strengthModifier: _mod(row.strength),
      dexterity: row.dexterity,
      dexterityModifier: _mod(row.dexterity),
      constitution: row.constitution,
      constitutionModifier: _mod(row.constitution),
      intelligence: row.intelligence,
      intelligenceModifier: _mod(row.intelligence),
      wisdom: row.wisdom,
      wisdomModifier: _mod(row.wisdom),
      charisma: row.charisma,
      charismaModifier: _mod(row.charisma),
    ),
    savingThrows: CreatureSavingThrows(
      strength: saves['str'],
      dexterity: saves['dex'],
      constitution: saves['con'],
      intelligence: saves['int'],
      wisdom: saves['wis'],
      charisma: saves['cha'],
      isStrProf: saves.containsKey('str'),
      isDexProf: saves.containsKey('dex'),
      isConProf: saves.containsKey('con'),
      isIntProf: saves.containsKey('int'),
      isWisProf: saves.containsKey('wis'),
      isChaProf: saves.containsKey('cha'),
    ),
    skills: CreatureSkills(
      athletics: sk('athletics'),
      isAthleticsProf: hasSkill('athletics'),
      acrobatics: sk('acrobatics'),
      isAcrobaticsProf: hasSkill('acrobatics'),
      sleightOfHand: sk('sleightOfHand'),
      isSleightOfHandProf: hasSkill('sleightOfHand'),
      stealth: sk('stealth'),
      isStealthProf: hasSkill('stealth'),
      arcana: sk('arcana'),
      isArcanaProf: hasSkill('arcana'),
      history: sk('history'),
      isHistoryProf: hasSkill('history'),
      investigation: sk('investigation'),
      isInvestigationProf: hasSkill('investigation'),
      nature: sk('nature'),
      isNatureProf: hasSkill('nature'),
      religion: sk('religion'),
      isReligionProf: hasSkill('religion'),
      animalHandling: sk('animalHandling'),
      isAnimalHandlingProf: hasSkill('animalHandling'),
      insight: sk('insight'),
      isInsightProf: hasSkill('insight'),
      medicine: sk('medicine'),
      isMedicineProf: hasSkill('medicine'),
      perception: sk('perception'),
      isPerceptionProf: hasSkill('perception'),
      survival: sk('survival'),
      isSurvivalProf: hasSkill('survival'),
      deception: sk('deception'),
      isDeceptionProf: hasSkill('deception'),
      intimidation: sk('intimidation'),
      isIntimidationProf: hasSkill('intimidation'),
      persuasion: sk('persuasion'),
      isPersuasionProf: hasSkill('persuasion'),
      performance: sk('performance'),
      isPerformanceProf: hasSkill('performance'),
    ),
    senses: [
      for (final sense in senseRows) sense.sense,
      if (row.passivePerception != null)
        'passive Perception ${row.passivePerception}',
    ].join(', '),
    languages: languageRows.map((l) => l.language).join(', '),
    spellCasting: _buildSpellcasting(blocks, spellsByBlock),
    actions: actions,
    traits: [
      for (final t in traitRows)
        CreatureTrait(name: t.name, description: t.description),
    ],
    regionalEffect: _buildRegional(regionalRows),
    notes: note?.body,
  );
}

// ---------------------------------------------------------------------------

int _mod(int score) => ((score - 10) / 2).floor();

String _signed(int v) => v >= 0 ? '+$v' : '$v';

CreatureSpellcasting? _buildSpellcasting(
  List<CreatureSpellcastingRow> blocks,
  Map<int, List<CreatureSpellRow>> spellsByBlock,
) {
  if (blocks.isEmpty) return null;

  final byLevel = <int, List<String>>{};
  final slots = <int, int>{};
  final innate = <String, List<String>>{};

  for (final block in blocks) {
    // e.g. the Archmage's at-will list is hidden because its header already
    // mentions those spells.
    final hidden = (block.hiddenUses ?? '')
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toSet();

    for (final s in spellsByBlock[block.id] ?? const <CreatureSpellRow>[]) {
      final level = s.spellLevel;
      final uses = s.uses;
      if (level != null) {
        (byLevel[level] ??= []).add(s.spellName);
        if (s.slots != null) slots[level] = s.slots!;
      } else if (uses != null && !hidden.contains(uses)) {
        (innate[uses] ??= []).add(s.spellName);
      }
    }
  }

  // The model holds one header/footer, so use the block with leveled spells
  // if there is one (same rule parseCreature used), otherwise the first.
  final primary = blocks.firstWhere(
    (b) => (spellsByBlock[b.id] ?? const <CreatureSpellRow>[]).any(
      (s) => s.spellLevel != null,
    ),
    orElse: () => blocks.first,
  );

  final levels = byLevel.keys.toList()..sort();

  return CreatureSpellcasting(
    name: primary.name,
    headerEntries: primary.headerText ?? '',
    footerEntries: primary.footerText,
    ability: primary.ability ?? '',
    spells: byLevel.isEmpty
        ? null
        : {
            for (final l in levels)
              l: SpellLevel(slots: slots[l] ?? 0, spells: byLevel[l]!),
          },
    innateSpell: innate.isEmpty ? null : innate,
  );
}

CreatureRegionalEffect? _buildRegional(List<LegendaryGroupEntryRow> rows) {
  if (rows.isEmpty) return null;
  final texts = rows.where((r) => r.kind == 'text').toList();
  return CreatureRegionalEffect(
    blurb: texts.isEmpty ? '' : texts.first.body,
    bulletPoints: [
      for (final r in rows.where((r) => r.kind == 'bullet'))
        r.title == null ? r.body : '${r.title}. ${r.body}',
    ],
    blurbEnd: texts.length > 1 ? texts.last.body : null,
  );
}

String _renderEntries(List<LegendaryGroupEntryRow> rows) {
  final buf = StringBuffer();
  String? prevKind;
  for (final r in rows) {
    final body = r.title == null ? r.body : '${r.title}. ${r.body}';
    if (prevKind != null) {
      buf.write(prevKind == 'bullet' && r.kind == 'bullet' ? '\n' : '\n\n');
    }
    buf.write(r.kind == 'bullet' ? '• $body' : body);
    prevKind = r.kind;
  }
  return buf.toString();
}

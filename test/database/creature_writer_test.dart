import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmdex/database/creature_writer.dart';
import 'package:gmdex/database/database.dart';
import 'package:gmdex/models/creature_draft.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('creates and updates creature damage defenses', () async {
    final creature = _draft(
      name: 'Editable Creature',
      damageVulnerable: 'fire',
      damageResist: 'cold',
      damageImmune: 'poison',
      conditionImmune: 'charmed',
    ).toCreature();

    final id = await saveCreature(db, creature);
    var row = await (db.select(
      db.creatures,
    )..where((creature) => creature.id.equals(id))).getSingle();

    expect(row.damageVulnerabilities, 'fire');
    expect(row.damageResistances, 'cold');
    expect(row.damageImmunities, 'poison');
    expect(row.conditionImmunities, 'charmed');

    final editedCreature = _draft(
      name: 'Editable Creature',
      damageVulnerable: 'acid',
      damageResist: 'cold, fire',
      damageImmune: '',
      conditionImmune: 'frightened',
    ).toCreature();
    await saveCreature(db, editedCreature, existingId: id);
    row = await (db.select(
      db.creatures,
    )..where((creature) => creature.id.equals(id))).getSingle();

    expect(row.damageVulnerabilities, 'acid');
    expect(row.damageResistances, 'cold, fire');
    expect(row.damageImmunities, isNull);
    expect(row.conditionImmunities, 'frightened');
  });
}

CreatureDraft _draft({
  required String name,
  required String? damageVulnerable,
  required String? damageResist,
  required String? damageImmune,
  required String? conditionImmune,
}) {
  return CreatureDraft(
    name: name,
    armorClass: CreatureArmorClassDraft(ac: 12),
    challengeRating: CreatureCRDraft(cr: '1'),
    speed: CreatureSpeedDraft(),
    abilityScores: CreatureAbilityScoresDraft(),
    savingThrows: CreatureSavingThrowsDraft(
      isStrProf: false,
      isDexProf: false,
      isConProf: false,
      isIntProf: false,
      isWisProf: false,
      isChaProf: false,
    ),
    damageVulnerable: damageVulnerable,
    damageResist: damageResist,
    damageImmune: damageImmune,
    conditionImmune: conditionImmune,
  );
}

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmdex/database/database.dart' hide CreatureSkills;
import 'package:gmdex/database/notes_writer.dart';
import 'package:gmdex/models/creature.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('inserts trimmed notes for the supplied creature id', () async {
    final id = await db
        .into(db.creatures)
        .insert(CreaturesCompanion.insert(name: 'Owl'));

    await saveNotes(db, _creature(), existingId: id, notes: '  Field notes  ');

    final saved = await db.select(db.notes).getSingle();
    expect(saved.creatureId, id);
    expect(saved.body, 'Field notes');
  });

  test(
    'uses the creature id and notes when no overrides are provided',
    () async {
      final id = await db
          .into(db.creatures)
          .insert(CreaturesCompanion.insert(name: 'Owl'));

      await saveNotes(db, _creature(id: id, notes: 'Tracks nearby'));

      final saved = await db.select(db.notes).getSingle();
      expect(saved.creatureId, id);
      expect(saved.body, 'Tracks nearby');
    },
  );
}

Creature _creature({int? id, String? notes}) => Creature(
  name: 'Owl',
  armorClass: const CreatureArmorClass(ac: 11, type: ''),
  hitPoints: 1,
  challengeRating: const CreatureCR(cr: '0'),
  speed: const CreatureSpeed(),
  abilityScores: const CreatureAbilityScores(
    strength: 10,
    strengthModifier: 0,
    dexterity: 10,
    dexterityModifier: 0,
    constitution: 10,
    constitutionModifier: 0,
    intelligence: 10,
    intelligenceModifier: 0,
    wisdom: 10,
    wisdomModifier: 0,
    charisma: 10,
    charismaModifier: 0,
  ),
  savingThrows: const CreatureSavingThrows(
    strength: null,
    dexterity: null,
    constitution: null,
    intelligence: null,
    wisdom: null,
    charisma: null,
  ),
  id: id,
  notes: notes,
);

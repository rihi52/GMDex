import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmdex/database/database.dart';
import 'package:gmdex/database/spell_writer.dart';
import 'package:gmdex/models/spell.dart';
import 'package:gmdex/models/spell_draft.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('creates a custom spell and persists editor fields', () async {
    final id = await saveSpell(db, _draft(name: 'New Spell'));
    final row = await (db.select(
      db.spells,
    )..where((spell) => spell.id.equals(id))).getSingle();

    expect(row.source, 'Custom');
    expect(row.name, 'New Spell');
    expect(row.level, 2);
    expect(Spell.fromRow(row).castingTime, '1 action');
    expect(Spell.fromRow(row).description, 'A useful spell.');
  });

  test(
    'saves and updates ritual without losing other spell metadata',
    () async {
      final id = await db
          .into(db.spells)
          .insert(
            SpellsCompanion.insert(
              name: 'Ritual Spell',
              source: 'PHB',
              level: 2,
              school: 'A',
              data: jsonEncode({
                'meta': {'ritual': true, 'other': 'keep'},
              }),
            ),
          );

      await saveSpell(db, _draft(name: 'Ritual Spell'), existingId: id);
      var row = await (db.select(
        db.spells,
      )..where((spell) => spell.id.equals(id))).getSingle();
      expect(Spell.fromRow(row).isRitual, isFalse);
      expect(jsonDecode(row.data)['meta'], {'other': 'keep'});

      await saveSpell(
        db,
        _draft(name: 'Ritual Spell', isRitual: true),
        existingId: id,
      );
      row = await (db.select(
        db.spells,
      )..where((spell) => spell.id.equals(id))).getSingle();
      expect(Spell.fromRow(row).isRitual, isTrue);
      expect(jsonDecode(row.data)['meta'], {'other': 'keep', 'ritual': true});
    },
  );

  test('creates ritual and nonritual spells from their drafts', () async {
    final ritualId = await saveSpell(
      db,
      _draft(name: 'Ritual', isRitual: true),
    );
    final ordinaryId = await saveSpell(db, _draft(name: 'Ordinary'));
    final rows = await db.select(db.spells).get();
    expect(
      Spell.fromRow(rows.singleWhere((row) => row.id == ritualId)).isRitual,
      isTrue,
    );
    expect(
      Spell.fromRow(rows.singleWhere((row) => row.id == ordinaryId)).isRitual,
      isFalse,
    );
  });

  test(
    'does not overwrite invalid imported metadata when enabling ritual',
    () async {
      final id = await db
          .into(db.spells)
          .insert(
            SpellsCompanion.insert(
              name: 'Invalid Metadata',
              source: 'PHB',
              level: 2,
              school: 'A',
              data: '{"meta":"unexpected"}',
            ),
          );

      await expectLater(
        saveSpell(
          db,
          _draft(name: 'Invalid Metadata', isRitual: true),
          existingId: id,
        ),
        throwsFormatException,
      );
      final row = await (db.select(
        db.spells,
      )..where((spell) => spell.id.equals(id))).getSingle();
      expect(jsonDecode(row.data)['meta'], 'unexpected');
    },
  );

  test(
    'updates in place, retaining source, notes, and unsupported data',
    () async {
      final id = await db
          .into(db.spells)
          .insert(
            SpellsCompanion.insert(
              name: 'Old Spell',
              source: 'TCE',
              level: 1,
              school: 'E',
              notes: const Value('Keep this note'),
              data: jsonEncode({
                'name': 'Old Spell',
                'source': 'TCE',
                'level': 1,
                'school': 'E',
                'time': [
                  {'number': 1, 'unit': 'action'},
                ],
                'extraMetadata': 'preserve',
              }),
            ),
          );

      await saveSpell(db, _draft(name: 'Updated Spell'), existingId: id);
      final row = await (db.select(
        db.spells,
      )..where((spell) => spell.id.equals(id))).getSingle();
      final data = jsonDecode(row.data) as Map<String, dynamic>;

      expect(row.source, 'TCE');
      expect(row.name, 'Updated Spell');
      expect(row.notes, 'Keep this note');
      expect(data['extraMetadata'], 'preserve');
      expect(data['time'], isNotNull);
      expect(Spell.fromRow(row).duration, '1 minute');
    },
  );

  test(
    'rejects duplicate names and allows copies only with a new name',
    () async {
      await saveSpell(db, _draft(name: 'Unique Spell'));

      await expectLater(
        saveSpell(db, _draft(name: 'Unique Spell')),
        throwsA(isA<SpellNameTaken>()),
      );

      final id = await saveSpell(db, _draft(name: 'Unique Spell (Copy)'));
      final copy = await (db.select(
        db.spells,
      )..where((spell) => spell.id.equals(id))).getSingle();
      expect(copy.source, 'Custom');
    },
  );
}

SpellDraft _draft({required String name, bool isRitual = false}) => SpellDraft(
  name: name,
  level: 2,
  isRitual: isRitual,
  school: 'A',
  castingTime: '1 action',
  range: '60 feet',
  components: 'V, S',
  duration: '1 minute',
  description: 'A useful spell.',
  higherLevel: '',
);

import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmdex/database/bestiary_exporter.dart';
import 'package:gmdex/database/bestiary_importer.dart';
import 'package:gmdex/database/database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test(
    'exports creatures in bestiary JSON structure and can reimport',
    () async {
      const source = '''
      {
        "monster": [
          {
            "name": "Export Test Beast",
            "source": "TST",
            "page": 12,
            "size": ["M"],
            "type": {"type": "beast", "tags": ["test"]},
            "alignment": ["N", "G"],
            "ac": [{"ac": 13, "from": ["natural armor"]}],
            "hp": {"average": 9, "formula": "2d8"},
            "speed": {"walk": 30},
            "str": 12,
            "dex": 14,
            "con": 10,
            "int": 3,
            "wis": 12,
            "cha": 6,
            "save": {"dex": "+4"},
            "skill": {"perception": "+3"},
            "passive": 13,
            "languages": ["Common"],
            "cr": "1/4",
            "trait": [{"name": "Keen Sight", "entries": ["It sees well."]}],
            "action": [{"name": "Claw", "entries": ["It claws."]}],
            "environment": ["forest"]
          }
        ]
      }
    ''';
      await importBestiaryJson(db, source);

      final exported = jsonDecode(await exportBestiaryJson(db));
      expect(exported.keys, ['monster']);
      expect(exported['monster'], hasLength(1));
      final monster = exported['monster'][0] as Map<String, dynamic>;
      expect(monster['name'], 'Export Test Beast');
      expect(monster['size'], ['M']);
      expect(monster['type'], {
        'type': 'beast',
        'tags': ['test'],
      });
      expect(monster['alignment'], ['N', 'G']);
      expect(monster['cr'], '1/4');
      expect(monster['trait'][0]['entries'], ['It sees well.']);
      expect(monster['action'][0]['entries'], ['It claws.']);

      await (db.delete(db.creatures)).go();
      final result = await importBestiaryJson(db, jsonEncode(exported));
      expect(result.imported, 1);
      final reimported = await db.select(db.creatures).getSingle();
      expect(reimported.name, 'Export Test Beast');
      expect(reimported.challengeRating, '1/4');
    },
  );

  test('preserves special AC text and special HP values on export', () async {
    const source = '''
      {
        "monster": [
          {
            "name": "Special Export Beast",
            "source": "TST",
            "ac": [{"special": "13 plus PB (natural armor)"}],
            "hp": {
              "special": "7 + seven times caregiver's level"
            }
          }
        ]
      }
    ''';
    await importBestiaryJson(db, source);

    final exported = jsonDecode(await exportBestiaryJson(db));
    final monster =
        (exported['monster'] as List).single as Map<String, dynamic>;
    expect(monster['ac'], [
      {'special': '13 plus PB (natural armor)'},
    ]);
    expect(monster['hp'], {
      'average': 7,
      'formula': '+ seven times caregiver\'s level',
    });

    await (db.delete(db.creatures)).go();
    await importBestiaryJson(db, jsonEncode(exported));
    final reimported = await db.select(db.creatures).getSingle();
    expect(reimported.armorClass, 13);
    expect(reimported.armorClassType, 'plus PB (natural armor)');
    expect(reimported.hitPoints, 7);
    expect(reimported.hitPointFormula, '+ seven times caregiver\'s level');
  });
}

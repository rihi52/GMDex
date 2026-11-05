import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmdex/database/bestiary_importer.dart';
import 'package:gmdex/database/database.dart';
import 'package:gmdex/database/creature_mapper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('bundled import seeds only the filtered SRD creatures', () async {
    final result = await importBestiary(db);
    final creatures = await db.select(db.creatures).get();
    final groups = await db.select(db.legendaryGroups).get();

    expect(result.imported, greaterThan(0));
    expect(creatures, isNotEmpty);
    expect(creatures.every((creature) => creature.source == 'SRD'), isTrue);
    expect(groups, isEmpty);
  });

  test('imports creatures from bestiary JSON and skips duplicates', () async {
    const json = '''
      {
        "monster": [
          {
            "name": "Test Creature",
            "source": "TST",
            "size": ["M"],
            "type": "beast",
            "alignment": ["U"],
            "ac": [12],
            "hp": {"average": 5, "formula": "1d8+1"},
            "speed": {"walk": 30},
            "str": 10,
            "dex": 12,
            "con": 11,
            "int": 3,
            "wis": 10,
            "cha": 5
          }
        ]
      }
    ''';

    final first = await importBestiaryJson(db, json);
    final second = await importBestiaryJson(db, json);
    final creatures = await db.select(db.creatures).get();

    expect(first.imported, 1);
    expect(first.skipped, 0);
    expect(second.imported, 0);
    expect(second.skipped, 1);
    expect(creatures, hasLength(1));
    expect(creatures.single.name, 'Test Creature');
    expect(creatures.single.hitPoints, 5);
  });

  test('skips creatures without form-required fields', () async {
    const json = '''
      {
        "monster": [
          {"name": "", "ac": [12], "hp": {"average": 5}},
          {"name": "Missing armor class", "hp": {"average": 5}},
          {"name": "Missing hit points", "ac": [12]},
          {
            "name": "Valid Creature",
            "ac": [{"ac": 12}],
            "hp": {"average": 5}
          }
        ]
      }
    ''';

    final result = await importBestiaryJson(db, json);
    final creatures = await db.select(db.creatures).get();

    expect(result.imported, 1);
    expect(result.skipped, 3);
    expect(creatures, hasLength(1));
    expect(creatures.single.name, 'Valid Creature');
  });

  test(
    'MM import updates SRD creatures and preserves other same-name sources',
    () async {
      const srdJson = '''
      {
        "monster": [
          {
            "name": "Shared Creature",
            "source": "SRD",
            "ac": [10],
            "hp": {"average": 5}
          },
          {
            "name": "Different Source",
            "source": "Custom",
            "ac": [11],
            "hp": {"average": 6}
          }
        ]
      }
    ''';
      const mmJson = '''
      {
        "monster": [
          {
            "name": "Shared Creature",
            "source": "MM",
            "ac": [15],
            "hp": {"average": 20}
          },
          {
            "name": "Different Source",
            "source": "MM",
            "ac": [12],
            "hp": {"average": 8}
          }
        ]
      }
    ''';

      await importBestiaryJson(db, srdJson);
      final firstImport = await importBestiaryJson(db, mmJson);
      final secondImport = await importBestiaryJson(db, mmJson);
      final creatures = await db.select(db.creatures).get();
      final sharedCreature = creatures.singleWhere(
        (creature) => creature.name == 'Shared Creature',
      );
      final differentSources = creatures
          .where((creature) => creature.name == 'Different Source')
          .toList();

      expect(firstImport.imported, 2);
      expect(firstImport.skipped, 0);
      expect(secondImport.imported, 0);
      expect(secondImport.skipped, 2);
      expect(creatures, hasLength(3));
      expect(sharedCreature.source, 'srd, mm');
      expect(sharedCreature.armorClass, 15);
      expect(sharedCreature.hitPoints, 20);
      expect(differentSources, hasLength(2));
      expect(differentSources.map((creature) => creature.source).toSet(), {
        'Custom',
        'MM',
      });
    },
  );

  test('formats armor class item sources without source codes', () async {
    const json = '''
      {
        "monster": [
          {
            "name": "Goblin",
            "source": "MM",
            "hp": {"average": 7, "formula": "2d6"},
            "ac": [
              {
                "ac": 15,
                "from": [
                  "{@item leather armor|phb}",
                  "{@item shield|dmg}"
                ]
              }
            ]
          }
        ]
      }
    ''';

    await importBestiaryJson(db, json);
    final goblin = await db.select(db.creatures).getSingle();

    expect(goblin.armorClassType, '(leather armor, shield)');
  });

  test('splits special HP and armor class values', () async {
    const hpExpression =
        "7 + seven times caregiver's level (number of d8 Hit Dice equal to their caregiver's level)";
    const wordNumberHp =
        'Eight times their level (number of d10 Hit Dice equal to their level)';
    const json =
        '''
      {
        "monster": [
          {
            "name": "Special AC Creature",
            "source": "TST",
            "ac": [{"special": "13 plus PB (natural armor)"}],
            "hp": {"special": "$hpExpression"}
          },
          {
            "name": "Word Number HP Creature",
            "source": "TST",
            "ac": [12],
            "hp": {"special": "$wordNumberHp"}
          },
          {
            "name": "Numeric HP Creature",
            "source": "TST",
            "ac": [12],
            "hp": {"special": "8"}
          },
          {
            "name": "Empty Special AC Creature",
            "source": "TST",
            "ac": [{"special": "13 ()"}],
            "hp": {"special": "6"}
          }
        ]
      }
    ''';

    final result = await importBestiaryJson(db, json);
    final creatures = await db.select(db.creatures).get();
    final specialAcCreature = creatures.singleWhere(
      (creature) => creature.name == 'Special AC Creature',
    );
    final wordNumberCreature = creatures.singleWhere(
      (creature) => creature.name == 'Word Number HP Creature',
    );
    final numericCreature = creatures.singleWhere(
      (creature) => creature.name == 'Numeric HP Creature',
    );
    final emptySpecialAcCreature = creatures.singleWhere(
      (creature) => creature.name == 'Empty Special AC Creature',
    );

    expect(result.imported, 4);
    expect(result.skipped, 0);
    expect(specialAcCreature.armorClass, 13);
    expect(specialAcCreature.armorClassType, 'plus PB (natural armor)');
    expect(specialAcCreature.hitPoints, 7);
    expect(
      specialAcCreature.hitPointFormula,
      '+ seven times caregiver\'s level (number of d8 Hit Dice equal to their caregiver\'s level)',
    );
    expect(wordNumberCreature.hitPoints, 8);
    expect(
      wordNumberCreature.hitPointFormula,
      'times their level (number of d10 Hit Dice equal to their level)',
    );
    expect(numericCreature.hitPoints, 8);
    expect(numericCreature.hitPointFormula, isNull);
    expect(emptySpecialAcCreature.armorClass, 13);
    expect(emptySpecialAcCreature.armorClassType, isNull);
  });

  test('rejects JSON without a monster array', () async {
    await expectLater(
      importBestiaryJson(db, '{"creature": []}'),
      throwsFormatException,
    );
    expect(await db.select(db.creatures).get(), isEmpty);
  });

  test('imports legendarygroups.json without a bestiary file', () async {
    const json = '''
      {
        "legendaryGroup": [
          {
            "name": "Custom Dragon",
            "source": "HOMEBREW",
            "lairActions": ["The ground shakes."],
            "regionalEffects": ["Storms gather nearby."]
          }
        ]
      }
    ''';

    final first = await importLegendaryGroupsJson(db, json);
    final second = await importLegendaryGroupsJson(db, json);
    final groups = await db.select(db.legendaryGroups).get();
    final entries = await db.select(db.legendaryGroupEntries).get();

    expect(first.imported, 1);
    expect(first.skipped, 0);
    expect(second.imported, 0);
    expect(second.skipped, 1);
    expect(groups, hasLength(1));
    expect(entries, hasLength(2));
    expect(await db.select(db.creatures).get(), isEmpty);
  });

  test(
    'links creature references when groups are imported afterward',
    () async {
      const monsterJson = '''
      {
        "monster": [
          {
            "name": "Aboleth",
            "source": "MM",
            "ac": [17],
            "hp": {"average": 135},
            "legendaryGroup": {"name": "Aboleth", "source": "MM"}
          }
        ]
      }
    ''';
      const groupsJson = '''
      {
        "legendaryGroup": [
          {
            "name": "Aboleth",
            "source": "MM",
            "lairActions": ["The aboleth uses a lair action."],
            "regionalEffects": [
              {"type": "list", "items": ["Water within one mile is altered."]}
            ]
          }
        ]
      }
    ''';

      await importBestiaryJson(db, monsterJson);
      final importedGroup = await importLegendaryGroupsJson(db, groupsJson);
      final abolethRow = await db.select(db.creatures).getSingle();
      final aboleth = await loadCreature(db, abolethRow.id);

      expect(importedGroup.imported, 1);
      expect(abolethRow.legendaryGroupId, isNotNull);
      expect(aboleth?.actions?.last.description, contains('lair action'));
      expect(
        aboleth?.regionalEffect?.bulletPoints.single,
        'Water within one mile is altered.',
      );
    },
  );

  test(
    'links groups imported before the full MM updates SRD creatures',
    () async {
      const groupsJson = '''
      {
        "legendaryGroup": [
          {
            "name": "Aboleth",
            "source": "MM",
            "lairActions": ["The aboleth uses a lair action."],
            "regionalEffects": [
              {"type": "list", "items": ["Water within one mile is altered."]}
            ]
          }
        ]
      }
    ''';
      const mmJson = '''
      {
        "monster": [
          {
            "name": "Aboleth",
            "source": "MM",
            "ac": [17],
            "hp": {"average": 135},
            "legendaryGroup": {"name": "Aboleth", "source": "MM"}
          }
        ]
      }
    ''';

      await importBestiary(db);
      await importLegendaryGroupsJson(db, groupsJson);
      await importBestiaryJson(db, mmJson);

      final abolethRow = (await db.select(db.creatures).get()).singleWhere(
        (creature) => creature.name == 'Aboleth',
      );
      final aboleth = await loadCreature(db, abolethRow.id);

      expect(abolethRow.source, 'srd, mm');
      expect(abolethRow.legendaryGroupId, isNotNull);
      expect(aboleth?.actions?.last.description, contains('lair action'));
      expect(
        aboleth?.regionalEffect?.bulletPoints.single,
        'Water within one mile is altered.',
      );
    },
  );

  test('links bundled Aboleth to its unique-name group', () async {
    const groupsJson = '''
      {
        "legendaryGroup": [
          {
            "name": "Aboleth",
            "source": "MM",
            "lairActions": ["The aboleth uses a lair action."],
            "regionalEffects": [
              {"type": "list", "items": ["Water within one mile is altered."]}
            ]
          }
        ]
      }
    ''';

    await importBestiary(db);
    await importLegendaryGroupsJson(db, groupsJson);

    final abolethRow = (await db.select(db.creatures).get()).singleWhere(
      (creature) => creature.name == 'Aboleth',
    );
    final aboleth = await loadCreature(db, abolethRow.id);

    expect(abolethRow.source, 'SRD');
    expect(abolethRow.legendaryGroupId, isNotNull);
    expect(aboleth?.actions?.last.description, contains('lair action'));
    expect(
      aboleth?.regionalEffect?.bulletPoints.single,
      'Water within one mile is altered.',
    );
  });

  test(
    'user JSON can still add legendary groups and linked creatures',
    () async {
      const json = '''
      {
        "legendaryGroup": [
          {
            "name": "Custom Dragon",
            "source": "HOMEBREW",
            "lairActions": ["The ground shakes."]
          }
        ],
        "monster": [
          {
            "name": "Custom Dragon",
            "source": "HOMEBREW",
            "ac": [18],
            "hp": {"average": 100},
            "legendaryGroup": {
              "name": "Custom Dragon",
              "source": "HOMEBREW"
            }
          }
        ]
      }
    ''';

      await importBestiaryJson(db, json);

      final group = await db.select(db.legendaryGroups).getSingle();
      final creature = await db.select(db.creatures).getSingle();
      expect(group.name, 'Custom Dragon');
      expect(creature.legendaryGroupId, group.id);
      expect(await db.select(db.legendaryGroupEntries).get(), hasLength(1));
    },
  );

  test('rejects JSON larger than the import size limit', () async {
    final oversizedJson = ' '.padRight(maxBestiaryImportSizeBytes + 1);

    await expectLater(
      importBestiaryJson(db, oversizedJson),
      throwsFormatException,
    );
    expect(await db.select(db.creatures).get(), isEmpty);
  });
}

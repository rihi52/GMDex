import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';

import 'package:gmdex/database/database.dart';
import 'package:gmdex/pages/home_page.dart';
import 'package:gmdex/theme/apptheme.dart';
import 'package:gmdex/database/bestiary_importer.dart';

late AppDatabase _database;
AppDatabase get database => _database;

Future<Directory> _databaseDirectory() async {
  final inCodespaces = Platform.environment['CODESPACES'] == 'true';

  final Directory dir = inCodespaces
      ? Directory('/workspaces/GMDex/dev_data')
      : await getApplicationDocumentsDirectory();

  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }
  return dir;
}

Future<AppDatabase> _openDatabase() async {
  final dir = await _databaseDirectory();
  final file = File(p.join(dir.path, 'GMDex.db'));
  return AppDatabase(NativeDatabase(file));
}

Future<void> _initializeDatabase() async {
  if (kIsWeb) {
    print('Database initialization skipped on web platform');
    return;
  }

  try {
    _database = await _openDatabase();

    // Only seed if the table is empty so we don't duplicate on every launch
    final existing = await _database.select(_database.players).get();
    if (existing.isEmpty) {
      await _database.batch((b) {
        b.insertAll(_database.players, [
          PlayersCompanion.insert(
            pName: 'Ravi',
            pClass: 'Rogue',
            pArmorClass: Value(15),
            pHitPoints: Value(38),
            pLevel: Value(5),
            pOriginalCampaign: Value('Finndalin'),
          ),
          PlayersCompanion.insert(
            pName: 'Finn',
            pClass: 'Bard',
            pArmorClass: Value(15),
            pHitPoints: Value(40),
            pLevel: Value(5),
            pOriginalCampaign: Value('Finndalin'),
          ),
          PlayersCompanion.insert(
            pName: 'Pax',
            pClass: 'Fighter',
            pArmorClass: Value(19),
            pHitPoints: Value(45),
            pLevel: Value(5),
            pOriginalCampaign: Value('Finndalin'),
          ),
          PlayersCompanion.insert(
            pName: 'Theon',
            pClass: 'Fighter',
            pArmorClass: Value(18),
            pHitPoints: Value(42),
            pLevel: Value(5),
            pOriginalCampaign: Value('Finndalin'),
          ),
        ]);
      });
      print('Database seeded with initial player');
    }

    final hasCreatures = (await (_database.select(
      _database.creatures,
    )..limit(1)).get()).isNotEmpty;
    if (!hasCreatures) {
      final result = await importBestiary(_database);
      print('Bestiary import: $result');
      for (final f in result.failed.take(10)) {
        print('  failed: $f');
      }
    }

    final allItems = await _database.select(_database.players).get();
    print('Players in database: $allItems');
  } catch (e) {
    print('Database initialization failed: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeDatabase();

  await windowManager.ensureInitialized();
  await windowManager.setMinimumSize(const Size(1346, 682));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.dark(),
      home: const MyHomePage(),
    );
  }
}

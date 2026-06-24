import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:window_manager/window_manager.dart';
import 'package:moonscribe/theme/apptheme.dart';
import 'package:moonscribe/pages/home_page.dart';
import 'package:drift/drift.dart';
import 'package:moonscribe/database/database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'package:drift/native.dart'
    if (dart.library.html) 'package:moonscribe/stubs/native_stub.dart';

late AppDatabase _database;

AppDatabase get database => _database;

Future<AppDatabase> _openDatabase() async {
  late final Directory dbDir;

  if (Platform.isLinux) {
    // Works for both native Linux desktop and Codespaces (also Linux).
    // Storing inside the workspace folder survives Codespace rebuilds.
    // On a real desktop this falls back to a sensible home-relative path.
    final workspacePath = '/workspaces/moonscribe/dev_data';
    final workspaceDir = Directory(workspacePath);

    if (workspaceDir.existsSync()) {
      // Running in Codespaces
      dbDir = workspaceDir;
    } else {
      // Running on a real Linux desktop
      dbDir = await getApplicationDocumentsDirectory();
    }
  } else {
    // macOS / Windows
    dbDir = await getApplicationDocumentsDirectory();
  }

  if (!dbDir.existsSync()) {
    dbDir.createSync(recursive: true);
  }

  final file = File(p.join(dbDir.path, 'moonscribe.db'));
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
      await _database.into(_database.players).insert(
        PlayersCompanion.insert(
          pName: 'Ravi',
          pClass: 'Rogue',
          pArmorClass: Value(15),
          pHitPoints: Value(38),
          pLevel: Value(5),
          pOriginalCampaign: Value('Finndalin'),
        ),
      );
      await _database.into(_database.players).insert(
        PlayersCompanion.insert(
          pName: 'Finn',
          pClass: 'Bard',
          pArmorClass: Value(15),
          pHitPoints: Value(40),
          pLevel: Value(5),
          pOriginalCampaign: Value('Finndalin'),
        ),
      );
      await _database.into(_database.players).insert(
        PlayersCompanion.insert(
          pName: 'Pax',
          pClass: 'Fighter',
          pArmorClass: Value(19),
          pHitPoints: Value(45),
          pLevel: Value(5),
          pOriginalCampaign: Value('Finndalin'),
        ),
      );
      await _database.into(_database.players).insert(
        PlayersCompanion.insert(
          pName: 'Theon',
          pClass: 'Fighter',
          pArmorClass: Value(18),
          pHitPoints: Value(42),
          pLevel: Value(5),
          pOriginalCampaign: Value('Finndalin'),
        ),
      );
      print('Database seeded with initial player');
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
  await windowManager.setMinimumSize(const Size(1360, 800));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.dark(),
      home: const MyHomePage(),
    );
  }
}

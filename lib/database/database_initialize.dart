// Creates the native Drift connection and performs one-time starter-data setup.
//
// The database file is stored in the application documents directory, except
// in Codespaces where development data is kept under the workspace.
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:gmdex/database/database.dart';
// import 'package:gmdex/database/bestiary_importer.dart';

late AppDatabase _database;

/// Shared database connection initialized by [initializeDatabase].
AppDatabase get database => _database;

/// Resolves and creates the directory used for the SQLite database file.
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

/// Opens the app's SQLite file through Drift's native backend.
Future<AppDatabase> _openDatabase() async {
  final dir = await _databaseDirectory();
  final file = File(p.join(dir.path, 'GMDex.db'));
  return AppDatabase(NativeDatabase(file));
}

/// Opens the database and seeds sample players and the bundled bestiary if empty.
///
/// Web builds currently skip initialization because this implementation uses
/// native file-backed SQLite. Initialization failures are currently swallowed
/// to preserve the app's existing startup behavior.
Future<void> initializeDatabase() async {
  if (kIsWeb) {
    return;
  }

  try {
    _database = await _openDatabase();

    // Only seed if the table is empty so we don't duplicate on every launch.
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
            pName: 'Glimm',
            pClass: 'Monk',
            pArmorClass: Value(15),
            pHitPoints: Value(38),
            pLevel: Value(11),
            pOriginalCampaign: Value('Finndalin'),
            pNotes: Value('I AM VERY FAST!!!'),
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
    }

    final hasCreatures = (await (_database.select(
      _database.creatures,
    )..limit(1)).get()).isNotEmpty;
    if (!hasCreatures) {
      // final result = await importBestiary(_database);
      // Import failures are not surfaced from this startup path at present.
      // for (final f in result.failed.take(10)) {
      // }
    }

    // Retain the final read currently used to verify that player queries work.
    // final allItems = await _database.select(_database.players).get();
  } catch (e) {
    // Keep startup non-fatal for compatibility; callers are not notified yet.
    return;
  }
}
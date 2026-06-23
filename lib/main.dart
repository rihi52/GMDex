import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
//import 'package:window_manager/window_manager.dart';
import 'package:moonscribe/theme/apptheme.dart';
import 'package:moonscribe/pages/home_page.dart';
import 'package:drift/drift.dart';
import 'package:moonscribe/database/database.dart';

// Only import native database on non-web platforms
import 'package:drift/native.dart'
    if (dart.library.html) 'package:moonscribe/stubs/native_stub.dart';

late AppDatabase _database;

AppDatabase get database => _database;

// void main() {
//   runApp(const MyApp());
// }

Future<void> _initializeDatabase() async {
  if (kIsWeb) {
    print('Database initialization skipped on web platform');
    return;
  }

  try {
    _database = AppDatabase(NativeDatabase.memory());

    await _database
        .into(_database.players)
        .insert(
          PlayersCompanion.insert(
            pName: 'Ravi',
            pClass: 'Rogue',
            pArmorClass: Value(15),
            pHitPoints: Value(38),
            pLevel: Value(5),
            pOriginalCampaign: Value('Finndalin'),
          ),
        );
    List<Player> allItems = await _database.select(_database.players).get();

    print('items in database: $allItems');
  } catch (e) {
    print('Database initialization failed: $e');
  }

  // if (kIsWeb) {
  //   print('Database initialization skipped on web platform');
  //   return;
  // }

  // try {
  //   _database = AppDatabase(NativeDatabase.memory());

  //   // Your existing code...
  // } catch (e) {
  //   print('Database initialization failed: $e');
  // }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeDatabase();

  // Comment this out to run on web or mobile
  //await windowManager.ensureInitialized();

  // Comment this out to run on web or mobile
  //await windowManager.setMinimumSize(const Size(1360, 800));

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

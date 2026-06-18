import 'package:flutter/material.dart';
//import 'package:window_manager/window_manager.dart';
import 'package:moonscribe/theme/apptheme.dart';
import 'package:moonscribe/pages/home_page.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:moonscribe/database/database.dart';

// void main() {
//   runApp(const MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase(NativeDatabase.memory());

  await database
      .into(database.players)
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
  List<Player> allItems = await database.select(database.players).get();

  print('items in database: $allItems');

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

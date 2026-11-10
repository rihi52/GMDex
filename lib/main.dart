// Application entry point and top-level route/theme configuration.
//
// Database initialization runs before the widget tree is mounted so pages
// can safely use the shared database as soon as they are built.
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:gmdex/pages/creatures_page.dart';
import 'package:gmdex/pages/encounters_page.dart';
import 'package:gmdex/pages/home_page.dart';
import 'package:gmdex/pages/players_page.dart';
import 'package:gmdex/pages/spells_page.dart';
import 'package:gmdex/pages/settings.dart' show SettingsPage;
import 'package:gmdex/theme/apptheme.dart';
import 'package:gmdex/database/database_initialize.dart';
import 'package:gmdex/models/difficulty_calculator_ruleset.dart';
import 'package:gmdex/models/turn_highlight_preference.dart';
import 'package:gmdex/pages/player_face_combat.dart';
import 'package:gmdex/platform/multiview_app.dart';

void main(List<String> args) async {
  // Flutter services must be initialized before asynchronous startup work.
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await initializeDatabase();
  await loadDifficultyCalculatorRuleset();
  await loadTurnHighlightPreference();

  runGmdexApp(home: (_, _) => const MyApp(), fallback: const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Named routes provide the shared destinations used by the page sidebars.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.dark(),
      home: const MyHomePage(),
      routes: {
        '/home': (context) => const MyHomePage(),
        '/players': (context) => const PlayersPage(),
        '/creatures': (context) => const CreaturesPage(),
        '/spells': (context) => const SpellsPage(),
        '/encounters': (context) => const EncountersPage(),
        '/settings': (context) => const SettingsPage(),
        '/player_combat': (context) => const PlayerFacingCombatPage(),
      },
    );
  }
}

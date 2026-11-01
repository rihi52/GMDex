// Landing screen that routes into the encounter, player, and creature tools.
//
// The logo switches between compact and wide artwork using the available
// layout width so the home page works in narrow windows and on desktops.
import 'package:flutter/material.dart';
import 'package:gmdex/components/responsive_layout.dart';
import 'package:gmdex/pages/encounters_page.dart';
import 'package:gmdex/pages/players_page.dart';
import 'package:gmdex/pages/creatures_page.dart';
import 'package:gmdex/pages/settings.dart';

/// Landing screen that routes into the encounter, player, and creature tools.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const List<String> buttons = [
    'Encounters',
    'Players',
    'Bestiary',
    'Settings',
  ];

  final List<Widget> pages = [
    const EncountersPage(),
    const PlayersPage(),
    const CreaturesPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use the width of this page, which may be smaller than the display.
        final isNarrow = ResponsiveLayout.isNarrow(
          constraints.maxWidth,
          breakpoint: ResponsiveBreakpoints.navigation,
        );

        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (isNarrow)
                  Image.asset(
                    'assets/images/GMDex.png',
                    width: 250,
                    height: 250,
                    fit: BoxFit.contain, // Optional scaling behavior
                  ),
                if (!isNarrow)
                  Image.asset(
                    'assets/images/GMDex_wide.png',
                    width: 500,
                    height: 200,
                    fit: BoxFit.contain, // Optional scaling behavior
                  ),
                // Text('GMDex', style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 20),

                ...List.generate(
                  buttons.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(250, 55),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => pages[index]),
                      ),
                      child: Text(buttons[index]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

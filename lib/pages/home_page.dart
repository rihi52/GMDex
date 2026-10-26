import 'package:flutter/material.dart';
import 'package:gmdex/pages/combat_page.dart';
import 'package:gmdex/pages/encounters_page.dart';
import 'package:gmdex/pages/players_page.dart';
import 'package:gmdex/pages/creatures_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const List<String> buttons = [
    'Combat',
    'Encounters',
    'Players',
    'Creatures',
  ];

  final List<Widget> pages = [
    const StartCombatPage(),
    const EncountersPage(),
    const PlayersPage(),
    const CreaturesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'GMDex',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),

            ...List.generate(
              buttons.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: Size(250, 55)),
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
  }
}

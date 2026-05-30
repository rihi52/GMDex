import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme:  AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 68, 22, 148),
          foregroundColor: Colors.black,
          elevation: 4,
          titleTextStyle: GoogleFonts.metamorphous(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 68, 22, 148),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            minimumSize: const Size(250, 55),
            textStyle: GoogleFonts.metamorphous(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        textTheme: TextTheme(
          headlineLarge: GoogleFonts.cinzelDecorative(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
          headlineMedium: GoogleFonts.cinzelDecorative(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
          bodyMedium: GoogleFonts.metamorphous(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  static const List<String> buttons = [
    'Start Combat',
    'Encounters',
    'Players',
    'Creatures',
  ];

  final List<Widget> pages = [
    const StartCombatPage(),
    const EncountersPage(),
    const PlayersPage(),
    const CreaturesPage(),
    // Add other pages here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'MOONSCRIBE',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),

            ...List.generate(
              buttons.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => pages[index]),
                    );
                  },
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

class StartCombatPage extends StatefulWidget {
  const StartCombatPage({super.key});

  @override
  State<StartCombatPage> createState() => _StartCombatPageState();
}

class _StartCombatPageState extends State<StartCombatPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StartCombat'),
      ),
      body: const Center(
        child: Text('StartCombat Page'),
      ),
    );
  }
}

class EncountersPage extends StatefulWidget {
  const EncountersPage({super.key});

  @override
  State<EncountersPage> createState() => _EncountersPageState();
}

class _EncountersPageState extends State<EncountersPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encounters'),
      ),
      body: const Center(
        child: Text('Encounters Page'),
      ),
    );
  }
}

class PlayersPage extends StatefulWidget {
  const PlayersPage({super.key});

  @override
  State<PlayersPage> createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Players'),
      ),
      body: const Center(
        child: Text('Players Page'),
      ),
    );
  }
}

class CreaturesPage extends StatefulWidget {
  const CreaturesPage({super.key});

  @override
  State<CreaturesPage> createState() => _CreaturesPageState();
}

class _CreaturesPageState extends State<CreaturesPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creatures'),
      ),
      body: const Center(
        child: Text('Creatures Page'),
      ),
    );
  }
}

import 'package:flutter/material.dart';

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
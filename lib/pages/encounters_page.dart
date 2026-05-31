import 'package:flutter/material.dart';

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
import 'package:flutter/material.dart';
import '../theme/apptheme.dart';
import '../components/creature_card.dart';
import '../components/statblock.dart';
import '../load/read.dart';

class CreaturesPage extends StatefulWidget {
  const CreaturesPage({super.key});

  @override
  State<CreaturesPage> createState() => _CreaturesPageState();
}

class _CreaturesPageState extends State<CreaturesPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 250,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(color: AppColors.primary, width: 1),
              ),
            ),
            child: Column(
              spacing: 8,
              children: [
                ListTile(
                  selected: false,
                  title: const Text('Return'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  selected: _selectedIndex == 0,
                  title: const Text('Browse'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: _selectedIndex == 0
                          ? AppColors.hoverGrey
                          : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  onTap: () => setState(() => _selectedIndex = 0),
                ),
                ListTile(
                  selected: _selectedIndex == 1,
                  title: const Text('Create'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: _selectedIndex == 1
                          ? AppColors.hoverGrey
                          : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  onTap: () => setState(() => _selectedIndex = 1),
                ),
              ],
            ),
          ),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return const BrowseCreatureWidget();
      case 1:
        return const Center(child: Text('Create Creature'));
      default:
        return const BrowseCreatureWidget();
    }
  }
}

class BrowseCreatureWidget extends StatefulWidget {
  const BrowseCreatureWidget({super.key});

  @override
  State<BrowseCreatureWidget> createState() => _BrowseCreatureWidgetState();
}

class _BrowseCreatureWidgetState extends State<BrowseCreatureWidget> {
  final creatures = [
    (
      name: 'Aboleth',
      type: 'Humanoid',
      size: 'Small',
      cr: '1/4',
      source: 'Monster Manual',
    ),
    (
      name: 'Orc',
      type: 'Humanoid',
      size: 'Medium',
      cr: '1/2',
      source: 'Monster Manual',
    ),
    (
      name: 'Young Red Dragon',
      type: 'Dragon',
      size: 'Large',
      cr: '10',
      source: 'Monster Manual',
    ),
    (
      name: 'Glin',
      type: 'Humanoid',
      size: 'Small',
      cr: '1/4',
      source: 'Monster Manual',
    ),
    (
      name: 'rc',
      type: 'Humanoid',
      size: 'Medium',
      cr: '1/2',
      source: 'Monster Manual',
    ),
    (
      name: ' Red Dragon',
      type: 'Dragon',
      size: 'Large',
      cr: '10',
      source: 'Monster Manual',
    ),
    (
      name: 'Gob',
      type: 'Humanoid',
      size: 'Small',
      cr: '1/4',
      source: 'Monster Manual',
    ),
    (
      name: 'Or',
      type: 'Humanoid',
      size: 'Medium',
      cr: '1/2',
      source: 'Monster Manual',
    ),
    (
      name: 'Young Dragon',
      type: 'Dragon',
      size: 'Large',
      cr: '10',
      source: 'Monster Manual',
    ),
  ];

  Creature? monster;

  List<dynamic> _allMonsters = [];
  Map<String, dynamic> _legendaryGroups = {};
  Creature? _selectedCreature;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final monstersJson = await loadMonsters();
    final legendaryGroups = await loadLegendaryGroups();
    setState(() {
      _allMonsters = monstersJson['monster'] as List;
      _legendaryGroups = legendaryGroups;
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   loadMonster();
  // }

  // Future<void> loadMonster() async {
  //   try {
  //     final result = await test();
  //     setState(() => monster = result);
  //   } catch (e) {
  //     debugPrint('Failed to load monster: $e');
  //     // Optionally set an error state here
  //   }
  // }

  // int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Implement filter functionality here
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              // Implement sort functionality here
            },
          ),
        ],
        title: SizedBox(
          width: 400,
          height: 40,
          child: SearchBar(
            hintText: 'Search Creatures',
            onChanged: (value) {
              // Implement search functionality here
            },
          ),
        ),
      ),
      body: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: SizedBox(
              width: 350,
              child: ListView.builder(
                padding: const EdgeInsets.only(right: 8),
                itemCount: _allMonsters.length,
                itemBuilder: (context, index) {
                  final data = _allMonsters[index];

                  return SizedBox(
                    height: 100,
                    child: CreatureCard(
                      name: data['name'] ?? '',
                      type: data['type'] is String ? data['type'] : (data['type']?['type'] ?? ''),
                      size: sizeNames[data['size']?[0]] ?? '',
                      cr: data['cr'] is Map
                        ? data['cr']['cr']?.toString() ?? '0'
                        : data['cr']?.toString() ?? '0',
                      source: data['source'] ?? '',
                      selected: _selectedIndex == index,
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                          _selectedCreature = parseCreature(data, _legendaryGroups);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          Container(width: 8),
          Expanded(
            flex: 7,
            child: Container(
              alignment: Alignment.topCenter,
              child: _selectedCreature != null
                ? CreatureStatBlock(creature: _selectedCreature!)
                : SizedBox.shrink(),
            )
          ),
        ],
      ),
    ),
  );
}
}
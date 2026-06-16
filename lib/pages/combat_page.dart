import 'package:flutter/material.dart';
import 'package:moonscribe/theme/apptheme.dart';
import '../components/creature_card.dart';
import '../components/player_card.dart';
import 'package:moonscribe/load/read.dart';

class StartCombatPage extends StatefulWidget {
  const StartCombatPage({super.key});

  @override
  State<StartCombatPage> createState() => _StartCombatPageState();
}

class _StartCombatPageState extends State<StartCombatPage> {
  List<dynamic> _allMonsters = [];
  List<dynamic> _allMonsterFilter = [];
  int? _selectedIndex;
  String? searchTerm;

  final players = [
    (name: 'Ravi', pClass: 'Rogue', level: 1, originalCampaign: 'Finndalin'),
    (name: 'Finn', pClass: 'Bard', level: 2, originalCampaign: 'Finndalin'),
    (name: 'Pax', pClass: 'Fighter', level: 3, originalCampaign: 'Finndalin'),
    (name: 'Theon', pClass: 'Fighter', level: 1, originalCampaign: 'Finndalin'),
    (
      name: 'Amalagh',
      pClass: 'Barbarian',
      level: 2,
      originalCampaign: 'Finndalin',
    ),
    (
      name: 'Folkini',
      pClass: 'Soceror',
      level: 3,
      originalCampaign: 'Finndalin',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final monstersJson = await loadMonsters();
    setState(() {
      _allMonsters = monstersJson['monster'] as List;
      _allMonsterFilter = _allMonsters;
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleMonsters = (searchTerm == null || searchTerm!.isEmpty)
        ? _allMonsters
        : _allMonsters
              .where(
                // monster represents a monster being put into the anonymous function to check if it contains searchTerm. its added to the list if it does
                (monster) => monster['name'].toString().toLowerCase().contains(
                  searchTerm!.toLowerCase(),
                ),
              )
              .toList();
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
          child: SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                onChanged: (value) {
                  setState(() {
                    searchTerm = value;
                  });
                },
              );
            },
            suggestionsBuilder:
                (BuildContext context, SearchController controller) {
                  return _allMonsterFilter
                      .map<Widget>(
                        (monster) => Text(
                          monster['name'] ?? '',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      )
                      .toList();
                },
          ),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                /* Cards for Combatants */
                Container(
                  padding: const EdgeInsets.only(
                    bottom: AppSpacing.spacingSmall,
                    top: AppSpacing.spacingSmall,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.primary, width: 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            /* Statblock */
            flex: 4,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    bottom: AppSpacing.spacingSmall,
                    top: AppSpacing.spacingSmall,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.primary, width: 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: SizedBox(
              width: 350,
              child: ListView.builder(
                padding: const EdgeInsets.only(right: 8),
                itemCount: visibleMonsters.length,
                itemBuilder: (context, index) {
                  final data = visibleMonsters[index];
                  return SizedBox(
                    height: 100,
                    child: CreatureCard(
                      name: data['name'] ?? '',
                      type: data['type'] is String
                          ? data['type']
                          : (data['type']?['type'] ?? ''),
                      size: sizeNames[data['size']?[0]] ?? '',
                      cr: data['cr'] is Map
                          ? data['cr']['cr']?.toString() ?? '0'
                          : data['cr']?.toString() ?? '0',
                      source: data['source'] ?? '',
                      selected: _selectedIndex == index,
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

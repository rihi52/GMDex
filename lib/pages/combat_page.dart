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
  int? _selectedPlayerIndex;
  String? playerSearchTerm;
  String? creatureSearchTerm;

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
    final visibleMonsters = (creatureSearchTerm == null || creatureSearchTerm!.isEmpty)
        ? _allMonsters
        : _allMonsters
              .where(
                // monster represents a monster being put into the anonymous function to check if it contains creatureSearchTerm. its added to the list if it does
                (monster) => monster['name'].toString().toLowerCase().contains(
                  creatureSearchTerm!.toLowerCase(),
                ),
              )
              .toList();
    
    final visiblePlayers = (playerSearchTerm == null || playerSearchTerm!.isEmpty)
        ? players
        : players
              .where(
                // monster represents a monster being put into the anonymous function to check if it contains playerSearchTerm. its added to the list if it does
                (player) => player.name.toString().toLowerCase().contains(
                  playerSearchTerm!.toLowerCase(),
                ),
              )
              .toList();
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        //automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 40,
              width: 350,
              child: SearchAnchor(
                builder: (BuildContext context, SearchController controller) {
                  return SearchBar(
                    hintText: 'Search Players',
                    onChanged: (value) {
                      setState(() {
                        playerSearchTerm = value;
                      });
                    },
                  );
                },
                suggestionsBuilder:
                    (BuildContext context, SearchController controller) {
                      return visiblePlayers
                          .map<Widget>(
                            (player) => Text(
                              player.name,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          )
                          .toList();
                    },
              ),
            ),
            SizedBox(
              height: 40,
              width: 350,
              child: SearchAnchor(
                builder: (BuildContext context, SearchController controller) {
                  return SearchBar(
                    hintText: 'Search Creatures',
                    onChanged: (value) {
                      setState(() {
                        creatureSearchTerm = value;
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
          ],
        ),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.only(
                left: AppSpacing.spacingMedium,
              ),
              width: 350,
              child: ListView.builder(
                padding: const EdgeInsets.only(right: 8),
                itemCount: visiblePlayers.length,
                itemBuilder: (context, index) {
                  final data = visiblePlayers[index];
                  return SizedBox(
                    height: 100,
                    child: PlayerCard(
                      name: data.name,
                      pClass: data.pClass,
                      level: data.level,
                      selected: _selectedPlayerIndex == index,
                      onTap: () {
                        setState(() {
                          _selectedPlayerIndex = index;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            /* Statblock */
            flex: 5,
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
            flex: 2,
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

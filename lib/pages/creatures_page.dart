import 'package:flutter/material.dart';
import 'package:moonscribe/theme/apptheme.dart';
import 'package:moonscribe/components/creature_card.dart';
import 'package:moonscribe/components/statblock.dart';
import 'package:moonscribe/database/read.dart';

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
  Creature? monster;

  List<dynamic> _allMonsters = [];
  List<dynamic> _allMonsterFilter = [];
  Map<String, dynamic> _legendaryGroups = {};
  Creature? _selectedCreature;
  int? _selectedIndex;
  String? searchTerm;

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
                            _selectedCreature = parseCreature(
                              data,
                              _legendaryGroups,
                            );
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

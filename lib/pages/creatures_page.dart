import 'package:flutter/material.dart';
import 'package:moonscribe/models/creature.dart';
import 'package:moonscribe/theme/apptheme.dart';
import 'package:moonscribe/components/creature_card.dart';
import 'package:moonscribe/components/statblock.dart';
import 'package:moonscribe/components/statblock_edit.dart';
import 'package:moonscribe/database/read.dart';
import 'dart:math' show min;

class CreaturesPage extends StatefulWidget {
  const CreaturesPage({super.key});

  @override
  State<CreaturesPage> createState() => _CreaturesPageState();
}

class _CreaturesPageState extends State<CreaturesPage> {
  static const double _breakpoint = 700;
  int _selectedIndex = 0;

  static const _titles = ['Browse', 'Create'];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= _breakpoint;

        if (isWide) {
          return Scaffold(
            body: Row(
              children: [
                Container(
                  width: 175,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(color: AppColors.primary, width: 1),
                    ),
                  ),
                  child: _navItems(inDrawer: false),
                ),
                Expanded(child: _buildContent()),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            // The hamburger icon is added automatically because a drawer exists
            title: Text(_titles[_selectedIndex]),
          ),
          drawer: Drawer(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _navItems(inDrawer: true),
              ),
            ),
          ),
          body: _buildContent(),
        );
      },
    );
  }

  Widget _navItems({required bool inDrawer}) {
    // In the drawer, close it after a selection.
    void closeDrawerIfNeeded() {
      if (inDrawer) Navigator.of(context).pop();
    }

    ShapeBorder shapeFor(int index) => RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(
        color: _selectedIndex == index
            ? AppColors.hoverGrey
            : Colors.transparent,
        width: 1,
      ),
    );

    return Column(
      spacing: 8,
      children: [
        ListTile(
          selected: false,
          title: const Text('Return'),
          onTap: () {
            closeDrawerIfNeeded(); // closes the drawer
            Navigator.of(context).pop(); // leaves the page
          },
        ),
        ListTile(
          selected: _selectedIndex == 0,
          title: const Text('Browse'),
          shape: shapeFor(0),
          onTap: () {
            setState(() => _selectedIndex = 0);
            closeDrawerIfNeeded();
          },
        ),
        ListTile(
          selected: _selectedIndex == 1,
          title: const Text('Create'),
          shape: shapeFor(1),
          onTap: () {
            setState(() => _selectedIndex = 1);
            closeDrawerIfNeeded();
          },
        ),
      ],
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return const BrowseCreatureWidget();
      case 1:
        return const CreateCreatureWidget();
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
  static const double _breakpoint = 900;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= _breakpoint;

        final monsterList = ListView.builder(
          padding: const EdgeInsets.only(right: AppSpacing.spacingMedium),
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
                    _selectedCreature = parseCreature(data, _legendaryGroups);
                  });
                  if (!isWide) _scaffoldKey.currentState?.openEndDrawer();
                },
              ),
            );
          },
        );

        final statBlock = _selectedCreature != null
            ? SingleChildScrollView(
                child: CreatureStatBlock(creature: _selectedCreature!),
              )
            : const SizedBox.shrink();

        return Scaffold(
          key: _scaffoldKey,
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
          endDrawer: isWide
              ? null
              : Drawer(
                  width: min(constraints.maxWidth, 520),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: statBlock,
                    ), // closes Padding(
                  ), // closes SafeArea(
                ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: isWide
                ? Row(
                    children: [
                      Expanded(flex: 3, child: monsterList),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 7,
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: statBlock,
                        ),
                      ),
                    ],
                  )
                : monsterList,
          ),
        );
      },
    );
  }
}

class CreateCreatureWidget extends StatefulWidget {
  const CreateCreatureWidget({super.key});

  @override
  State<CreateCreatureWidget> createState() => _CreateCreatureWidgetState();
}

class _CreateCreatureWidgetState extends State<CreateCreatureWidget> {
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
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [Expanded(child: StatblockEditorForm())]),
      ),
    );
  }
}

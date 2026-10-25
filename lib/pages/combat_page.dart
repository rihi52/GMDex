import 'package:flutter/material.dart';
import 'package:moonscribe/theme/apptheme.dart';
import 'package:moonscribe/models/creature.dart';
import 'package:moonscribe/components/creature_card.dart';
import 'package:moonscribe/components/player_card.dart';
import 'package:moonscribe/models/combat.dart';
import 'package:moonscribe/database/read.dart';
import 'package:moonscribe/components/combatant_card.dart';

class StartCombatPage extends StatefulWidget {
  const StartCombatPage({super.key});

  @override
  State<StartCombatPage> createState() => _StartCombatPageState();
}

class _StartCombatPageState extends State<StartCombatPage> {
  static const double _breakpoint = 900;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _playerSearchController = SearchController();
  final _creatureSearchController = SearchController();

  List<dynamic> _allMonsters = [];
  List<dynamic> _allMonsterFilter = [];
  int? _selectedIndex;
  Creature? _selectedCreature;
  Map<String, dynamic> _legendaryGroups = {};
  String? playerSearchTerm;
  String? creatureSearchTerm;
  late Encounter currentEncounter;

  double searchBarWidth = 300;
  double buttonWidth = 75;
  double buttonHeight = 40;
  double drawerWidth = 380;

  final players = [
    (
      name: 'Ravi',
      pClass: 'Rogue',
      level: 1,
      originalCampaign: 'Finndalin',
      hitPoints: 20,
    ),
    (
      name: 'Finn',
      pClass: 'Bard',
      level: 2,
      originalCampaign: 'Finndalin',
      hitPoints: 21,
    ),
    (
      name: 'Pax',
      pClass: 'Fighter',
      level: 3,
      originalCampaign: 'Finndalin',
      hitPoints: 22,
    ),
    (
      name: 'Theon',
      pClass: 'Fighter',
      level: 1,
      originalCampaign: 'Finndalin',
      hitPoints: 23,
    ),
    (
      name: 'Amalagh',
      pClass: 'Barbarian',
      level: 2,
      originalCampaign: 'Finndalin',
      hitPoints: 24,
    ),
    (
      name: 'Folkini',
      pClass: 'Soceror',
      level: 3,
      originalCampaign: 'Finndalin',
      hitPoints: 25,
    ),
  ];

  @override
  void dispose() {
    _playerSearchController.dispose();
    _creatureSearchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    currentEncounter = Encounter(
      name: 'Encounter 1',
      currentTurnIndex: 0,
      combatants: [],
    );
    _loadData();
  }

  Future<void> _loadData() async {
    final monstersJson = await loadMonsters();
    final legendaryGroups = await loadLegendaryGroups();
    setState(() {
      _allMonsters = monstersJson['monster'] as List;
      _allMonsterFilter = _allMonsters;
      _legendaryGroups = legendaryGroups;
    });
  }

  void _start() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
  }

  // ---------- Shared pieces used by both layouts ----------

  List<dynamic> get _visibleMonsters =>
      (creatureSearchTerm == null || creatureSearchTerm!.isEmpty)
      ? _allMonsters
      : _allMonsters
            .where(
              (monster) => monster['name'].toString().toLowerCase().contains(
                creatureSearchTerm!.toLowerCase(),
              ),
            )
            .toList();

  List<
    ({
      String name,
      String pClass,
      int level,
      String originalCampaign,
      int hitPoints,
    })
  >
  get _visiblePlayers => (playerSearchTerm == null || playerSearchTerm!.isEmpty)
      ? players
      : players
            .where(
              (player) => player.name.toLowerCase().contains(
                playerSearchTerm!.toLowerCase(),
              ),
            )
            .toList();

  Widget _playerList(EdgeInsets padding) {
    final visiblePlayers = _visiblePlayers;
    return ListView.builder(
      padding: padding,
      itemCount: visiblePlayers.length,
      itemBuilder: (context, index) {
        final data = visiblePlayers[index];
        return SizedBox(
          height: 100,
          child: PlayerCard(
            name: data.name,
            pClass: data.pClass,
            level: data.level,
            onTap: () {
              setState(() {
                if (!currentEncounter.combatants.any(
                  (combatant) => combatant.name == data.name,
                )) {
                  currentEncounter.combatants.add(
                    Combatant(
                      name: data.name,
                      isPlayer: true,
                      currentHitPoints: data.hitPoints,
                      maxHitPoints: data.hitPoints,
                      initiative: 0,
                      quantity: 1,
                    ),
                  );
                }
              });
            },
          ),
        );
      },
    );
  }

  Widget _creatureList(EdgeInsets padding) {
    final visibleMonsters = _visibleMonsters;
    return ListView.builder(
      padding: padding,
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
                if (!currentEncounter.combatants.any(
                  (combatant) => combatant.name == _selectedCreature!.name,
                )) {
                  currentEncounter.combatants.add(
                    Combatant(
                      name: _selectedCreature!.name,
                      isPlayer: false,
                      currentHitPoints: _selectedCreature!.hitPoints,
                      maxHitPoints: _selectedCreature!.hitPoints,
                      initiative: 0,
                      quantity: 1,
                    ),
                  );
                }
              });
            },
          ),
        );
      },
    );
  }

  Widget _encounterList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacingMedium),
      itemCount: currentEncounter.combatants.length,
      itemBuilder: (context, index) {
        final combatant = currentEncounter.combatants[index];
        return CombatantCard(
          key: ObjectKey(combatant),
          combatant: currentEncounter.combatants[index],
          onDelete: () => setState( ()=> currentEncounter.combatants.remove(combatant),),
        );
      },
    );
  }

  Widget _actionButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: buttonWidth,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: Size(buttonWidth, buttonHeight),
          textStyle: Theme.of(context).textTheme.bodySmall,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.spacingSmall),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _searchBar(
    String hint,
    SearchController searchController,
    ValueChanged<String> onChanged,
    List<Widget> Function() suggestions,
  ) {
    return SizedBox(
      height: 40,
      width: searchBarWidth,
      child: SearchAnchor(
        searchController: searchController,
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(controller: controller, hintText: hint, onChanged: onChanged);
        },
        suggestionsBuilder:
            (BuildContext context, SearchController controller) {
              return suggestions();
            },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return constraints.maxWidth >= _breakpoint
            ? _buildWide(context)
            : _buildNarrow(context);
      },
    );
  }

  // ---------- Wide: the original three-column layout ----------

  Widget _buildWide(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _searchBar(
              'Search Players',
              _playerSearchController,
              (value) => setState(() => playerSearchTerm = value),
              () => _visiblePlayers
                  .map<Widget>(
                    (player) => Text(
                      player.name,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  )
                  .toList(),
            ),
            _actionButton('Save', _save),
            _actionButton('Start', _start),
            _searchBar(
              'Search Creatures',
              _creatureSearchController,
              (value) => setState(() => creatureSearchTerm = value),
              () => _allMonsterFilter
                  .map<Widget>(
                    (monster) => Text(
                      monster['name'] ?? '',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: _playerList(
              const EdgeInsets.only(left: AppSpacing.spacingMedium, right: 8),
            ),
          ),
          Expanded(
            flex: 4,
            child: Form(key: _formKey, child: _encounterList()),
          ),
          Expanded(
            flex: 3,
            child: _creatureList(
              const EdgeInsets.symmetric(horizontal: AppSpacing.spacingMedium),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Narrow: encounter is the main screen, lists are drawers ----------

  Widget _searchDrawer({
    required String hint,
    required TextEditingController controller,
    required ValueChanged<String> onSearch,
    required Widget list,
  }) {
    return Drawer(
      width: drawerWidth,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.spacingMedium),
              child: SizedBox(
                height: 40,
                child: SearchBar(
                  controller: controller,
                  hintText: hint,
                  onChanged: onSearch,
                ),
              ),
            ),
            Expanded(child: list),
          ],
        ),
      ),
    );
  }

  Widget _buildNarrow(BuildContext context) {
    const listPadding = EdgeInsets.symmetric(
      horizontal: AppSpacing.spacingMedium,
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        // With a drawer present, Scaffold would replace the back button
        // with a hamburger, so the back button is set explicitly.
        leading: Navigator.canPop(context) ? const BackButton() : null,
        title: Text(currentEncounter.name),
        actions: [
          IconButton(
            tooltip: 'Players',
            icon: const Icon(Icons.people),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          IconButton(
            tooltip: 'Creatures',
            icon: const Icon(Icons.pets),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
          const SizedBox(width: AppSpacing.spacingSmall),
          _actionButton('Save', _save),
          const SizedBox(width: AppSpacing.spacingSmall),
          _actionButton('Start', _start),
          const SizedBox(width: AppSpacing.spacingMedium),
        ],
      ),
      drawer: _searchDrawer(
        hint: 'Search Players',
        controller: _playerSearchController,
        onSearch: (value) => setState(() => playerSearchTerm = value),
        list: _playerList(listPadding),
      ),
      endDrawer: _searchDrawer(
        hint: 'Search Creatures',
        controller: _creatureSearchController,
        onSearch: (value) => setState(() => creatureSearchTerm = value),
        list: _creatureList(listPadding),
      ),
      body: Form(
        key: _formKey,
        child: currentEncounter.combatants.isEmpty
            ? Center(
                child: Text(
                  'No combatants yet.\nUse the buttons above to add players or creatures.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              )
            : _encounterList(),
      ),
    );
  }
}

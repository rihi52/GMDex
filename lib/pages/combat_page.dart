// Encounter assembly screen for selecting participants and setting initiative.
//
// It loads available players and creatures, validates encounter fields, and
// routes the assembled domain model to either persistence or live combat.
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show OrderingTerm;
import 'package:gmdex/theme/apptheme.dart';
import 'package:gmdex/components/creature_card.dart';
import 'package:gmdex/components/player_card.dart';
import 'package:gmdex/components/responsive_layout.dart';
import 'package:gmdex/models/combat.dart';
import 'package:gmdex/components/combatant_card.dart';
import 'package:gmdex/database/database.dart';
import 'package:gmdex/database/encounter_writer.dart';
import 'package:gmdex/database/database_initialize.dart';
import 'package:gmdex/pages/combat_run_page.dart';
import 'package:gmdex/components/difficulty_calculator.dart';
import 'package:gmdex/components/creature_calculations.dart'
    show tryParseFraction;
import 'package:gmdex/models/creature.dart' show crToXp;
import 'package:gmdex/models/difficulty_calculator_ruleset.dart';

/// Starts a new encounter or edits/copies the supplied saved encounter.
class EncounterBuildPage extends StatefulWidget {
  const EncounterBuildPage({super.key, this.encounter, this.isCopy = false});

  final Encounter? encounter;
  final bool isCopy;

  @override
  State<EncounterBuildPage> createState() => _EncounterBuildPageState();
}

class _EncounterBuildPageState extends State<EncounterBuildPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _playerSearchController = SearchController();
  final _creatureSearchController = SearchController();

  List<PlayerRow> _allPlayers = [];
  List<CreatureRow> _allCreatures = [];
  int? _selectedId; // creature id, so the highlight survives filtering
  String? playerSearchTerm;
  String? creatureSearchTerm;
  String _typeFilter = '';
  String _sizeFilter = '';
  String _sourceFilter = '';
  String _crMin = '';
  String _crMax = '';
  late Encounter currentEncounter;

  double searchBarWidth = 275;
  double buttonWidth = 75;
  double buttonHeight = 40;
  double drawerWidth = 380;

  @override
  void dispose() {
    _playerSearchController.dispose();
    _creatureSearchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Copying deliberately drops the database id so save creates a new record.
    final initialEncounter = widget.encounter;
    currentEncounter = initialEncounter == null
        ? Encounter(name: 'Encounter 1', currentTurnIndex: 0, combatants: [])
        : Encounter(
            id: widget.isCopy ? null : initialEncounter.id,
            name: widget.isCopy
                ? '${initialEncounter.name} (Copy)'
                : initialEncounter.name,
            currentTurnIndex: initialEncounter.currentTurnIndex,
            combatants: List.of(initialEncounter.combatants),
            encounterNotes: initialEncounter.encounterNotes,
            hasStarted: widget.isCopy ? false : initialEncounter.hasStarted,
          );
    _loadData();
  }

  Future<void> _loadData() async {
    // Keep both participant catalogs available for the builder's search lists.
    final playerRows = await (database.select(
      database.players,
    )..orderBy([(p) => OrderingTerm.asc(p.pName)])).get();
    final creatureRows = await (database.select(
      database.creatures,
    )..orderBy([(c) => OrderingTerm.asc(c.name)])).get();
    if (!mounted) return;
    setState(() {
      _allPlayers = playerRows;
      _allCreatures = creatureRows;
      _resetStaleCreatureFilters();
    });
  }

  int get _activeCreatureFilterCount =>
      [
        _typeFilter,
        _sizeFilter,
        _sourceFilter,
      ].where((filter) => filter.isNotEmpty).length +
      (_crMin.isNotEmpty || _crMax.isNotEmpty ? 1 : 0);

  String _baseType(String? raw) =>
      (raw ?? '').split('(').first.trim().toLowerCase();

  String _capitalize(String value) =>
      value.isEmpty ? value : value[0].toUpperCase() + value.substring(1);

  double? _crValue(String? cr) {
    if (cr == null || cr.isEmpty) return null;
    if (cr.contains('/')) {
      final parts = cr.split('/');
      if (parts.length != 2) return null;
      final numerator = double.tryParse(parts[0]);
      final denominator = double.tryParse(parts[1]);
      if (numerator == null || denominator == null || denominator == 0) {
        return null;
      }
      return numerator / denominator;
    }
    return double.tryParse(cr);
  }

  List<String> get _creatureTypes {
    final types = <String>{};
    for (final creature in _allCreatures) {
      final type = _baseType(creature.type);
      if (type.isNotEmpty) types.add(type);
    }
    return types.toList()..sort();
  }

  List<String> get _creatureSizes {
    const order = ['tiny', 'small', 'medium', 'large', 'huge', 'gargantuan'];
    final sizes = _allCreatures
        .map((creature) => (creature.size ?? '').toLowerCase())
        .toSet();
    return order.where(sizes.contains).toList();
  }

  List<String> get _creatureSources =>
      _allCreatures
          .map((creature) => creature.source)
          .whereType<String>()
          .where((source) => source.isNotEmpty)
          .toSet()
          .toList()
        ..sort();

  List<String> get _challengeRatings => crToXp.keys.toList();

  void _resetStaleCreatureFilters() {
    if (_typeFilter.isNotEmpty && !_creatureTypes.contains(_typeFilter)) {
      _typeFilter = '';
    }
    if (_sizeFilter.isNotEmpty && !_creatureSizes.contains(_sizeFilter)) {
      _sizeFilter = '';
    }
    if (_sourceFilter.isNotEmpty && !_creatureSources.contains(_sourceFilter)) {
      _sourceFilter = '';
    }
  }

  Future<void> _showCreatureFilterDialog() async {
    var type = _typeFilter;
    var size = _sizeFilter;
    var source = _sourceFilter;
    var crMin = _crMin;
    var crMax = _crMax;

    final applied = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLocal) => AlertDialog(
          titleTextStyle: Theme.of(context).textTheme.labelMedium,
          title: const Text('Creature Filters'),
          content: SizedBox(
            width: 320,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _creatureFilterDropdown(
                    'Type',
                    type,
                    _creatureTypes,
                    (value) => setLocal(() => type = value),
                    labelFor: _capitalize,
                  ),
                  _creatureFilterDropdown(
                    'Size',
                    size,
                    _creatureSizes,
                    (value) => setLocal(() => size = value),
                    labelFor: _capitalize,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _creatureFilterDropdown(
                          'Min CR',
                          crMin,
                          _challengeRatings,
                          (value) => setLocal(() => crMin = value),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _creatureFilterDropdown(
                          'Max CR',
                          crMax,
                          _challengeRatings,
                          (value) => setLocal(() => crMax = value),
                        ),
                      ),
                    ],
                  ),
                  _creatureFilterDropdown(
                    'Source',
                    source,
                    _creatureSources,
                    (value) => setLocal(() => source = value),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelMedium,
              ),
              onPressed: () => setLocal(() {
                type = '';
                size = '';
                source = '';
                crMin = '';
                crMax = '';
              }),
              child: const Text('Clear'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelMedium,
              ),
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelMedium,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );

    if (applied != true || !mounted) return;
    final minValue = _crValue(crMin);
    final maxValue = _crValue(crMax);
    if (minValue != null && maxValue != null && minValue > maxValue) {
      final oldMin = crMin;
      crMin = crMax;
      crMax = oldMin;
    }
    setState(() {
      _typeFilter = type;
      _sizeFilter = size;
      _sourceFilter = source;
      _crMin = crMin;
      _crMax = crMax;
    });
  }

  Widget _creatureFilterDropdown(
    String label,
    String value,
    List<String> options,
    ValueChanged<String> onChanged, {
    String Function(String)? labelFor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        key: ValueKey('$label|$value'),
        initialValue: value,
        isExpanded: true,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: [
          DropdownMenuItem(
            value: '',
            child: Text('All', style: Theme.of(context).textTheme.bodyMedium),
          ),
          for (final option in options)
            DropdownMenuItem(
              value: option,
              child: Text(
                labelFor == null ? option : labelFor(option),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
        ],
        onChanged: (value) => onChanged(value ?? ''),
      ),
    );
  }

  List<int> get _partyLevels => [
    for (final combatant in currentEncounter.combatants)
      if (combatant.isPlayer)
        _allPlayers
                .where((player) => player.pId == combatant.playerId)
                .firstOrNull
                ?.pLevel ??
            1,
  ];

  List<int> get _monsterXp => [
    for (final combatant in currentEncounter.combatants)
      if (!combatant.isPlayer)
        for (var i = 0; i < combatant.quantity; i++)
          xpForChallengeRating(
            _allCreatures
                .where((creature) => creature.id == combatant.creatureId)
                .firstOrNull
                ?.challengeRating,
            xpOverride: _allCreatures
                .where((creature) => creature.id == combatant.creatureId)
                .firstOrNull
                ?.xpOverride,
          ),
  ];

  List<double?> get _monsterCr => [
    for (final combatant in currentEncounter.combatants)
      if (!combatant.isPlayer)
        for (var i = 0; i < combatant.quantity; i++)
          tryParseFraction(
            _allCreatures
                    .where((creature) => creature.id == combatant.creatureId)
                    .firstOrNull
                    ?.challengeRating ??
                '',
          ),
  ];

  Widget _difficultyCalculator() {
    return ValueListenableBuilder<DifficultyCalculatorRuleset>(
      valueListenable: selectedDifficultyCalculator,
      builder: (context, ruleset, _) => DifficultyCalculator(
        partyLevels: _partyLevels,
        monsterXp: _monsterXp,
        monsterCr: _monsterCr,
        ruleset: ruleset,
      ),
    );
  }

  Future<void> _start() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    form.save();

    final encounterToRun = Encounter(
      id: currentEncounter.id,
      name: currentEncounter.name,
      currentTurnIndex: currentEncounter.currentTurnIndex,
      combatants: List.of(currentEncounter.combatants),
      encounterNotes: currentEncounter.encounterNotes,
      hasStarted: true,
    );

    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => RunCombatPage(encounter: encounterToRun),
      ),
    );
  }

  void _saveEncounterName(String? value) {
    currentEncounter = Encounter(
      id: currentEncounter.id,
      name: value?.trim() ?? '',
      currentTurnIndex: currentEncounter.currentTurnIndex,
      combatants: currentEncounter.combatants,
      encounterNotes: currentEncounter.encounterNotes,
      hasStarted: currentEncounter.hasStarted,
    );
  }

  void _saveEncounterNotes(String? value) {
    currentEncounter = Encounter(
      id: currentEncounter.id,
      name: currentEncounter.name,
      currentTurnIndex: currentEncounter.currentTurnIndex,
      combatants: currentEncounter.combatants,
      encounterNotes: value ?? '',
      hasStarted: currentEncounter.hasStarted,
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final messenger = ScaffoldMessenger.of(context);
    try {
      final savedId = await saveEncounter(
        database,
        currentEncounter,
        existingId: widget.isCopy ? null : currentEncounter.id,
      );
      currentEncounter = Encounter(
        id: savedId,
        name: currentEncounter.name,
        currentTurnIndex: currentEncounter.currentTurnIndex,
        combatants: currentEncounter.combatants,
        encounterNotes: currentEncounter.encounterNotes,
        hasStarted: currentEncounter.hasStarted,
      );
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Saved ${currentEncounter.name}.')),
      );
      Navigator.of(context).pop(savedId);
    } catch (error) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('Could not save encounter: $error')),
        );
      }
      return;
    }
  }

  // ---------- Shared pieces used by both layouts ----------

  List<CreatureRow> get _visibleCreatures {
    final term = creatureSearchTerm?.toLowerCase() ?? '';
    final minCr = _crValue(_crMin);
    final maxCr = _crValue(_crMax);

    return _allCreatures.where((creature) {
      final matchesName =
          term.isEmpty || creature.name.toLowerCase().contains(term);
      final matchesType =
          _typeFilter.isEmpty || _baseType(creature.type) == _typeFilter;
      final matchesSize =
          _sizeFilter.isEmpty ||
          (creature.size ?? '').toLowerCase() == _sizeFilter;
      final matchesSource =
          _sourceFilter.isEmpty || creature.source == _sourceFilter;

      var matchesCr = true;
      if (minCr != null || maxCr != null) {
        final cr = _crValue(creature.challengeRating);
        matchesCr =
            cr != null &&
            (minCr == null || cr >= minCr) &&
            (maxCr == null || cr <= maxCr);
      }

      return matchesName &&
          matchesType &&
          matchesSize &&
          matchesSource &&
          matchesCr;
    }).toList();
  }

  List<PlayerRow> get _visiblePlayers =>
      (playerSearchTerm == null || playerSearchTerm!.isEmpty)
      ? _allPlayers
      : _allPlayers
            .where(
              (player) => player.pName.toLowerCase().contains(
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
            name: data.pName,
            pClass: data.pClass,
            level: data.pLevel ?? 1,
            onTap: () {
              setState(() {
                if (!currentEncounter.combatants.any(
                  (combatant) => combatant.playerId == data.pId,
                )) {
                  currentEncounter.combatants.add(
                    Combatant(
                      name: data.pName,
                      isPlayer: true,
                      currentHitPoints: data.pHitPoints ?? 0,
                      maxHitPoints: data.pHitPoints ?? 0,
                      initiative: 0,
                      quantity: 1,
                      playerId: data.pId,
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
    final visibleCreatures = _visibleCreatures;
    return ListView.builder(
      padding: padding,
      itemCount: visibleCreatures.length,
      itemBuilder: (context, index) {
        final row = visibleCreatures[index];
        return SizedBox(
          height: 100,
          child: CreatureCard(
            name: row.name,
            type: row.type ?? '',
            size: row.size ?? '',
            cr: row.challengeRating ?? '0',
            source: row.source,
            selected: _selectedId == row.id,
            onTap: () {
              setState(() {
                _selectedId = row.id;
                currentEncounter.combatants.add(
                  Combatant(
                    name: row.name,
                    isPlayer: false,
                    currentHitPoints: row.hitPoints ?? 0,
                    maxHitPoints: row.hitPoints ?? 0,
                    initiative: 0,
                    quantity: 1,
                    creatureId: row.id,
                  ),
                );
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
        return BuildCombatantCard(
          key: ObjectKey(combatant),
          isCreature: !combatant.isPlayer,
          combatant: combatant,
          onQuantityChanged: (_) => setState(() {}),
          onMaskedChanged: (_) => setState(() {}),
          onDelete: () =>
              setState(() => currentEncounter.combatants.remove(combatant)),
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
          textStyle: Theme.of(context).textTheme.bodyLarge,
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
    bool isCreatures,
  ) {
    return SizedBox(
      height: 40,
      width: searchBarWidth,
      child: Row(
        children: [
          Expanded(
            child: SearchAnchor(
              searchController: searchController,
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  controller: controller,
                  hintText: hint,
                  onChanged: onChanged,
                  constraints: const BoxConstraints(
                    minWidth: 0,
                    minHeight: 40,
                    maxHeight: 40,
                  ),
                );
              },
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                    return suggestions();
                  },
            ),
          ),
          if (isCreatures)
            SizedBox(
              width: 40,
              height: 40,
              child: IconButton(
                onPressed: _showCreatureFilterDialog,
                tooltip: 'Filter creatures',
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                color: _activeCreatureFilterCount == 0
                    ? null
                    : Theme.of(context).colorScheme.primary,
                icon: Badge(
                  isLabelVisible: _activeCreatureFilterCount > 0,
                  label: Text('$_activeCreatureFilterCount'),
                  child: const Icon(Icons.filter_list),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ResponsiveLayout.isWide(
              constraints.maxWidth,
              breakpoint: ResponsiveBreakpoints.encounterBuilder,
            )
            ? _buildWide(context)
            : _buildNarrow(context);
      },
    );
  }

  // ---------- Wide: the original three-column layout ----------

  Widget _buildWide(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.appBlack,
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
                        player.pName,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    )
                    .toList(),
                false,
              ),
              _actionButton('Save', _save),
              SizedBox(
                width: 250,
                child: TextFormField(
                  initialValue: currentEncounter.name,
                  onSaved: _saveEncounterName,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Enter an encounter name'
                      : null,
                  decoration: InputDecoration(
                    labelStyle: Theme.of(context).textTheme.bodyMedium,
                    labelText: 'Encounter Name',
                    isDense: true,
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: AppColors.background,
                  ),
                ),
              ),
              _actionButton('Start', _start),
              _searchBar(
                'Search Creatures',
                _creatureSearchController,
                (value) => setState(() => creatureSearchTerm = value),
                () => _visibleCreatures
                    .map<Widget>(
                      (creature) => Text(
                        creature.name,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    )
                    .toList(),
                true,
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
              child: Column(
                children: [
                  Expanded(flex: 6, child: _encounterList()),
                  Expanded(
                    flex: 2,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: BoxBorder.fromLTRB(
                          left: BorderSide(color: AppColors.primary),
                          top: BorderSide(color: AppColors.primary),
                          right: BorderSide(color: AppColors.primary),
                        ),
                        color: AppColors.appBlack,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(AppSpacing.spacingMedium),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.spacingSmall),
                        child: _difficultyCalculator(),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      style: Theme.of(context).textTheme.bodyLarge,
                      expands: true,
                      maxLines: null,
                      textAlignVertical: TextAlignVertical.top,
                      initialValue: currentEncounter.encounterNotes,
                      onSaved: _saveEncounterNotes,
                      decoration: const InputDecoration(
                        labelText: 'Encounter Notes',
                        alignLabelWithHint: true,
                        filled: true,
                        fillColor: AppColors.appBlack,
                        floatingLabelStyle: TextStyle(color: AppColors.primary),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(AppSpacing.spacingMedium),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(AppSpacing.spacingMedium),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(AppSpacing.spacingMedium),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: _creatureList(
                const EdgeInsets.symmetric(
                  horizontal: AppSpacing.spacingMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Narrow: encounter is the main screen, lists are drawers ----------

  Widget _searchDrawer({
    required String hint,
    required TextEditingController controller,
    required ValueChanged<String> onSearch,
    required Widget list,
    bool showCreatureFilter = false,
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
                child: Row(
                  children: [
                    Expanded(
                      child: SearchBar(
                        controller: controller,
                        hintText: hint,
                        onChanged: onSearch,
                      ),
                    ),
                    if (showCreatureFilter)
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: IconButton(
                          onPressed: _showCreatureFilterDialog,
                          tooltip: 'Filter creatures',
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          color: _activeCreatureFilterCount == 0
                              ? null
                              : Theme.of(context).colorScheme.primary,
                          icon: Badge(
                            isLabelVisible: _activeCreatureFilterCount > 0,
                            label: Text('$_activeCreatureFilterCount'),
                            child: const Icon(Icons.filter_list),
                          ),
                        ),
                      ),
                  ],
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
    final keyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;

    return Form(
      key: _formKey,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: AppColors.appBlack,
          scrolledUnderElevation: 0,
          // With a drawer present, Scaffold would replace the back button
          // with a hamburger, so the back button is set explicitly.
          leading: Navigator.canPop(context) ? const BackButton() : null,
          title: TextFormField(
            initialValue: currentEncounter.name,
            onSaved: _saveEncounterName,
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Enter an encounter name'
                : null,
            decoration: InputDecoration(
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              labelText: 'Encounter Name',
              isDense: true,
              border: OutlineInputBorder(),
              filled: true,
              fillColor: AppColors.background,
            ),
          ),
          actions: keyboardVisible
              ? const []
              : [
                  IconButton(
                    tooltip: 'Players',
                    icon: const Icon(Icons.people),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                  IconButton(
                    tooltip: 'Bestiary',
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
          showCreatureFilter: true,
        ),
        body: SafeArea(
          top: false,
          left: false,
          right: false,
          child: Column(
            children: [
              currentEncounter.combatants.isEmpty
                  ? const Expanded(
                      flex: 6,
                      child: Center(
                        child: Text(
                          'No combatants yet.\nUse the buttons above to add players or creatures.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Expanded(flex: 6, child: _encounterList()),
              Expanded(
                flex: 2,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: BoxBorder.fromLTRB(
                      left: BorderSide(color: AppColors.primary),
                      top: BorderSide(color: AppColors.primary),
                      right: BorderSide(color: AppColors.primary),
                    ),
                    color: AppColors.appBlack,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppSpacing.spacingMedium),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.spacingSmall),
                    child: _difficultyCalculator(),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: TextFormField(
                  style: Theme.of(context).textTheme.bodyLarge,
                  expands: true,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  initialValue: currentEncounter.encounterNotes,
                  onSaved: _saveEncounterNotes,
                  decoration: const InputDecoration(
                    labelText: 'Encounter Notes',
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: AppColors.appBlack,
                    floatingLabelStyle: TextStyle(color: AppColors.primary),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(AppSpacing.spacingMedium),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(AppSpacing.spacingMedium),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(AppSpacing.spacingMedium),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

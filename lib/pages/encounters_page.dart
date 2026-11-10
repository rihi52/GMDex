// Browsing and management entry point for saved encounters.
//
// The encounter builder and combat runner are separate routes; this page
// refreshes its list when the builder returns.
import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:gmdex/components/encounter_card.dart';
import 'package:gmdex/components/navigation_sidebar.dart';
import 'package:gmdex/components/notes_drawer.dart';
import 'package:gmdex/components/responsive_layout.dart';
import 'package:gmdex/database/encounter_writer.dart';
import 'package:gmdex/models/combat.dart';
import 'package:gmdex/pages/combat_page.dart';
import 'package:gmdex/pages/combat_run_page.dart';
import 'package:gmdex/theme/apptheme.dart';
import 'package:gmdex/database/database_initialize.dart';

/// Browsing and management entry point for saved encounters.
class EncountersPage extends StatefulWidget {
  const EncountersPage({super.key});

  @override
  State<EncountersPage> createState() => _EncountersPageState();
}

class _EncountersPageState extends State<EncountersPage> {
  int _refreshVersion = 0;

  Future<void> _openCreate() async {
    // Recreate the browser after the editor closes so new/updated rows appear.
    await Navigator.of(context).push<int>(
      MaterialPageRoute<int>(builder: (_) => const EncounterBuildPage()),
    );
    if (mounted) setState(() => _refreshVersion++);
  }

  void _returnHome() =>
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);

  @override
  Widget build(BuildContext context) {
    return ResponsiveNavigationScaffold(
      title: 'Encounters',
      addTooltip: 'Create encounter',
      onAddPressed: _openCreate,
      items: [
        NavigationSidebarItem(title: 'Home', onTap: _returnHome),
        const NavigationSidebarItem(title: 'Browse', selected: true),
        NavigationSidebarItem(
          title: 'Create',
          onTap: _openCreate,
          showDividerAfter: true,
        ),
        NavigationSidebarItem(
          title: 'Players',
          onTap: () {
            Navigator.pushNamed(context, '/players');
          },
        ),
        NavigationSidebarItem(
          title: 'Bestiary',
          onTap: () {
            Navigator.pushNamed(context, '/creatures');
          },
        ),
        NavigationSidebarItem(
          title: 'Spells',
          onTap: () => Navigator.pushNamed(context, '/spells'),
        ),
      ],
      body: BrowseEncountersWidget(key: ValueKey(_refreshVersion)),
    );
  }
}

/// Lists saved encounters and provides their start/edit/copy/delete actions.
class BrowseEncountersWidget extends StatefulWidget {
  const BrowseEncountersWidget({super.key});

  @override
  State<BrowseEncountersWidget> createState() => _BrowseEncountersWidgetState();
}

class _BrowseEncountersWidgetState extends State<BrowseEncountersWidget> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = SearchController();
  List<SavedEncounter> _encounters = [];
  SavedEncounter? _selectedEncounter;
  String _searchTerm = '';
  bool _sortDescending = false;
  Object? _loadError;

  @override
  void initState() {
    super.initState();
    _loadEncounters();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadEncounters() async {
    // Aggregate participant counts alongside each encounter for the summary UI.
    try {
      final direction = _sortDescending ? 'DESC' : 'ASC';
      final encounters = await database
          .customSelect(
            '''
            SELECT
              e.id,
              e.name,
              e.notes,
              (SELECT COUNT(*) FROM encounter_players ep
                WHERE ep.encounter_id = e.id) AS player_count,
              (SELECT COUNT(*) FROM encounter_creatures ec
                WHERE ec.encounter_id = e.id) AS creature_count
            FROM encounters e
            ORDER BY e.name $direction
            ''',
            readsFrom: {
              database.encounters,
              database.encounterPlayers,
              database.encounterCreatures,
            },
          )
          .map(
            (row) => SavedEncounter(
              id: row.read<int>('id'),
              name: row.read<String>('name'),
              notes: row.read<String>('notes'),
              playerCount: row.read<int>('player_count'),
              creatureCount: row.read<int>('creature_count'),
            ),
          )
          .get();
      if (!mounted) return;
      setState(() {
        _encounters = encounters;
        _loadError = null;
        final selectedId = _selectedEncounter?.id;
        _selectedEncounter = selectedId == null
            ? null
            : encounters
                  .where((encounter) => encounter.id == selectedId)
                  .firstOrNull;
      });
    } catch (error) {
      if (mounted) setState(() => _loadError = error);
    }
  }

  List<SavedEncounter> get _visibleEncounters {
    final term = _searchTerm.toLowerCase();
    return _encounters
        .where((encounter) => encounter.name.toLowerCase().contains(term))
        .toList();
  }

  void _selectEncounter(SavedEncounter encounter, bool isWide) {
    setState(() => _selectedEncounter = encounter);
    if (!isWide) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _scaffoldKey.currentState?.openEndDrawer();
      });
    }
  }

  Future<void> _openEditor(
    SavedEncounter encounter, {
    bool copy = false,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      _scaffoldKey.currentState?.closeEndDrawer();
      final loaded = await loadEncounter(database, encounter.id);
      if (!mounted) return;
      if (loaded == null) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Encounter could not be found.')),
        );
        await _loadEncounters();
        return;
      }

      await Navigator.of(context).push<int>(
        MaterialPageRoute<int>(
          builder: (_) => EncounterBuildPage(encounter: loaded, isCopy: copy),
        ),
      );
      await _loadEncounters();
    } catch (error) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('Could not open encounter: $error')),
        );
      }
    }
  }

  Future<void> _startEncounter(SavedEncounter encounter) async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      debugPrint('Starting encounter: ${encounter.id}');

      _scaffoldKey.currentState?.closeEndDrawer();

      debugPrint('Loading encounter...');
      final loaded = await loadEncounter(database, encounter.id);

      debugPrint('Encounter loaded: ${loaded != null}');

      if (!mounted) return;

      if (loaded == null) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Encounter could not be found.')),
        );
        await _loadEncounters();
        return;
      }

      debugPrint('Has started: ${loaded.hasStarted}');
      debugPrint('Combatants: ${loaded.combatants.length}');
      debugPrint('Opening RunCombatPage...');

      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => RunCombatPage(encounter: loaded),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('Could not start encounter: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('Could not start encounter: $error')),
        );
      }
    }
  }

  Future<void> _saveNotes(int encounterId, String notes) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await saveEncounterNotes(database, encounterId, notes);
      await _loadEncounters();
      if (mounted) {
        messenger.showSnackBar(const SnackBar(content: Text('Notes saved.')));
      }
    } catch (error) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('Could not save encounter notes: $error')),
        );
      }
    }
  }

  Future<void> _deleteEncounter(SavedEncounter encounter) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Delete encounter?',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${encounter.name}"? This cannot be undone.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;

    final messenger = ScaffoldMessenger.of(context);
    try {
      final deleted = await deleteEncounter(database, encounter.id);
      if (!mounted) return;
      _scaffoldKey.currentState?.closeEndDrawer();
      setState(() {
        _selectedEncounter = null;
        _encounters.removeWhere((item) => item.id == encounter.id);
      });
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            deleted == 0
                ? 'Encounter was already deleted.'
                : 'Deleted ${encounter.name}.',
          ),
        ),
      );
    } catch (error) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('Could not delete encounter: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = ResponsiveLayout.isWide(
          constraints.maxWidth,
          breakpoint: ResponsiveBreakpoints.browseDetails,
        );
        final visibleEncounters = _visibleEncounters;
        final encounterList = _loadError != null
            ? Center(child: Text('Could not load encounters: $_loadError'))
            : _encounters.isEmpty
            ? const Center(child: Text('No saved encounters yet.'))
            : visibleEncounters.isEmpty
            ? const Center(child: Text('No encounters match your search.'))
            : ListView.builder(
                padding: const EdgeInsets.only(right: AppSpacing.spacingMedium),
                itemCount: visibleEncounters.length,
                itemBuilder: (context, index) {
                  final encounter = visibleEncounters[index];
                  return SizedBox(
                    height: 85,
                    child: EncounterCard(
                      encounter: encounter,
                      selected: _selectedEncounter?.id == encounter.id,
                      onTap: () => _selectEncounter(encounter, isWide),
                    ),
                  );
                },
              );
        final selectedEncounter = _selectedEncounter;
        final details = selectedEncounter == null
            ? const Center(child: Text('Select an encounter to view details.'))
            : EncounterDetails(
                encounter: selectedEncounter,
                onStartPressed: () => _startEncounter(selectedEncounter),
                onEditPressed: () => _openEditor(selectedEncounter),
                onCopyPressed: () => _openEditor(selectedEncounter, copy: true),
                onDeletePressed: () => _deleteEncounter(selectedEncounter),
                onNotesPressed: isWide
                    ? () => _scaffoldKey.currentState?.openEndDrawer()
                    : null,
              );

        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                tooltip: _sortDescending ? 'Sort ascending' : 'Sort descending',
                onPressed: () {
                  setState(() => _sortDescending = !_sortDescending);
                  _loadEncounters();
                },
                icon: const Icon(Icons.sort),
              ),
            ],
            title: SizedBox(
              width:
                  ResponsiveLayout.isNarrow(
                    constraints.maxWidth,
                    breakpoint: ResponsiveBreakpoints.compactContent,
                  )
                  ? constraints.maxWidth - 100
                  : 400,
              height: 40,
              child: SearchAnchor(
                searchController: _searchController,
                builder: (context, controller) => SearchBar(
                  controller: controller,
                  hintText: 'Search Encounters',
                  onChanged: (value) => setState(() => _searchTerm = value),
                ),
                suggestionsBuilder: (context, controller) => visibleEncounters
                    .map(
                      (encounter) => ListTile(
                        title: Text(encounter.name),
                        onTap: () {
                          controller.closeView(encounter.name);
                          setState(() => _searchTerm = encounter.name);
                          _selectEncounter(encounter, isWide);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          endDrawer: selectedEncounter == null
              ? null
              : isWide
              ? NotesDrawer(
                  key: ValueKey(
                    '${selectedEncounter.id}:${selectedEncounter.notes}',
                  ),
                  initialValue: selectedEncounter.notes,
                  maxWidth: min(constraints.maxWidth - 50, 500),
                  onSaved: (value) => _saveNotes(selectedEncounter.id, value),
                )
              : NotesPageViewDrawer(
                  key: ValueKey(
                    '${selectedEncounter.id}:${selectedEncounter.notes}',
                  ),
                  detailsLabel: 'Details',
                  details: Padding(
                    padding: const EdgeInsets.all(AppSpacing.spacingMedium),
                    child: details,
                  ),
                  initialValue: selectedEncounter.notes,
                  maxWidth: min(constraints.maxWidth - 50, 500),
                  onSaved: (value) => _saveNotes(selectedEncounter.id, value),
                ),
          body: Padding(
            padding: const EdgeInsets.all(AppSpacing.spacingMedium),
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: encounterList),
                      const SizedBox(width: AppSpacing.spacingMedium),
                      Expanded(flex: 7, child: details),
                    ],
                  )
                : encounterList,
          ),
        );
      },
    );
  }
}

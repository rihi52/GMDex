// Spell browsing, selection, responsive details, and notes workflows.
import 'dart:math' show min;

import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:gmdex/components/navigation_sidebar.dart';
import 'package:gmdex/components/notes_drawer.dart';
import 'package:gmdex/components/responsive_layout.dart';
import 'package:gmdex/components/spell_card.dart';
import 'package:gmdex/components/spell_details.dart';
import 'package:gmdex/database/database.dart';
import 'package:gmdex/database/database_initialize.dart';
import 'package:gmdex/database/spell_writer.dart';
import 'package:gmdex/models/spell.dart' show spellSchoolName;
import 'package:gmdex/theme/apptheme.dart';

class SpellsPage extends StatelessWidget {
  const SpellsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveNavigationScaffold(
      title: 'Spells',
      items: [
        NavigationSidebarItem(
          title: 'Home',
          onTap: () => Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/home', (route) => false),
          showDividerAfter: true,
        ),
        NavigationSidebarItem(
          title: 'Players',
          onTap: () => Navigator.pushNamed(context, '/players'),
        ),
        NavigationSidebarItem(
          title: 'Bestiary',
          onTap: () => Navigator.pushNamed(context, '/creatures'),
        ),
        NavigationSidebarItem(
          title: 'Encounters',
          onTap: () => Navigator.pushNamed(context, '/encounters'),
        ),
        const NavigationSidebarItem(title: 'Spells', selected: true),
      ],
      body: const BrowseSpellsWidget(),
    );
  }
}

class BrowseSpellsWidget extends StatefulWidget {
  const BrowseSpellsWidget({super.key});

  @override
  State<BrowseSpellsWidget> createState() => _BrowseSpellsWidgetState();
}

class _BrowseSpellsWidgetState extends State<BrowseSpellsWidget> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = SearchController();
  List<SpellRow> _spells = [];
  SpellRow? _selectedSpell;
  String _searchTerm = '';
  String _levelFilter = '';
  String _schoolFilter = '';
  String _sourceFilter = '';
  bool _sortDescending = false;
  Object? _loadError;

  @override
  void initState() {
    super.initState();
    _loadSpells();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSpells() async {
    try {
      final spells =
          await (database.select(database.spells)..orderBy([
                (spell) => _sortDescending
                    ? OrderingTerm.desc(spell.name)
                    : OrderingTerm.asc(spell.name),
              ]))
              .get();
      if (!mounted) return;
      final selectedId = _selectedSpell?.id;
      setState(() {
        _spells = spells;
        _loadError = null;
        _selectedSpell = selectedId == null
            ? null
            : spells.where((spell) => spell.id == selectedId).firstOrNull;
        if (!_levels.contains(_levelFilter)) _levelFilter = '';
        if (!_schools.contains(_schoolFilter)) _schoolFilter = '';
        if (!_sources.contains(_sourceFilter)) _sourceFilter = '';
      });
    } catch (error) {
      if (mounted) setState(() => _loadError = error);
    }
  }

  List<String> get _levels {
    final levels = _spells.map((spell) => spell.level).toSet().toList()..sort();
    return levels.map((level) => level.toString()).toList();
  }

  List<String> get _schools =>
      _spells.map((spell) => spell.school).toSet().toList()..sort();

  List<String> get _sources =>
      _spells.map((spell) => spell.source).toSet().toList()..sort();

  List<SpellRow> get _visibleSpells {
    final term = _searchTerm.toLowerCase();
    return _spells.where((spell) {
      return (term.isEmpty || spell.name.toLowerCase().contains(term)) &&
          (_levelFilter.isEmpty || spell.level.toString() == _levelFilter) &&
          (_schoolFilter.isEmpty || spell.school == _schoolFilter) &&
          (_sourceFilter.isEmpty || spell.source == _sourceFilter);
    }).toList();
  }

  int get _activeFilterCount => [
    _levelFilter,
    _schoolFilter,
    _sourceFilter,
  ].where((filter) => filter.isNotEmpty).length;

  void _selectSpell(SpellRow spell, bool isWide) {
    setState(() => _selectedSpell = spell);
    if (!isWide) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _scaffoldKey.currentState?.openEndDrawer();
      });
    }
  }

  Future<void> _saveNotes(SpellRow spell, String value) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await saveSpellNotes(database, spell.id, value);
      final updated = await (database.select(
        database.spells,
      )..where((row) => row.id.equals(spell.id))).getSingleOrNull();
      if (!mounted) return;
      if (updated == null) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Notes were saved, but spell was not found.'),
          ),
        );
        return;
      }
      setState(() {
        _spells = [
          for (final listedSpell in _spells)
            if (listedSpell.id == updated.id) updated else listedSpell,
        ];
        _selectedSpell = updated;
      });
      messenger.showSnackBar(
        SnackBar(content: Text('Saved notes for ${updated.name}.')),
      );
    } catch (error) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('Could not save spell notes: $error')),
        );
      }
    }
  }

  Future<void> _showFilterDialog() async {
    var level = _levelFilter;
    var school = _schoolFilter;
    var source = _sourceFilter;

    final applied = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLocal) => AlertDialog(
          titleTextStyle: Theme.of(context).textTheme.labelMedium,
          title: const Text('Filters'),
          content: SizedBox(
            width: 320,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _filterDropdown(
                    context,
                    'Level',
                    level,
                    _levels,
                    (value) => setLocal(() => level = value),
                    labelFor: (value) =>
                        value == '0' ? 'Cantrip' : 'Level $value',
                  ),
                  _filterDropdown(
                    context,
                    'School',
                    school,
                    _schools,
                    (value) => setLocal(() => school = value),
                    labelFor: spellSchoolName,
                  ),
                  _filterDropdown(
                    context,
                    'Source',
                    source,
                    _sources,
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
                level = '';
                school = '';
                source = '';
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

    if (applied == true && mounted) {
      setState(() {
        _levelFilter = level;
        _schoolFilter = school;
        _sourceFilter = source;
      });
    }
  }

  Widget _filterDropdown(
    BuildContext context,
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
                labelFor?.call(option) ?? option,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
        ],
        onChanged: (next) => onChanged(next ?? ''),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleSpells = _visibleSpells;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = ResponsiveLayout.isWide(
          constraints.maxWidth,
          breakpoint: ResponsiveBreakpoints.browseDetails,
        );
        final selectedSpell = _selectedSpell;

        final spellList = _loadError != null
            ? Center(child: Text('Could not load spells: $_loadError'))
            : visibleSpells.isEmpty
            ? const Center(child: Text('No spells found.'))
            : ListView.builder(
                padding: const EdgeInsets.only(right: AppSpacing.spacingMedium),
                itemCount: visibleSpells.length,
                itemBuilder: (context, index) {
                  final spell = visibleSpells[index];
                  return ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 88),
                    child: SpellCard(
                      name: spell.name,
                      level: spell.level,
                      school: spell.school,
                      selected: selectedSpell?.id == spell.id,
                      onTap: () => _selectSpell(spell, isWide),
                    ),
                  );
                },
              );

        final details = selectedSpell == null
            ? const SizedBox.shrink()
            : SpellDetails(
                spell: selectedSpell,
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
                  _loadSpells();
                },
                icon: const Icon(Icons.sort),
              ),
              IconButton(
                tooltip: 'Filters',
                onPressed: _showFilterDialog,
                color: _activeFilterCount == 0
                    ? null
                    : Theme.of(context).colorScheme.primary,
                icon: Badge(
                  isLabelVisible: _activeFilterCount > 0,
                  label: Text('$_activeFilterCount'),
                  child: const Icon(Icons.filter_list),
                ),
              ),
            ],
            title: SizedBox(
              width:
                  ResponsiveLayout.isNarrow(
                    constraints.maxWidth,
                    breakpoint: ResponsiveBreakpoints.compactContent,
                  )
                  ? constraints.maxWidth - 120
                  : 400,
              height: 40,
              child: SearchAnchor(
                searchController: _searchController,
                builder: (context, controller) => SearchBar(
                  controller: controller,
                  hintText: 'Search Spells',
                  onChanged: (value) => setState(() => _searchTerm = value),
                ),
                suggestionsBuilder: (context, controller) => visibleSpells
                    .take(20)
                    .map(
                      (spell) => ListTile(
                        title: Text(spell.name),
                        onTap: () {
                          controller.closeView(spell.name);
                          setState(() => _searchTerm = spell.name);
                          _selectSpell(spell, isWide);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          endDrawer: selectedSpell == null
              ? null
              : isWide
              ? NotesDrawer(
                  key: ValueKey('${selectedSpell.id}:${selectedSpell.notes}'),
                  initialValue: selectedSpell.notes ?? '',
                  maxWidth: min(constraints.maxWidth - 50, 500),
                  onSaved: (value) => _saveNotes(selectedSpell, value),
                )
              : NotesPageViewDrawer(
                  key: ValueKey('${selectedSpell.id}:${selectedSpell.notes}'),
                  detailsLabel: 'Details',
                  details: Padding(
                    padding: const EdgeInsets.all(AppSpacing.spacingMedium),
                    child: SpellDetails(spell: selectedSpell),
                  ),
                  initialValue: selectedSpell.notes ?? '',
                  maxWidth: min(constraints.maxWidth - 50, 500),
                  onSaved: (value) => _saveNotes(selectedSpell, value),
                ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: isWide
                ? Row(
                    children: [
                      Expanded(flex: 3, child: spellList),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 7,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: details,
                        ),
                      ),
                    ],
                  )
                : spellList,
          ),
        );
      },
    );
  }
}

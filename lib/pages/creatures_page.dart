// Creature browsing, bestiary import, notes, and stat-block editing workflows.
//
// The parent owns browse/create navigation; the browser handles search and
// selection, while mapper/writer helpers translate between models and Drift.
import 'package:flutter/material.dart';
import 'dart:math' show min;
import 'package:drift/drift.dart' show CustomExpression, OrderingTerm;
import 'package:gmdex/models/creature.dart';
import 'package:gmdex/theme/apptheme.dart';
import 'package:gmdex/components/creature_card.dart';
import 'package:gmdex/components/statblock.dart';
import 'package:gmdex/components/statblock_edit.dart';
import 'package:gmdex/components/notes_drawer.dart';
import 'package:gmdex/components/navigation_sidebar.dart';
import 'package:gmdex/components/responsive_layout.dart';
import 'package:gmdex/database/database.dart' hide CreatureSkills;
import 'package:gmdex/database/creature_mapper.dart';
import 'package:gmdex/database/creature_writer.dart';
import 'package:gmdex/database/notes_writer.dart';
import 'package:gmdex/database/database_initialize.dart';

/// Creature browsing, bestiary import, notes, and stat-block editing workflows.
class CreaturesPage extends StatefulWidget {
  const CreaturesPage({super.key});

  @override
  State<CreaturesPage> createState() => _CreaturesPageState();
}

class _CreaturesPageState extends State<CreaturesPage> {
  int _selectedIndex = 0;
  Creature? _creatureToCopy;
  bool _isEditing = false;
  final _browseKey = GlobalKey<_BrowseCreatureWidgetState>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveNavigationScaffold(
      title: 'Bestiary',
      addTooltip: 'Create creature',
      onAddPressed: _selectedIndex == 0
          ? () {
              setState(() {
                _creatureToCopy = null;
                _isEditing = false;
                _selectedIndex = 1;
              });
            }
          : null,
      onSettingsReturned: _refreshAfterSettings,
      items: [
        NavigationSidebarItem(
          title: 'Home',
          onTap: () {
            setState(() {
              _creatureToCopy = null;
              _isEditing = false;
            });
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/home', (route) => false);
          },
        ),
        NavigationSidebarItem(
          title: 'Browse',
          selected: _selectedIndex == 0,
          onTap: () {
            setState(() {
              _selectedIndex = 0;
              _creatureToCopy = null;
              _isEditing = false;
            });
          },
        ),
        NavigationSidebarItem(
          title: 'Create',
          selected: _selectedIndex == 1,
          onTap: () => setState(() => _selectedIndex = 1),
          showDividerAfter: true,
        ),
        NavigationSidebarItem(
          title: 'Encounters',
          onTap: () {
            Navigator.pushNamed(context, '/encounters');
          },
        ),
        NavigationSidebarItem(
          title: 'Players',
          onTap: () {
            Navigator.pushNamed(context, '/players');
          },
        ),
      ],
      body: _buildContent(),
    );
  }

  Future<void> _refreshAfterSettings() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await _browseKey.currentState?._loadData();
    } catch (error) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('Could not refresh creatures: $error')),
        );
      }
    }
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 1:
        return CreateCreatureWidget(
          creature: _creatureToCopy,
          isEditing: _isEditing,
          onSaved: () => setState(() {
            _creatureToCopy = null;
            _isEditing = false;
            _selectedIndex = 0;
          }),
        );
      case 0:
      default:
        return BrowseCreatureWidget(
          key: _browseKey,
          onCopy: (creature) {
            setState(() {
              _creatureToCopy = creature;
              _isEditing = false;
              _selectedIndex = 1;
            });
          },
          onEdit: (creature) {
            setState(() {
              _creatureToCopy = creature;
              _isEditing = true;
              _selectedIndex = 1;
            });
          },
        );
    }
  }
}

/// Searches and selects creatures, exposing details and edit actions.
class BrowseCreatureWidget extends StatefulWidget {
  const BrowseCreatureWidget({super.key, this.onCopy, this.onEdit});

  final ValueChanged<Creature>? onCopy;
  final ValueChanged<Creature>? onEdit;

  @override
  State<BrowseCreatureWidget> createState() => _BrowseCreatureWidgetState();
}

class _BrowseCreatureWidgetState extends State<BrowseCreatureWidget> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<CreatureRow> _allCreatures = [];
  int? _selectedId; // creature id, so the highlight survives filtering
  Creature? _selectedCreature;
  String? searchTerm;

  // '' = no filter
  String _typeFilter = '';
  String _sizeFilter = '';
  String _sourceFilter = '';
  String _crMin = ''; // '' = no lower bound
  String _crMax = ''; // '' = no upper bound

  int get _activeFilterCount =>
      [
        _typeFilter,
        _sizeFilter,
        _sourceFilter,
      ].where((f) => f.isNotEmpty).length +
      (_crMin.isNotEmpty || _crMax.isNotEmpty ? 1 : 0);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final rows =
        await (database.select(database.creatures)..orderBy([
              (c) => OrderingTerm.asc(CustomExpression<String>('LOWER(name)')),
            ]))
            .get();
    final selectedId = _selectedId;
    final selectedCreature = selectedId == null
        ? null
        : await loadCreature(database, selectedId);
    if (!mounted) return;
    setState(() {
      _allCreatures = rows;
      _selectedCreature = selectedCreature;
      if (selectedCreature == null) _selectedId = null;
      _resetStaleFilters();
    });
  }

  /// Clears any filter whose value no longer exists in the data.
  /// Call after _allCreatures has been reassigned. The CR range needs no
  /// check, because its options come from the crToXp table, not the data.
  void _resetStaleFilters() {
    if (_typeFilter.isNotEmpty && !_types.contains(_typeFilter)) {
      _typeFilter = '';
    }
    if (_sizeFilter.isNotEmpty && !_sizes.contains(_sizeFilter)) {
      _sizeFilter = '';
    }
    if (_sourceFilter.isNotEmpty && !_sources.contains(_sourceFilter)) {
      _sourceFilter = '';
    }
  }

  Future<void> _selectCreature(CreatureRow row, bool isWide) async {
    setState(() => _selectedId = row.id); // highlight right away
    final creature = await loadCreature(database, row.id);
    // Skip if the widget is gone or another creature was tapped meanwhile.
    if (!mounted || _selectedId != row.id || creature == null) return;
    setState(() => _selectedCreature = creature);

    if (!isWide) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _scaffoldKey.currentState?.openEndDrawer();
      });
    }
  }

  Future<void> _saveNotesSection(String notes) async {
    final creature = _selectedCreature;
    final id = _selectedId;
    if (creature == null || id == null) return;

    final messenger = ScaffoldMessenger.of(context);
    try {
      await saveNotes(database, creature, existingId: id, notes: notes);
    } catch (error) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('Could not save notes: $error')),
        );
      }
      return;
    }

    try {
      final updatedCreature = await loadCreature(database, id);
      if (!mounted || _selectedId != id) return;
      if (updatedCreature == null) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text(
              'Notes were saved, but the creature could not be reloaded.',
            ),
          ),
        );
        return;
      }
      setState(() => _selectedCreature = updatedCreature);
      messenger.showSnackBar(
        SnackBar(content: Text('Saved notes for ${creature.name}.')),
      );
    } catch (error) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              'Notes were saved, but could not be reloaded: $error',
            ),
          ),
        );
      }
    }
  }

  Future<void> _confirmDeleteSelectedCreature() async {
    final creature = _selectedCreature;
    final id = _selectedId;
    if (creature == null || id == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Delete creature?',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${creature.name}"? '
          'This cannot be undone.',
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
    final int deleted;
    try {
      deleted = await (database.delete(
        database.creatures,
      )..where((row) => row.id.equals(id))).go();
    } catch (error) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('Could not delete ${creature.name}: $error')),
        );
      }
      return;
    }
    if (!mounted) return;

    _scaffoldKey.currentState?.closeEndDrawer();
    setState(() {
      _selectedId = null;
      _selectedCreature = null;
    });

    try {
      await _loadData();
    } catch (error) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              'Deleted ${creature.name}, but could not reload: $error',
            ),
          ),
        );
      }
      return;
    }
    if (mounted) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            deleted == 0
                ? 'Creature was already deleted.'
                : 'Deleted ${creature.name}.',
          ),
        ),
      );
    }
  }

  String _baseType(String? raw) =>
      (raw ?? '').split('(').first.trim().toLowerCase();

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  /// Converts a CR string to a number: '1/8' -> 0.125, '5' -> 5.0.
  /// Returns null for blank or unparsable values.
  double? _crValue(String? cr) {
    if (cr == null || cr.isEmpty) return null;
    if (cr.contains('/')) {
      final parts = cr.split('/');
      if (parts.length != 2) return null;
      final n = double.tryParse(parts[0]);
      final d = double.tryParse(parts[1]);
      return (n == null || d == null || d == 0) ? null : n / d;
    }
    return double.tryParse(cr);
  }

  List<String> get _types {
    final set = <String>{};
    for (final c in _allCreatures) {
      final t = _baseType(c.type);
      if (t.isNotEmpty) set.add(t);
    }
    return set.toList()..sort();
  }

  List<String> get _sizes {
    const order = ['tiny', 'small', 'medium', 'large', 'huge', 'gargantuan'];
    final present = _allCreatures
        .map((c) => (c.size ?? '').toLowerCase())
        .toSet();
    return order.where(present.contains).toList();
  }

  // Every CR in the table, in order, so any bound can be picked.
  List<String> get _crs => crToXp.keys.toList();

  List<String> get _sources {
    final set = _allCreatures
        .map((c) => c.source)
        .whereType<String>()
        .where((s) => s.isNotEmpty)
        .toSet();
    return set.toList()..sort();
  }

  /// Opens the filter dialog. The dialog edits local copies, so Cancel
  /// discards changes and Apply commits them to the real filter fields.
  Future<void> _showFilterDialog() async {
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
          title: const Text('Filters'),
          content: SizedBox(
            width: 320,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _filterDropdown(
                    'Type',
                    type,
                    _types,
                    (v) => setLocal(() => type = v),
                    labelFor: _capitalize,
                  ),
                  _filterDropdown(
                    'Size',
                    size,
                    _sizes,
                    (v) => setLocal(() => size = v),
                    labelFor: _capitalize,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _filterDropdown(
                          'Min CR',
                          crMin,
                          _crs,
                          (v) => setLocal(() => crMin = v),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _filterDropdown(
                          'Max CR',
                          crMax,
                          _crs,
                          (v) => setLocal(() => crMax = v),
                        ),
                      ),
                    ],
                  ),
                  _filterDropdown(
                    'Source',
                    source,
                    _sources,
                    (v) => setLocal(() => source = v),
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

    if (applied == true && mounted) {
      // If the user picked min above max, swap them.
      final a = _crValue(crMin);
      final b = _crValue(crMax);
      if (a != null && b != null && a > b) {
        final t = crMin;
        crMin = crMax;
        crMax = t;
      }
      setState(() {
        _typeFilter = type;
        _sizeFilter = size;
        _sourceFilter = source;
        _crMin = crMin;
        _crMax = crMax;
      });
    }
  }

  Widget _filterDropdown(
    String label,
    String value,
    List<String> options,
    ValueChanged<String> onChanged, {
    String Function(String)? labelFor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        // initialValue is only read when the field is first built, so the
        // key forces a rebuild when Clear resets the value.
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
          for (final o in options)
            DropdownMenuItem(
              value: o,
              child: Text(
                labelFor == null ? o : labelFor(o),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
        ],
        onChanged: (v) => onChanged(v ?? ''),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final term = searchTerm?.toLowerCase() ?? '';
    final lo = _crValue(_crMin);
    final hi = _crValue(_crMax);

    final visibleCreatures = _allCreatures.where((c) {
      final matchesName = term.isEmpty || c.name.toLowerCase().contains(term);
      final matchesType =
          _typeFilter.isEmpty || _baseType(c.type) == _typeFilter;
      final matchesSize =
          _sizeFilter.isEmpty || (c.size ?? '').toLowerCase() == _sizeFilter;
      final matchesSource = _sourceFilter.isEmpty || c.source == _sourceFilter;

      // Inclusive range. Either bound may be missing.
      var matchesCr = true;
      if (lo != null || hi != null) {
        final cr = _crValue(c.challengeRating);
        matchesCr =
            cr != null && (lo == null || cr >= lo) && (hi == null || cr <= hi);
      }

      return matchesName &&
          matchesType &&
          matchesSize &&
          matchesSource &&
          matchesCr;
    }).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = ResponsiveLayout.isWide(
          constraints.maxWidth,
          breakpoint: ResponsiveBreakpoints.browseDetails,
        );

        final creatureList = ListView.builder(
          padding: const EdgeInsets.only(right: AppSpacing.spacingMedium),
          itemCount: visibleCreatures.length,
          itemBuilder: (context, index) {
            final row = visibleCreatures[index];
            return ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 100),
              child: CreatureCard(
                name: row.name,
                type: row.type ?? '',
                size: row.size ?? '',
                cr: row.challengeRating ?? '0',
                source: row.source,
                selected: _selectedId == row.id,
                onTap: () => _selectCreature(row, isWide),
              ),
            );
          },
        );

        final statBlock = _selectedCreature != null
            ? SingleChildScrollView(
                child: CreatureStatBlock(
                  creature: _selectedCreature!,
                  onEditPressed: widget.onEdit == null
                      ? null
                      : () => widget.onEdit!(_selectedCreature!),
                  onCopyPressed: widget.onCopy == null
                      ? null
                      : () => widget.onCopy!(_selectedCreature!),
                  onDeletePressed: _confirmDeleteSelectedCreature,
                  onNotesPressed: isWide
                      ? () => _scaffoldKey.currentState?.openEndDrawer()
                      : null,
                ),
              )
            : const SizedBox.shrink();

        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                tooltip: 'Filters',
                onPressed: _showFilterDialog,
                color: _typeFilter.isEmpty
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
              width: 400,
              height: 40,
              child: SearchAnchor(
                builder: (BuildContext context, SearchController controller) {
                  return SearchBar(
                    hintText: 'Search Name',
                    onChanged: (value) {
                      setState(() {
                        searchTerm = value;
                      });
                    },
                  );
                },
                suggestionsBuilder:
                    (BuildContext context, SearchController controller) {
                      return visibleCreatures
                          .map<Widget>(
                            (c) => Text(
                              c.name,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          )
                          .toList();
                    },
              ),
            ),
          ),
          endDrawer: _selectedCreature == null
              ? null
              : isWide
              ? NotesDrawer(
                  key: ValueKey(
                    '${_selectedCreature!.id}:${_selectedCreature!.notes}',
                  ),
                  initialValue: _selectedCreature!.notes ?? '',
                  maxWidth: min(constraints.maxWidth - 50, 500),
                  onSaved: _saveNotesSection,
                )
              : NotesPageViewDrawer(
                  key: ValueKey(
                    '${_selectedCreature!.id}:${_selectedCreature!.notes}',
                  ),
                  detailsLabel: 'Statblock',
                  details: CreatureStatBlock(
                    creature: _selectedCreature!,
                    onEditPressed: widget.onEdit == null
                        ? null
                        : () => widget.onEdit!(_selectedCreature!),
                    onCopyPressed: widget.onCopy == null
                        ? null
                        : () => widget.onCopy!(_selectedCreature!),
                    onDeletePressed: _confirmDeleteSelectedCreature,
                  ),
                  initialValue: _selectedCreature!.notes ?? '',
                  maxWidth: min(constraints.maxWidth - 50, 500),
                  onSaved: _saveNotesSection,
                ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: isWide
                ? Row(
                    children: [
                      Expanded(flex: 3, child: creatureList),
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
                : creatureList,
          ),
        );
      },
    );
  }
}

/// Hosts the stat-block editor for creating, copying, or editing creatures.
class CreateCreatureWidget extends StatefulWidget {
  const CreateCreatureWidget({
    super.key,
    this.creature,
    this.isEditing = false,
    this.onSaved,
  });

  final Creature? creature;
  final bool isEditing;
  final VoidCallback? onSaved;

  @override
  State<CreateCreatureWidget> createState() => _CreateCreatureWidgetState();
}

class _CreateCreatureWidgetState extends State<CreateCreatureWidget> {
  Future<void> _save(Creature creature) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await saveCreature(
        database,
        creature,
        // Editing updates that row; creating or copying inserts a new one.
        existingId: widget.isEditing ? widget.creature?.id : null,
      );
      messenger.showSnackBar(SnackBar(content: Text('Saved ${creature.name}')));
      if (mounted) widget.onSaved?.call();
    } on CreatureNameTaken catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('$e')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Could not save: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: widget.isEditing
            ? Text(
                'Editing ${widget.creature!.name}',
                style: Theme.of(context).textTheme.headlineMedium,
              )
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: StatblockEditorForm(
                creature: widget.creature,
                isEditing: widget.isEditing,
                onSubmit: _save,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

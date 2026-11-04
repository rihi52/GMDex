// Live initiative tracker for an encounter.
//
// Combatant hit points, conditions, and turn order are kept in page state and
// persisted through the encounter writer when the encounter is saved.
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' show min;
import 'package:drift/drift.dart' show OrderingTerm;
import 'package:gmdex/components/player_details.dart';
import 'package:gmdex/components/responsive_layout.dart';
import 'package:gmdex/components/statblock.dart';
import 'package:gmdex/components/notes_drawer.dart';
import 'package:gmdex/theme/apptheme.dart';
import 'package:gmdex/pages/combat_page.dart';
import 'package:gmdex/components/combatant_card.dart';
import 'package:gmdex/database/database.dart' hide CreatureSkills;
import 'package:gmdex/database/database_initialize.dart';
import 'package:gmdex/database/creature_mapper.dart';
import 'package:gmdex/database/encounter_writer.dart';
import 'package:gmdex/database/notes_writer.dart';
import 'package:gmdex/database/player_writer.dart';
import 'package:gmdex/models/combat.dart';
import 'package:gmdex/models/creature.dart';
import 'package:gmdex/models/turn_highlight_preference.dart';
import 'package:gmdex/pages/player_face_combat.dart';
import 'package:gmdex/platform/player_initiative_window.dart';
import 'package:gmdex/platform/multiview_support.dart';

/// Runs a new encounter model or a previously loaded encounter.
class RunCombatPage extends StatefulWidget {
  const RunCombatPage({super.key, this.encounter});

  final Encounter? encounter;

  @override
  State<RunCombatPage> createState() => _RunCombatPageState();
}

class _RunCombatPageState extends State<RunCombatPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _combatantListViewportKey = GlobalKey();
  final _combatantListScrollController = ScrollController();
  final _encounterNotesFocusNode = FocusNode();
  final Map<Combatant, GlobalKey> _combatantKeys = {};
  final Map<Combatant, int> _enemyNumbers = {};
  late final List<Combatant> _combatants;
  late final TextEditingController _encounterNotesController;
  int? _encounterId;
  late String _encounterName;
  late int _currentTurnIndex;
  late bool _hasStarted;
  Combatant? _selectedCombatant;
  Creature? _selectedCreature;
  PlayerRow? _selectedPlayer;
  Object? _selectionError;
  int? _playerInitiativeWindowId;

  @override
  void initState() {
    super.initState();
    _encounterNotesFocusNode.addListener(_onEncounterNotesFocusChanged);
    // Space advances the active turn unless focus is inside a text field.
    HardwareKeyboard.instance.addHandler(_handleHardwareKey);
    _hasStarted = widget.encounter?.hasStarted ?? false;
    _combatants = List.of(widget.encounter?.combatants ?? const []);

    // Sort highest initiative first.
    _sortCombatants();
    _assignEnemyNumbers();

    // Restore the explicitly active combatant, if one exists.
    Combatant? activeCombatant;
    if (widget.encounter?.hasStarted == true) {
      // This encounter has been started before: restore its active combatant.
      for (final combatant in _combatants) {
        if (combatant.isTurn) {
          activeCombatant = combatant;
          break;
        }
      }

      // Fallback if no combatant has an active flag.
      if (activeCombatant == null && _combatants.isNotEmpty) {
        final savedIndex = (widget.encounter?.currentTurnIndex ?? 0).clamp(
          0,
          _combatants.length - 1,
        );
        activeCombatant = _combatants[savedIndex];
      }
    } else {
      // New encounter: highest initiative goes first.
      activeCombatant = _combatants.isEmpty ? null : _combatants.first;
    }

    _encounterId = widget.encounter?.id;
    _encounterName = widget.encounter?.name ?? 'Combat';

    _currentTurnIndex = activeCombatant == null
        ? 0
        : _combatants.indexOf(activeCombatant);

    _updateTurnFlags();
    _encounterNotesController = TextEditingController(
      text: widget.encounter?.encounterNotes ?? '',
    );
  }

  @override
  void dispose() {
    _encounterNotesFocusNode
      ..removeListener(_onEncounterNotesFocusChanged)
      ..dispose();
    unawaited(_closePlayerInitiativeWindow());
    updatePlayerFacingCombat(const []);
    HardwareKeyboard.instance.removeHandler(_handleHardwareKey);
    _combatantListScrollController.dispose();
    _encounterNotesController.dispose();
    super.dispose();
  }

  void _onEncounterNotesFocusChanged() {
    if (mounted) setState(() {});
  }

  void _deleteCombatant(Combatant combatant) {
    setState(() {
      final removedIndex = _combatants.indexOf(combatant);
      if (removedIndex < 0) return;
      _combatants.removeAt(removedIndex);
      _combatantKeys.remove(combatant);
      if (_combatants.isEmpty) {
        _currentTurnIndex = 0;
      } else if (removedIndex < _currentTurnIndex) {
        _currentTurnIndex--;
      } else if (_currentTurnIndex >= _combatants.length) {
        _currentTurnIndex = 0;
      }
      _updateTurnFlags();
    });
  }

  void _moveTurn(int offset) {
    if (_combatants.isEmpty) return;

    setState(() {
      _hasStarted = true;

      _currentTurnIndex =
          (_currentTurnIndex + offset + _combatants.length) %
          _combatants.length;

      _updateTurnFlags();
    });

    _scheduleActiveCombatantScroll();
  }

  bool _handleHardwareKey(KeyEvent event) {
    if (event is! KeyDownEvent ||
        event.logicalKey != LogicalKeyboardKey.space ||
        !mounted ||
        ModalRoute.of(context)?.isCurrent != true) {
      return false;
    }

    var isEditingText = false;
    FocusManager.instance.primaryFocus?.context?.visitAncestorElements((
      element,
    ) {
      if (element.widget is EditableText) {
        isEditingText = true;
        return false;
      }
      return true;
    });
    if (isEditingText) return false;

    _moveTurn(1);
    return true;
  }

  void _sortCombatantsByInitiative() {
    setState(() {
      _sortCombatantsKeepingTurn();
    });
    _scheduleActiveCombatantScroll();
  }

  void _updateCombatantInitiative(Combatant combatant, int? initiative) {
    setState(() {
      combatant.initiative = initiative;
      _sortCombatantsKeepingTurn();
    });
    _scheduleActiveCombatantScroll();
  }

  void _scheduleActiveCombatantScroll() {
    if (_combatants.isEmpty) return;
    final activeCombatant = _combatants[_currentTurnIndex];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollCombatantIntoView(activeCombatant);
    });
  }

  void _scrollCombatantIntoView(Combatant combatant) {
    if (!mounted || !_combatantListScrollController.hasClients) return;
    final cardContext = _combatantKeys[combatant]?.currentContext;
    final viewportContext = _combatantListViewportKey.currentContext;
    final cardObject = cardContext?.findRenderObject();
    final viewportObject = viewportContext?.findRenderObject();
    if (cardObject is! RenderBox ||
        viewportObject is! RenderBox ||
        !cardObject.hasSize ||
        !viewportObject.hasSize) {
      return;
    }

    final cardTop = cardObject.localToGlobal(Offset.zero).dy;
    final cardBottom = cardTop + cardObject.size.height;
    final viewportTop = viewportObject.localToGlobal(Offset.zero).dy;
    final viewportBottom = viewportTop + viewportObject.size.height;
    const viewportMargin = 16.0;
    final delta = cardTop < viewportTop
        ? cardTop - viewportTop - viewportMargin
        : cardBottom > viewportBottom
        ? cardBottom - viewportBottom + viewportMargin
        : 0.0;
    if (delta == 0) return;

    final position = _combatantListScrollController.position;
    final targetOffset = (position.pixels + delta)
        .clamp(position.minScrollExtent, position.maxScrollExtent)
        .toDouble();
    _combatantListScrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  void _sortCombatantsKeepingTurn() {
    final activeCombatant = _currentTurnIndex < _combatants.length
        ? _combatants[_currentTurnIndex]
        : null;
    _sortCombatants();
    if (activeCombatant != null) {
      _currentTurnIndex = _combatants.indexOf(activeCombatant);
    } else {
      _currentTurnIndex = 0;
    }
    _updateTurnFlags();
  }

  void _updateTurnFlags() {
    for (var index = 0; index < _combatants.length; index++) {
      _combatants[index].isTurn = index == _currentTurnIndex;
    }
    _publishPlayerFacingCombat();
  }

  void _publishPlayerFacingCombat() {
    _assignEnemyNumbers();
    updatePlayerFacingCombat(
      _combatants
          .map(
            (combatant) => PlayerViewRow.fromCombatant(
              combatant,
              maskedName: combatant.isPlayer
                  ? 'Enemy'
                  : 'Enemy ${_enemyNumbers[combatant]}',
            ),
          )
          .toList(growable: false),
    );
  }

  void _assignEnemyNumbers() {
    var nextNumber = _enemyNumbers.length + 1;
    for (final combatant in _combatants) {
      if (!combatant.isPlayer && !_enemyNumbers.containsKey(combatant)) {
        _enemyNumbers[combatant] = nextNumber++;
      }
    }
  }

  Future<void> _openPlayerInitiative() async {
    if (!supportsMultiViewPlatform) {
      return;
    }

    try {
      final windowId = await openOrFocusPlayerInitiativeWindow(
        context,
        _playerInitiativeWindowId,
      );
      if (windowId == null) return;
      if (mounted) {
        _playerInitiativeWindowId = windowId;
      } else {
        await closePlayerInitiativeWindow(windowId);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open player initiative: $error')),
        );
      }
    }
  }

  Future<bool> _closePlayerInitiativeWindow() async {
    final windowId = _playerInitiativeWindowId;
    if (windowId == null) return true;

    try {
      final closed = await closePlayerInitiativeWindow(windowId);
      if (closed) _playerInitiativeWindowId = null;
      if (!closed && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not close player initiative.')),
        );
      }
      return closed;
    } catch (error, stackTrace) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not close player initiative: $error')),
        );
      } else {
        debugPrint('Could not close player initiative: $error\n$stackTrace');
      }
      return false;
    }
  }

  void _sortCombatants() {
    _combatants.sort(
      (first, second) =>
          (second.initiative ?? 0).compareTo(first.initiative ?? 0),
    );
    // if (_combatants.isNotEmpty) {
    //   _currentTurnIndex = 0;
    //   _updateTurnFlags();
    // }
  }

  Widget _buildCombatantCard(Combatant combatant, int index, bool isWide) {
    final key = _combatantKeys.putIfAbsent(combatant, GlobalKey.new);
    return RunCombatantCard(
      key: key,
      isCreature: !combatant.isPlayer,
      combatant: combatant,
      selected: _selectedCombatant == combatant,
      isActiveTurn: index == _currentTurnIndex,
      onTap: () => _selectCombatant(combatant, isWide),
      onDelete: () => _deleteCombatant(combatant),
      onCombatantChanged: _publishPlayerFacingCombat,
      onInitiativeChanged: (initiative) =>
          _updateCombatantInitiative(combatant, initiative),
    );
  }

  Future<void> _selectCombatant(Combatant combatant, bool isWide) async {
    if (isWide && _selectedCombatant == combatant) {
      setState(() {
        _selectedCombatant = null;
        _selectedCreature = null;
        _selectedPlayer = null;
        _selectionError = null;
      });
      return;
    }

    setState(() {
      _selectedCombatant = combatant;
      _selectedCreature = null;
      _selectedPlayer = null;
      _selectionError = null;
    });

    try {
      if (combatant.isPlayer) {
        final playerId = combatant.playerId;
        if (playerId == null) {
          throw StateError('Player "${combatant.name}" has no database id.');
        }
        final player = await (database.select(
          database.players,
        )..where((row) => row.pId.equals(playerId))).getSingleOrNull();
        if (player == null) {
          throw StateError('Player "${combatant.name}" could not be found.');
        }
        if (!mounted || _selectedCombatant != combatant) return;
        setState(() => _selectedPlayer = player);
      } else {
        final creatureId = combatant.creatureId;
        if (creatureId == null) {
          throw StateError('Creature "${combatant.name}" has no database id.');
        }
        final creature = await loadCreature(database, creatureId);
        if (creature == null) {
          throw StateError('Creature "${combatant.name}" could not be found.');
        }
        if (!mounted || _selectedCombatant != combatant) return;
        setState(() => _selectedCreature = creature);
      }

      if (!isWide) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _selectedCombatant == combatant) {
            _scaffoldKey.currentState?.openEndDrawer();
          }
        });
      }
    } catch (error) {
      if (!mounted || _selectedCombatant != combatant) return;
      setState(() => _selectionError = error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not load combatant details: $error')),
      );
    }
  }

  String get _selectedNotes =>
      _selectedPlayer?.pNotes ?? _selectedCreature?.notes ?? '';

  Widget _combatantDetails({required bool isWide}) {
    final error = _selectionError;
    if (error != null) {
      return Center(child: Text('Could not load combatant details: $error'));
    }
    final player = _selectedPlayer;
    if (player != null) {
      return PlayerDetails(
        player: player,
        onNotesPressed: isWide
            ? () => _scaffoldKey.currentState?.openEndDrawer()
            : null,
      );
    }
    final creature = _selectedCreature;
    if (creature != null) {
      return CreatureStatBlock(
        creature: creature,
        onNotesPressed: isWide
            ? () => _scaffoldKey.currentState?.openEndDrawer()
            : null,
      );
    }
    return const Center(child: Text('Select a combatant to view details.'));
  }

  Future<void> _saveSelectedNotes(String notes) async {
    final messenger = ScaffoldMessenger.of(context);
    final player = _selectedPlayer;
    final creature = _selectedCreature;
    try {
      if (player != null) {
        await savePlayerNotes(database, player.pId, notes);
        final updated = await (database.select(
          database.players,
        )..where((row) => row.pId.equals(player.pId))).getSingleOrNull();
        if (!mounted) return;
        if (updated == null) {
          throw StateError('Player "${player.pName}" could not be found.');
        }
        setState(() => _selectedPlayer = updated);
        messenger.showSnackBar(
          SnackBar(content: Text('Saved notes for ${updated.pName}.')),
        );
        return;
      }

      if (creature != null) {
        final creatureId = creature.id;
        if (creatureId == null) {
          throw StateError('Creature "${creature.name}" has no database id.');
        }
        await saveNotes(
          database,
          creature,
          existingId: creatureId,
          notes: notes,
        );
        final updated = await loadCreature(database, creatureId);
        if (!mounted) return;
        if (updated == null) {
          throw StateError('Creature "${creature.name}" could not be found.');
        }
        setState(() => _selectedCreature = updated);
        messenger.showSnackBar(
          SnackBar(content: Text('Saved notes for ${updated.name}.')),
        );
      }
    } catch (error) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('Could not save notes: $error')),
        );
      }
    }
  }

  Future<void> _saveAndExit() async {
    final messenger = ScaffoldMessenger.of(context);
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;
    form.save();
    final encounter = Encounter(
      id: _encounterId,
      name: _encounterName,
      currentTurnIndex: _currentTurnIndex,
      combatants: List.of(_combatants),
      encounterNotes: _encounterNotesController.text,
      hasStarted: _hasStarted,
    );
    try {
      await saveEncounter(database, encounter, existingId: _encounterId);
      if (!mounted) return;
      if (!await _closePlayerInitiativeWindow() || !mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    } catch (error) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('Could not save encounter: $error')),
        );
      }
    }
  }

  Future<void> _exitWithoutSaving() async {
    if (!await _closePlayerInitiativeWindow() || !mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
  }

  Future<void> _editEncounter() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;
    form.save();

    final result = await Navigator.of(context).push<int>(
      MaterialPageRoute<int>(
        builder: (_) => EncounterBuildPage(
          encounter: Encounter(
            id: _encounterId,
            name: _encounterName,
            currentTurnIndex: _currentTurnIndex,
            combatants: List.of(_combatants),
            encounterNotes: _encounterNotesController.text,
            hasStarted: _hasStarted,
          ),
        ),
      ),
    );
    if (!mounted || result == null) return;
    _encounterId = result;

    try {
      final updatedEncounter = await loadEncounter(database, result);
      if (!mounted) return;
      if (updatedEncounter == null) {
        throw StateError('Encounter $_encounterId no longer exists.');
      }
      setState(() {
        _encounterName = updatedEncounter.name;
        _enemyNumbers.clear();
        _combatants
          ..clear()
          ..addAll(updatedEncounter.combatants)
          ..sort(
            (first, second) =>
                (second.initiative ?? 0).compareTo(first.initiative ?? 0),
          );
        _combatantKeys.clear();
        _currentTurnIndex = _combatants.isEmpty
            ? 0
            : _currentTurnIndex.clamp(0, _combatants.length - 1);
        _encounterNotesController.text = updatedEncounter.encounterNotes ?? '';
        _selectedCombatant = null;
        _selectedCreature = null;
        _selectedPlayer = null;
        _selectionError = null;
        _updateTurnFlags();
      });
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not reload encounter: $error')),
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
          breakpoint: ResponsiveBreakpoints.encounterRun,
        );
        final notesKeyboardVisible =
            ResponsiveLayout.isMobilePlatform &&
            _encounterNotesFocusNode.hasFocus &&
            MediaQuery.viewInsetsOf(context).bottom > 0;
        return Form(
          key: _formKey,
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              title: Text(_encounterName),
              actions: [
                IconButton(
                  tooltip: 'Sort by initiative',
                  onPressed: _sortCombatantsByInitiative,
                  icon: const Icon(Icons.sort),
                ),
                if (supportsMultiViewPlatform)
                  IconButton(
                    onPressed: _openPlayerInitiative,
                    icon: const Icon(Icons.open_in_new),
                    tooltip: 'Pop-out Player Initiative',
                  ),
              ],
            ),
            endDrawer: _selectedCombatant == null || _selectionError != null
                ? null
                : isWide
                ? NotesDrawer(
                    key: ValueKey(
                      '${_selectedCombatant!.creatureId}:${_selectedCombatant!.playerId}:$_selectedNotes',
                    ),
                    initialValue: _selectedNotes,
                    maxWidth: min(constraints.maxWidth - 50, 500),
                    onSaved: _saveSelectedNotes,
                  )
                : NotesPageViewDrawer(
                    key: ValueKey(
                      '${_selectedCombatant!.creatureId}:${_selectedCombatant!.playerId}:$_selectedNotes',
                    ),
                    detailsLabel: _selectedPlayer != null
                        ? 'Details'
                        : 'Statblock',
                    details: Padding(
                      padding: const EdgeInsets.all(AppSpacing.spacingMedium),
                      child: _combatantDetails(isWide: false),
                    ),
                    initialValue: _selectedNotes,
                    maxWidth: min(constraints.maxWidth - 50, 500),
                    onSaved: _saveSelectedNotes,
                  ),
            body: SafeArea(
              key: const ValueKey('combat-body-safe-area'),
              top: false,
              left: false,
              right: false,
              bottom: !isWide,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          flex: notesKeyboardVisible
                              ? 7
                              : ResponsiveLayout.isMobilePlatform
                              ? 6
                              : 7,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.spacingLarge,
                            ),
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              key: _combatantListViewportKey,
                              controller: _combatantListScrollController,
                              child: Column(
                                children: [
                                  for (
                                    var index = 0;
                                    index < _combatants.length;
                                    index++
                                  )
                                    _buildCombatantCard(
                                      _combatants[index],
                                      index,
                                      isWide,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const ColoredBox(
                          color: AppColors.background,
                          child: Divider(
                            color: AppColors.primary,
                            thickness: 1,
                          ),
                        ),
                        Expanded(
                          flex: notesKeyboardVisible
                              ? 3
                              : ResponsiveLayout.isMobilePlatform
                              ? 4
                              : 3,
                          child: ColoredBox(
                            color: AppColors.background,
                            child: Column(
                              children: [
                                Expanded(
                                  flex: notesKeyboardVisible
                                      ? 1
                                      : ResponsiveLayout.isMobilePlatform
                                      ? 5
                                      : 6,
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                      AppSpacing.spacingMedium,
                                    ),
                                    child: _EncounterNotesEditor(
                                      controller: _encounterNotesController,
                                      focusNode: _encounterNotesFocusNode,
                                    ),
                                  ),
                                ),
                                if (!notesKeyboardVisible) ...[
                                  const Divider(
                                    color: AppColors.primary,
                                    thickness: 1,
                                  ),
                                  Expanded(
                                    flex: ResponsiveLayout.isMobilePlatform
                                        ? 3
                                        : 2,
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: ValueListenableBuilder<bool>(
                                        valueListenable: turnHighlightEnabled,
                                        builder:
                                            (
                                              context,
                                              isHighlightEnabled,
                                              _,
                                            ) => Wrap(
                                              runAlignment:
                                                  WrapAlignment.center,
                                              alignment:
                                                  WrapAlignment.spaceEvenly,
                                              spacing: AppSpacing.spacingLarge,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: isHighlightEnabled
                                                      ? () => _moveTurn(-1)
                                                      : null,
                                                  child: Text('Previous'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: isHighlightEnabled
                                                      ? () => _moveTurn(1)
                                                      : null,
                                                  child: Text('Next'),
                                                ),
                                              ],
                                            ),
                                      ),
                                    ),
                                  ),
                                  const Divider(
                                    color: AppColors.primary,
                                    thickness: 1,
                                  ),
                                  Expanded(
                                    flex: ResponsiveLayout.isMobilePlatform
                                        ? 3
                                        : 2,
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Wrap(
                                        runAlignment: WrapAlignment.center,
                                        alignment: WrapAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        spacing: AppSpacing.spacingLarge,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: AppSpacing
                                                        .spacingMedium,
                                                    vertical:
                                                        AppSpacing.spacingSmall,
                                                  ),
                                            ),
                                            onPressed: _editEncounter,
                                            child: Text('Edit'),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: AppSpacing
                                                        .spacingMedium,
                                                    vertical:
                                                        AppSpacing.spacingSmall,
                                                  ),
                                            ),
                                            onPressed: _saveAndExit,
                                            child: const Text('Save & Exit'),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: AppSpacing
                                                        .spacingMedium,
                                                    vertical:
                                                        AppSpacing.spacingSmall,
                                                  ),
                                            ),
                                            onPressed: _exitWithoutSaving,
                                            child: Text('Exit'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: AppSpacing.spacingLarge,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isWide) ...[
                    const VerticalDivider(
                      color: AppColors.primary,
                      width: 5,
                      thickness: 1,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsGeometry.symmetric(
                          horizontal: AppSpacing.spacingLarge,
                        ),
                        child: _combatantDetails(isWide: true),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EncounterNotesEditor extends StatelessWidget {
  const _EncounterNotesEditor({
    required this.controller,
    required this.focusNode,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      expands: true,
      maxLines: null,
      textAlignVertical: TextAlignVertical.top,
      decoration: const InputDecoration(
        labelText: 'Encounter Notes',
        alignLabelWithHint: true,
        border: OutlineInputBorder(),
      ),
    );
  }
}

class EncounterChoicePage extends StatefulWidget {
  const EncounterChoicePage({super.key});

  @override
  State<EncounterChoicePage> createState() => _EncounterChoicePageState();
}

class _EncounterChoicePageState extends State<EncounterChoicePage> {
  int _refreshVersion = 0;

  void _returnHome() => Navigator.of(context).pop();

  Future<void> _openCreate() async {
    await Navigator.of(context).push<int>(
      MaterialPageRoute<int>(builder: (_) => const EncounterBuildPage()),
    );
    if (mounted) setState(() => _refreshVersion++);
  }

  Future<void> _openExisting() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final encounters = await (database.select(
        database.encounters,
      )..orderBy([(row) => OrderingTerm.desc(row.updatedAt)])).get();
      if (!mounted) return;

      final selectedId = await showDialog<int>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Choose an encounter'),
          content: SizedBox(
            width: 400,
            height: 350,
            child: encounters.isEmpty
                ? const Center(child: Text('No saved encounters yet.'))
                : ListView.builder(
                    itemCount: encounters.length,
                    itemBuilder: (context, index) {
                      final encounter = encounters[index];
                      return ListTile(
                        title: Text(encounter.name),
                        subtitle: Text(
                          'Updated ${encounter.updatedAt.toLocal()}',
                        ),
                        onTap: () =>
                            Navigator.of(dialogContext).pop(encounter.id),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
      if (!mounted || selectedId == null) return;

      final encounter = await loadEncounter(database, selectedId);
      if (!mounted) return;
      if (encounter == null) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Encounter could not be found.')),
        );
        return;
      }

      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => RunCombatPage(encounter: encounter),
        ),
      );
    } catch (error) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('Could not import encounter: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        bottom: ResponsiveLayout.isNarrow(
          MediaQuery.sizeOf(context).width,
          breakpoint: ResponsiveBreakpoints.navigation,
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 75,
                width: 150,
                child: ElevatedButton(
                  onPressed: _returnHome,
                  child: Text('Return'),
                ),
              ),
              SizedBox(
                height: 75,
                width: 150,
                child: ElevatedButton(
                  onPressed: _openCreate,
                  child: Text('New'),
                ),
              ),
              SizedBox(
                height: 75,
                width: 150,
                child: ElevatedButton(
                  onPressed: _openExisting,
                  child: const Text('Existing'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

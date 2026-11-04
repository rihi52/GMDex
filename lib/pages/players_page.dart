// Player browsing, editing, copying, creation, and notes workflows.
//
// This page owns navigation between browse/create modes; the browse widget
// handles filtering and selection while database writes live in player_writer.
import 'dart:math' show min;

import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:gmdex/components/player_card.dart';
import 'package:gmdex/components/player_details.dart';
import 'package:gmdex/components/player_edit.dart';
import 'package:gmdex/components/notes_drawer.dart';
import 'package:gmdex/components/navigation_sidebar.dart';
import 'package:gmdex/components/responsive_layout.dart';
import 'package:gmdex/database/database.dart';
import 'package:gmdex/database/player_writer.dart';
import 'package:gmdex/models/player_draft.dart';
import 'package:gmdex/theme/apptheme.dart';
import 'package:gmdex/database/database_initialize.dart';

/// Player browsing, editing, copying, creation, and notes workflows.
class PlayersPage extends StatefulWidget {
  const PlayersPage({super.key});

  @override
  State<PlayersPage> createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  static const _titles = ['Browse', 'Create'];
  int _selectedIndex = 0;
  PlayerRow? _playerToEditOrCopy;
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return ResponsiveNavigationScaffold(
      title: 'Players',
      addTooltip: 'Create player',
      onAddPressed: _selectedIndex == 0
          ? () {
              setState(() {
                _playerToEditOrCopy = null;
                _isEditing = false;
                _selectedIndex = 1;
              });
            }
          : null,
      items: [
        NavigationSidebarItem(
          title: 'Home',
          onTap: () => Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/home', (route) => false),
        ),
        for (var index = 0; index < _titles.length; index++)
          NavigationSidebarItem(
            title: _titles[index],
            selected: _selectedIndex == index,
            showDividerAfter: index == 1,
            onTap: () {
              setState(() {
                _selectedIndex = index;
                if (index == 0) {
                  _playerToEditOrCopy = null;
                  _isEditing = false;
                }
              });
            },
          ),
        NavigationSidebarItem(
          title: 'Encounters',
          onTap: () {
            Navigator.pushNamed(context, '/encounters');
          },
        ),
        NavigationSidebarItem(
          title: 'Bestiary',
          onTap: () {
            Navigator.pushNamed(context, '/creatures');
          },
        ),
      ],
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    // A copied/edited row is passed into the same create form, with the mode
    // flag deciding whether submission updates the row or inserts a new one.
    if (_selectedIndex == 1) {
      return CreatePlayerWidget(
        player: _playerToEditOrCopy,
        isEditing: _isEditing,
        onSaved: () {
          if (!mounted) return;
          setState(() {
            _playerToEditOrCopy = null;
            _isEditing = false;
            _selectedIndex = 0;
          });
        },
      );
    }

    return BrowsePlayerWidget(
      onCopy: (player) {
        setState(() {
          _playerToEditOrCopy = player;
          _isEditing = false;
          _selectedIndex = 1;
        });
      },
      onEdit: (player) {
        setState(() {
          _playerToEditOrCopy = player;
          _isEditing = true;
          _selectedIndex = 1;
        });
      },
    );
  }
}

/// Searches and selects players, and exposes edit/copy actions to its owner.
class BrowsePlayerWidget extends StatefulWidget {
  const BrowsePlayerWidget({super.key, this.onCopy, this.onEdit});

  final ValueChanged<PlayerRow>? onCopy;
  final ValueChanged<PlayerRow>? onEdit;

  @override
  State<BrowsePlayerWidget> createState() => _BrowsePlayerWidgetState();
}

class _BrowsePlayerWidgetState extends State<BrowsePlayerWidget> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = SearchController();

  List<PlayerRow> _players = [];
  PlayerRow? _selectedPlayer;
  String _searchTerm = '';
  bool _sortDescending = false;
  Object? _loadError;

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPlayers() async {
    // Requery after writes while retaining the selected row when it still exists.
    try {
      final players =
          await (database.select(database.players)..orderBy([
                (player) => _sortDescending
                    ? OrderingTerm.desc(player.pName)
                    : OrderingTerm.asc(player.pName),
              ]))
              .get();
      if (!mounted) return;
      setState(() {
        _players = players;
        _loadError = null;
        final selectedId = _selectedPlayer?.pId;
        _selectedPlayer = selectedId == null
            ? null
            : players.where((player) => player.pId == selectedId).firstOrNull;
      });
    } catch (error) {
      if (mounted) setState(() => _loadError = error);
    }
  }

  List<PlayerRow> get _visiblePlayers {
    final term = _searchTerm.toLowerCase();
    return _players
        .where(
          (player) => term.isEmpty || player.pName.toLowerCase().contains(term),
        )
        .toList();
  }

  void _selectPlayer(PlayerRow player, bool isWide) {
    setState(() => _selectedPlayer = player);
    if (!isWide) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _scaffoldKey.currentState?.openEndDrawer();
      });
    }
  }

  Future<void> _saveNotes(PlayerRow player, String value) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await savePlayerNotes(database, player.pId, value);
      final updated = await (database.select(
        database.players,
      )..where((row) => row.pId.equals(player.pId))).getSingleOrNull();
      if (!mounted) return;
      if (updated == null) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Notes were saved, but player was not found.'),
          ),
        );
        return;
      }
      setState(() {
        _players = [
          for (final listedPlayer in _players)
            if (listedPlayer.pId == updated.pId) updated else listedPlayer,
        ];
        _selectedPlayer = updated;
      });
      messenger.showSnackBar(
        SnackBar(content: Text('Saved notes for ${updated.pName}.')),
      );
    } catch (error) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('Could not save player notes: $error')),
        );
      }
    }
  }

  Future<void> _deleteSelectedPlayer() async {
    final player = _selectedPlayer;
    if (player == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Delete player?',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${player.pName}"? This cannot be undone.',
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
      final deleted = await (database.delete(
        database.players,
      )..where((row) => row.pId.equals(player.pId))).go();
      if (!mounted) return;
      _scaffoldKey.currentState?.closeEndDrawer();
      setState(() => _selectedPlayer = null);
      await _loadPlayers();
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              deleted == 0
                  ? 'Player was already deleted.'
                  : 'Deleted ${player.pName}.',
            ),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('Could not delete ${player.pName}: $error')),
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
        final visiblePlayers = _visiblePlayers;
        final playerList = _loadError != null
            ? Center(child: Text('Could not load players: $_loadError'))
            : _players.isEmpty
            ? const Center(child: Text('No players yet.'))
            : visiblePlayers.isEmpty
            ? const Center(child: Text('No players match your search.'))
            : ListView.separated(
                padding: const EdgeInsets.only(right: AppSpacing.spacingMedium),
                itemCount: visiblePlayers.length,
                separatorBuilder: ((context, index) =>
                    const SizedBox(height: AppSpacing.spacingMedium)),
                itemBuilder: (context, index) {
                  final player = visiblePlayers[index];
                  return PlayerCard(
                    name: player.pName,
                    pClass: player.pClass,
                    level: player.pLevel ?? 1,
                    originalCampaign: player.pOriginalCampaign,
                    selected: _selectedPlayer?.pId == player.pId,
                    onTap: () => _selectPlayer(player, isWide),
                  );
                },
              );

        final selectedPlayer = _selectedPlayer;
        final details = selectedPlayer == null
            ? const SizedBox.shrink()
            : PlayerDetails(
                player: selectedPlayer,
                onEditPressed: widget.onEdit == null
                    ? null
                    : () => widget.onEdit!(selectedPlayer),
                onCopyPressed: widget.onCopy == null
                    ? null
                    : () => widget.onCopy!(selectedPlayer),
                onDeletePressed: _deleteSelectedPlayer,
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
                  _loadPlayers();
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
                  hintText: 'Search Players',
                  onChanged: (value) => setState(() => _searchTerm = value),
                ),
                suggestionsBuilder: (context, controller) => visiblePlayers
                    .map(
                      (player) => ListTile(
                        title: Text(player.pName),
                        onTap: () {
                          controller.closeView(player.pName);
                          setState(() => _searchTerm = player.pName);
                          _selectPlayer(player, isWide);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          endDrawer: selectedPlayer == null
              ? null
              : isWide
              ? NotesDrawer(
                  key: ValueKey(
                    '${selectedPlayer.pId}:${selectedPlayer.pNotes}',
                  ),
                  initialValue: selectedPlayer.pNotes ?? '',
                  maxWidth: min(constraints.maxWidth - 50, 500),
                  onSaved: (value) => _saveNotes(selectedPlayer, value),
                )
              : PlayerNestedDrawer(
                  key: ValueKey(
                    '${selectedPlayer.pId}:${selectedPlayer.pNotes}',
                  ),
                  player: selectedPlayer,
                  maxWidth: min(constraints.maxWidth - 50, 500),
                  onEditPressed: widget.onEdit == null
                      ? null
                      : () => widget.onEdit!(selectedPlayer),
                  onCopyPressed: widget.onCopy == null
                      ? null
                      : () => widget.onCopy!(selectedPlayer),
                  onDeletePressed: _deleteSelectedPlayer,
                  onNotesSaved: _saveNotes,
                ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: isWide
                ? Row(
                    children: [
                      Expanded(flex: 3, child: playerList),
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
                : playerList,
          ),
        );
      },
    );
  }
}

/// Hosts the player form and persists a new, copied, or edited player.
class CreatePlayerWidget extends StatefulWidget {
  const CreatePlayerWidget({
    super.key,
    this.player,
    this.isEditing = false,
    this.onSaved,
  });

  final PlayerRow? player;
  final bool isEditing;
  final VoidCallback? onSaved;

  @override
  State<CreatePlayerWidget> createState() => _CreatePlayerWidgetState();
}

class _CreatePlayerWidgetState extends State<CreatePlayerWidget> {
  Future<void> _save(PlayerDraft draft) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await savePlayer(
        database,
        draft,
        existingId: widget.isEditing ? widget.player?.pId : null,
      );
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            '${widget.isEditing ? 'Saved' : 'Created'} ${draft.name}.',
          ),
        ),
      );
      if (mounted) widget.onSaved?.call();
    } catch (error) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('Could not save player: $error')),
        );
      }
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
                'Editing ${widget.player!.pName}',
                style: Theme.of(context).textTheme.headlineMedium,
              )
            : widget.player != null
            ? Text(
                'Copying ${widget.player!.pName}',
                style: Theme.of(context).textTheme.headlineMedium,
              )
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.spacingLarge),
        child: PlayerDetailsEdit(
          key: ValueKey('${widget.isEditing}:${widget.player?.pId ?? 'new'}'),
          player: widget.player,
          isEditing: widget.isEditing,
          onSubmit: _save,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:moonscribe/components/player_details.dart';
import 'package:moonscribe/components/player_card.dart';
import 'package:moonscribe/database/database.dart';
import 'package:moonscribe/theme/apptheme.dart';
import 'package:moonscribe/main.dart';

class PlayersPage extends StatefulWidget {
  const PlayersPage({super.key});

  @override
  State<PlayersPage> createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
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
        return const BrowsePlayerWidget();
      case 1:
        return const Center(child: Text('Create Player'));
      default:
        return const BrowsePlayerWidget();
    }
  }
}

class BrowsePlayerWidget extends StatefulWidget {
  const BrowsePlayerWidget({super.key});

  @override
  State<BrowsePlayerWidget> createState() => _BrowsePlayerWidget();
}

class _BrowsePlayerWidget extends State<BrowsePlayerWidget> {
  final players = [
    (name: 'Ravi', pClass: 'Rogue', level: 1),
    (name: 'Finn', pClass: 'Bard', level: 2),
    (name: 'Pax', pClass: 'Fighter', level: 3),
    (name: 'Theon', pClass: 'Fighter', level: 1),
    (name: 'Amalagh', pClass: 'Barbarian', level: 2),
    (name: 'Folkini', pClass: 'Soceror', level: 3),
  ];

  final ravi = PlayerDisplay(
    name: 'Ravi',
    pClass: 'Rogue',
    level: 5,
    originalCampaign: 'Finndalin',
    id: 1,
  );

  @override
  Widget build(BuildContext context) {
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
          child: SearchBar(
            hintText: 'Search Players',
            onChanged: (value) {
              // Implement search functionality here
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            StreamBuilder<List<Player>>(
              stream: database.select(database.players).watch(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(
                    flex: 3,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return Expanded(
                    flex: 3,
                    child: Center(child: Text('Error: ${snapshot.error}')),
                  );
                }

                final players = snapshot.data ?? [];

                return Expanded(
                  flex: 3,
                  child: SizedBox(
                    width: 350,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(right: 8),
                      itemCount: players.length,
                      itemBuilder: (context, index) {
                        final player = players[index];

                        return SizedBox(
                          height: 100,
                          child: PlayerCard(
                            name: player.pName,
                            pClass: player.pClass,
                            level: player.pLevel ?? 1,
                            originalCampaign: player.pOriginalCampaign,
                            selected: false,
                            onTap: () {},
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            Container(width: 8),
            Expanded(
              flex: 7,
              child: Container(
                alignment: Alignment.topCenter,
                child: PlayerDetails(player: ravi),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

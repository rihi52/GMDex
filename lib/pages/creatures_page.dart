import 'package:flutter/material.dart';
import '../theme/apptheme.dart';
import '../components/creature_card.dart';

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
                  right: BorderSide(
            color: AppColors.primary,
            width: 1,
          ))),
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
        Expanded(
          child: _buildContent(),
        )
      ],
    ));
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
  final creatures = [
      (
        name: 'Goblin',
        type: 'Humanoid',
        size: 'Small',
        cr: '1/4',
        source: 'Monster Manual'
      ),
      (
        name: 'Orc',
        type: 'Humanoid',
        size: 'Medium',
        cr: '1/2',
        source: 'Monster Manual'
      ),
      (
        name: 'Young Red Dragon',
        type: 'Dragon',
        size: 'Large',
        cr: '10',
        source: 'Monster Manual'
      ),
      (
        name: 'Glin',
        type: 'Humanoid',
        size: 'Small',
        cr: '1/4',
        source: 'Monster Manual'
      ),
      (
        name: 'rc',
        type: 'Humanoid',
        size: 'Medium',
        cr: '1/2',
        source: 'Monster Manual'
      ),
      (
        name: ' Red Dragon',
        type: 'Dragon',
        size: 'Large',
        cr: '10',
        source: 'Monster Manual'
      ),
      (
        name: 'Gob',
        type: 'Humanoid',
        size: 'Small',
        cr: '1/4',
        source: 'Monster Manual'
      ),
      (
        name: 'Or',
        type: 'Humanoid',
        size: 'Medium',
        cr: '1/2',
        source: 'Monster Manual'
      ),
      (
        name: 'Young Dragon',
        type: 'Dragon',
        size: 'Large',
        cr: '10',
        source: 'Monster Manual'
      ),
    ];
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            hintText: 'Search Creatures',
            onChanged: (value) {
              // Implement search functionality here
            },
          ),
        ),

      ),
      body: Padding( padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: 350,
          child:ListView.builder(
          itemCount: creatures.length,
          itemBuilder: (context, index){
            final creature = creatures[index];

            return SizedBox(
              height: 100,
              child: CreatureCards(
                name: creature.name,
                type: creature.type,
                size: creature.size,
                cr: creature.cr,
                source: creature.source,
                selected: _selectedIndex == index,
                onTap: () => setState(() => _selectedIndex = index),
              ),
            );
          }
        )
      )
    ),
    );
  }
}

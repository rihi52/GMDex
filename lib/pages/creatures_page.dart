import 'package:flutter/material.dart';
import '../theme/apptheme.dart';

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
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Colors.grey,
                  width: 2,
                )
              )
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
          Expanded(
            child: _buildContent(),
            )
        ],
      )
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Browse Creatures'),
      ),
    );
  }
}
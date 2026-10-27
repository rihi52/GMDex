import 'package:flutter/material.dart';
import 'package:gmdex/components/statblock.dart';
import 'package:gmdex/models/creature.dart';

class NestedDrawer extends StatefulWidget {
  const NestedDrawer({
    super.key,
    this.initialValue,
    this.maxWidth,
    this.onEditPressed,
    this.onCopyPressed,
    this.onDeletePressed,
    required this.onSaved,
    required this.creature,
  });

  final String? initialValue;
  final double? maxWidth;
  final VoidCallback? onEditPressed;
  final VoidCallback? onCopyPressed;
  final VoidCallback? onDeletePressed;
  final VoidCallback onSaved;
  final Creature creature;

  @override
  State<NestedDrawer> createState() => _NestedDrawerState();
}

class _NestedDrawerState extends State<NestedDrawer> {
  int _pageIndex = 0;
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  void _onChangePage(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: widget.maxWidth,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 0, label: Text('Statblock')),
                  ButtonSegment(value: 1, label: Text('Notes')),
                ],
                selected: {_pageIndex},
                onSelectionChanged: (selection) {
                  _onChangePage(selection.first);
                },
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  if (_pageIndex != index) {
                    setState(() => _pageIndex = index);
                  }
                },
                children: [
                  CreatureStatBlock(
                    creature: widget.creature,
                    onEditPressed: widget.onEditPressed,
                    onCopyPressed: widget.onCopyPressed,
                    onDeletePressed: widget.onDeletePressed,
                  ),
                  NotesSheet(
                    key: ValueKey(widget.creature.id ?? widget.creature.name),
                    creature: widget.creature,
                    initialValue: widget.initialValue,
                    onSaved: widget.onSaved,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotesDrawer extends StatelessWidget {
  const NotesDrawer({
    super.key,
    required this.creature,
    required this.onSaved,
    this.initialValue,
    this.maxWidth,
  });

  final Creature creature;
  final VoidCallback onSaved;
  final String? initialValue;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: maxWidth,
      child: SafeArea(
        child: NotesSheet(
          creature: creature,
          initialValue: initialValue,
          onSaved: onSaved,
        ),
      ),
    );
  }
}

class NotesSheet extends StatefulWidget {
  const NotesSheet({
    super.key,
    required this.creature,
    required this.onSaved,
    this.initialValue,
  });

  final Creature creature;
  final String? initialValue;
  final VoidCallback onSaved;

  @override
  State<NotesSheet> createState() => _NotesSheetState();
}

class _NotesSheetState extends State<NotesSheet> {
  final _formKey = GlobalKey<FormState>();
  late String _editValue;

  @override
  void initState() {
    super.initState();
    _editValue = widget.initialValue ?? widget.creature.notes ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: _editValue,
                expands: true,
                maxLines: null,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _editValue = value ?? '',
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: () {
                  _formKey.currentState!.save();
                  widget.onSaved();
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

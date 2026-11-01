// Reusable drawer and editor widgets for viewing and saving free-form notes.
//
// The page-view variant combines a caller-provided details panel with the
// same notes editor, while NotesEditor owns form state and save feedback.
import 'package:flutter/material.dart';
import 'package:gmdex/theme/apptheme.dart';

class NotesDrawer extends StatelessWidget {
  /// Shows the notes editor directly in a standard navigation drawer.
  const NotesDrawer({
    super.key,
    required this.initialValue,
    required this.onSaved,
    this.maxWidth,
  });

  final String initialValue;
  final Future<void> Function(String) onSaved;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: maxWidth,
      child: SafeArea(
        child: NotesEditor(initialValue: initialValue, onSaved: onSaved),
      ),
    );
  }
}

class NotesPageViewDrawer extends StatefulWidget {
  /// Combines a details panel and notes editor in a swipeable drawer.
  const NotesPageViewDrawer({
    super.key,
    required this.detailsLabel,
    required this.details,
    required this.initialValue,
    required this.onSaved,
    this.maxWidth,
  });

  final String detailsLabel;
  final Widget details;
  final String initialValue;
  final Future<void> Function(String) onSaved;
  final double? maxWidth;

  @override
  State<NotesPageViewDrawer> createState() => _NotesPageViewDrawerState();
}

class _NotesPageViewDrawerState extends State<NotesPageViewDrawer> {
  int _pageIndex = 0;
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    // Keep the segmented control and swipeable page view in sync.
    _controller = PageController();
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
                segments: [
                  ButtonSegment(value: 0, label: Text(widget.detailsLabel)),
                  const ButtonSegment(value: 1, label: Text('Notes')),
                ],
                selected: {_pageIndex},
                onSelectionChanged: (selection) {
                  _controller.animateToPage(
                    selection.first,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                  );
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
                  widget.details,
                  NotesEditor(
                    key: ValueKey(widget.initialValue),
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

class NotesEditor extends StatefulWidget {
  /// Edits a note and delegates persistence to the owning page.
  const NotesEditor({
    super.key,
    required this.initialValue,
    required this.onSaved,
  });

  final String initialValue;
  final Future<void> Function(String) onSaved;

  @override
  State<NotesEditor> createState() => _NotesEditorState();
}

class _NotesEditorState extends State<NotesEditor> {
  final _formKey = GlobalKey<FormState>();
  late String _value;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  Future<void> _save() async {
    // Disable repeat submissions while the asynchronous save is in progress.
    _formKey.currentState!.save();
    setState(() => _isSaving = true);
    try {
      await widget.onSaved(_value);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
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
                initialValue: _value,
                expands: true,
                maxLines: null,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _value = value ?? '',
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                child: Text('Save', style: Theme.of(context).textTheme.bodyLarge,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

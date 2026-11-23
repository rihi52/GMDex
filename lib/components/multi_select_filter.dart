import 'package:flutter/material.dart';

class MultiSelectFilter extends StatelessWidget {
  const MultiSelectFilter({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.labelFor,
  });

  final String label;
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;
  final String Function(String)? labelFor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          helperText: 'All when none selected',
          border: const OutlineInputBorder(),
        ),
        child: options.isEmpty
            ? const Text('All')
            : Wrap(
                spacing: 8,
                children: [
                  for (final option in options)
                    FilterChip(
                      label: Text(labelFor?.call(option) ?? option),
                      selected: selected.contains(option),
                      onSelected: (isSelected) {
                        final next = Set<String>.of(selected);
                        if (isSelected) {
                          next.add(option);
                        } else {
                          next.remove(option);
                        }
                        onChanged(next);
                      },
                    ),
                ],
              ),
      ),
    );
  }
}

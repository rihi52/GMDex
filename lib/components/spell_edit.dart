import 'package:flutter/material.dart';
import 'package:gmdex/database/database.dart';
import 'package:gmdex/models/spell.dart';
import 'package:gmdex/models/spell_draft.dart';
import 'package:gmdex/theme/apptheme.dart';

/// Form for creating, copying, or editing a spell.
class SpellEdit extends StatefulWidget {
  const SpellEdit({
    super.key,
    this.spell,
    required this.onSubmit,
    this.isEditing = false,
  });

  final SpellRow? spell;
  final ValueChanged<SpellDraft> onSubmit;
  final bool isEditing;

  @override
  State<SpellEdit> createState() => _SpellEditState();
}

class _SpellEditState extends State<SpellEdit> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late int _level;
  late String _school;
  late String _castingTime;
  late String _range;
  late String _components;
  late String _duration;
  late String _description;
  late String _higherLevel;

  static const _schools = <String, String>{
    'A': 'Abjuration',
    'C': 'Conjuration',
    'D': 'Divination',
    'E': 'Enchantment',
    'V': 'Evocation',
    'I': 'Illusion',
    'N': 'Necromancy',
    'T': 'Transmutation',
  };

  @override
  void initState() {
    super.initState();
    final row = widget.spell;
    final details = row == null ? null : Spell.fromRow(row);
    _name = row?.name ?? '';
    _level = row?.level ?? 0;
    _school = row?.school ?? 'A';
    _castingTime = details?.castingTime ?? '';
    _range = details?.range ?? '';
    _components = details?.components ?? '';
    _duration = details?.duration ?? '';
    _description = details?.description ?? '';
    _higherLevel = details?.higherLevel ?? '';
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    widget.onSubmit(
      SpellDraft(
        name: _name.trim(),
        level: _level,
        school: _school,
        castingTime: _castingTime.trim(),
        range: _range.trim(),
        components: _components.trim(),
        duration: _duration.trim(),
        description: _description.trim(),
        higherLevel: _higherLevel.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final row = widget.spell;
    final initialName = row == null
        ? ''
        : widget.isEditing
        ? row.name
        : '${row.name} (Copy)';
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardSelected,
            borderRadius: BorderRadius.circular(AppSpacing.cornerRadiusMedium),
          ),
          padding: const EdgeInsets.all(AppSpacing.spacingSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text(
                    widget.isEditing ? 'Save' : 'Create',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.spacingMedium),
              TextFormField(
                initialValue: initialName,
                style: Theme.of(context).textTheme.titleLarge,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Name',
                  labelStyle: Theme.of(context).textTheme.titleMedium,
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Name is required'
                    : null,
                onSaved: (value) => _name = value ?? '',
              ),
              const SizedBox(height: AppSpacing.spacingSmall),
              DropdownButtonFormField<int>(
                // initialValue: _level,
                hint: Text('Spell Level', style: Theme.of(context).textTheme.bodySmall,),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Level',
                  labelStyle: Theme.of(context).textTheme.bodySmall,
                ),
                items: [
                  for (var level = 0; level <= 9; level++)
                    DropdownMenuItem(
                      value: level,
                      child: Text(level == 0 ? 'Cantrip' : 'Level $level', style: Theme.of(context).textTheme.bodyMedium,),
                    ),
                ],
                selectedItemBuilder: (context) => [
                  for (var level = 0; level <= 9; level++)
                    Text(
                      level == 0 ? 'Cantrip' : 'Level $level',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _level = value);
                },
                validator: (v) => v == null ? 'Level is required' : null,
              ),
              const SizedBox(height: AppSpacing.spacingSmall),
              DropdownButtonFormField<String>(
                // initialValue: _school,
                hint: Text('Spell School', style: Theme.of(context).textTheme.bodySmall,),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'School',
                  labelStyle: Theme.of(context).textTheme.bodySmall,
                ),
                validator: (value) =>
                    value == null ? 'School is required' : null,
                items: [
                  if (!_schools.containsKey(_school))
                    DropdownMenuItem(
                      value: _school,
                      child: Text(spellSchoolName(_school), style: Theme.of(context).textTheme.bodyMedium,),
                    ),
                  for (final entry in _schools.entries)
                    DropdownMenuItem(
                      value: entry.key,
                      child: Text(entry.value, style: Theme.of(context).textTheme.bodyMedium,),
                    ),
                ],
                selectedItemBuilder: (context) => [
                  if (!_schools.containsKey(_school))
                    Text(
                      spellSchoolName(_school),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  for (final entry in _schools.entries)
                    Text(
                      entry.value,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _school = value);
                },
              ),
              _textField(
                label: 'Casting Time',
                initialValue: _castingTime,
                onSaved: (value) => _castingTime = value ?? '',
              ),
              _textField(
                label: 'Range',
                initialValue: _range,
                onSaved: (value) => _range = value ?? '',
              ),
              _textField(
                label: 'Components',
                initialValue: _components,
                onSaved: (value) => _components = value ?? '',
              ),
              _textField(
                label: 'Duration',
                initialValue: _duration,
                onSaved: (value) => _duration = value ?? '',
              ),
              _textField(
                label: 'Description',
                initialValue: _description,
                maxLines: 6,
                onSaved: (value) => _description = value ?? '',
              ),
              _textField(
                label: 'At Higher Levels',
                initialValue: _higherLevel,
                maxLines: 4,
                onSaved: (value) => _higherLevel = value ?? '',
              ),
              const SizedBox(height: AppSpacing.spacingMedium),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField({
    required String label,
    required String initialValue,
    required FormFieldSetter<String> onSaved,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacingSmall),
      child: TextFormField(
        initialValue: initialValue,
        maxLines: maxLines,
        style: Theme.of(context).textTheme.labelSmall,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: Theme.of(context).textTheme.titleSmall,
          border: const OutlineInputBorder(),
        ),
        onSaved: onSaved,
      ),
    );
  }
}

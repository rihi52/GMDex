import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gmdex/database/database.dart';
import 'package:gmdex/models/player_draft.dart';
import 'package:gmdex/theme/apptheme.dart';

class PlayerDetailsEdit extends StatefulWidget {
  const PlayerDetailsEdit({
    super.key,
    this.player,
    required this.onSubmit,
    this.isEditing = false,
  });

  final PlayerRow? player;
  final ValueChanged<PlayerDraft> onSubmit;
  final bool isEditing;

  @override
  State<PlayerDetailsEdit> createState() => _PlayerDetailsEditState();
}

class _PlayerDetailsEditState extends State<PlayerDetailsEdit> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _characterClass;
  late String _level;
  late String _hitPoints;
  late String _armorClass;
  late String _passivePerception;
  late String _campaign;

  @override
  void initState() {
    super.initState();
    final player = widget.player;
    _name = player?.pName ?? '';
    _characterClass = player?.pClass ?? '';
    _level = player?.pLevel?.toString() ?? '';
    _hitPoints = player?.pHitPoints?.toString() ?? '';
    _armorClass = player?.pArmorClass?.toString() ?? '';
    _passivePerception = player?.pPassivePerception?.toString() ?? '';
    _campaign = player?.pOriginalCampaign ?? '';
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    widget.onSubmit(
      PlayerDraft(
        name: _name,
        characterClass: _characterClass,
        level: int.tryParse(_level),
        hitPoints: int.tryParse(_hitPoints),
        armorClass: int.tryParse(_armorClass),
        passivePerception: int.tryParse(_passivePerception),
        originalCampaign: _campaign,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                initialValue: widget.player == null
                    ? null
                    : widget.isEditing
                    ? widget.player!.pName
                    : '${widget.player!.pName} (Copy)',
                style: Theme.of(context).textTheme.titleLarge,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                  labelStyle: Theme.of(context).textTheme.titleMedium,
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Name is required'
                    : null,
                onSaved: (value) => _name = value ?? '',
              ),
              _textField(
                label: 'Class',
                initialValue: _characterClass,
                required: true,
                onSaved: (value) => _characterClass = value ?? '',
              ),
              _textField(
                label: 'Level',
                initialValue: _level,
                numeric: true,
                onSaved: (value) => _level = value ?? '',
              ),
              _textField(
                label: 'Hit Points',
                initialValue: _hitPoints,
                numeric: true,
                onSaved: (value) => _hitPoints = value ?? '',
              ),
              _textField(
                label: 'Armor Class',
                initialValue: _armorClass,
                numeric: true,
                onSaved: (value) => _armorClass = value ?? '',
              ),
              _textField(
                label: 'Passive Perception',
                initialValue: _passivePerception,
                numeric: true,
                onSaved: (value) => _passivePerception = value ?? '',
              ),
              _textField(
                label: 'Original Campaign',
                initialValue: _campaign,
                onSaved: (value) => _campaign = value ?? '',
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
    bool required = false,
    bool numeric = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacingSmall),
      child: TextFormField(
        initialValue: initialValue,
        style: Theme.of(context).textTheme.labelSmall,
        keyboardType: numeric ? TextInputType.number : TextInputType.text,
        inputFormatters: numeric
            ? [FilteringTextInputFormatter.digitsOnly]
            : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: Theme.of(context).textTheme.titleSmall,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (required && (value == null || value.trim().isEmpty)) {
            return '$label is required';
          }
          if (numeric && value != null && value.trim().isNotEmpty) {
            final number = int.tryParse(value);
            if (number == null || number < 0) return 'Enter a valid $label';
          }
          return null;
        },
        onSaved: onSaved,
      ),
    );
  }
}

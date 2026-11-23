/// Editable spell fields collected by the spell editor.
class SpellDraft {
  const SpellDraft({
    required this.name,
    required this.level,
    required this.isRitual,
    required this.school,
    required this.castingTime,
    required this.range,
    required this.components,
    required this.duration,
    required this.description,
    required this.higherLevel,
  });

  final String name;
  final int level;
  final bool isRitual;
  final String school;
  final String castingTime;
  final String range;
  final String components;
  final String duration;
  final String description;
  final String higherLevel;
}

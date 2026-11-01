/// Immutable form data for creating or updating a player row.
///
/// Drafts separate UI input from Drift's generated row/companion types; the
/// writer performs trimming and persistence when the form is submitted.
class PlayerDraft {
  const PlayerDraft({
    required this.name,
    required this.characterClass,
    this.level,
    this.hitPoints,
    this.armorClass,
    this.passivePerception,
    this.originalCampaign,
  });

  final String name;
  final String characterClass;
  final int? level;
  final int? hitPoints;
  final int? armorClass;
  final int? passivePerception;
  final String? originalCampaign;
}

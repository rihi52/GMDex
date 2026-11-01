/// Rules and parsing helpers shared by creature display, editing, and storage.
///
/// Keeping these calculations in one place prevents the stat block and
/// database mapper from drifting into slightly different interpretations.
int abilityModifier(int score) => ((score - 10) / 2).floor();

/// Returns a saving-throw total only when the creature is proficient.
int? savingThrowBonus({
  required int abilityScore,
  required bool proficient,
  required int proficiencyBonus,
}) {
  if (!proficient) return null;

  return abilityModifier(abilityScore) + proficiencyBonus;
}

/// Calculates the standard proficiency bonus for a challenge rating.
num proficiencyBonusCalc(double challengeRating) =>
    challengeRating == 0 ? 2 : (1 + (challengeRating / 4).ceil());

/// Parses an integer/decimal or a fraction such as `1/2`.
///
/// Invalid numbers and zero denominators return `null` instead of throwing.
double? tryParseFraction(String s) {
  final parts = s.trim().split('/');
  if (parts.length == 2) {
    final numerator = double.tryParse(parts[0]);
    final denominator = double.tryParse(parts[1]);
    if (numerator == null || denominator == null || denominator == 0) return null;
    return numerator / denominator;
  }
  return double.tryParse(parts[0]);
}

/// Infers whether [modifier] and the proficiency bonus account for [score].
bool isSaveProficient(int score, int modifier, double proficiencyBonus) {
  if (modifier.toDouble() + proficiencyBonus >= score.toDouble()) {
    return true;
  }
  return false;
}

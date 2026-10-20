import 'package:flutter/material.dart';

int abilityModifier(int score) => ((score - 10) / 2).floor();

int? savingThrowBonus({
  required int abilityScore,
  required bool proficient,
  required int proficiencyBonus,
}) {
  if (!proficient) return null;

  return abilityModifier(abilityScore) + proficiencyBonus;
}

num proficiencyBonusCalc(double challengeRating) =>
    challengeRating == 0 ? 2 : (1 + (challengeRating / 4).ceil());

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

bool isSaveProficient(int score, int modifier, double proficiencyBonus) {
  if (modifier.toDouble() + proficiencyBonus >= score.toDouble()) {
    return true;
  }
  return false;
}

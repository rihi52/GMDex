import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color.fromARGB(255, 68, 22, 148);
  static const Color background = Color.fromARGB(255, 24, 24, 24);
  static const Color accent = Color.fromARGB(255, 101, 39, 207);
  static const Color appBlack = Colors.black;
  static const Color sideSelectGrey = Color.fromARGB(255, 35, 35, 35);
  static const Color hoverGrey = Colors.grey;
  static const Color cardBackground = Color.fromARGB(255, 68, 68, 68);
  static const Color cardSelected = Color.fromARGB(120, 255, 255, 255);

  AppColors._(); // Private constructor to prevent instantiation
}

class AppTheme {
  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primary,
        elevation: 0,
        shape: BorderDirectional(
          bottom: BorderSide(color: AppColors.primary, width: 1),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.appBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          minimumSize: const Size(250, 55),
          textStyle: GoogleFonts.metamorphous(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      listTileTheme: ListTileThemeData(
        dense: false,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        selectedColor: AppColors.accent,
        selectedTileColor: AppColors.sideSelectGrey,
        titleTextStyle: GoogleFonts.metamorphous(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.hoverGrey,
        ),
      ),

      textTheme: TextTheme(
        headlineLarge: GoogleFonts.modernAntiqua(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.8),
              offset: Offset(6, 6),
              blurRadius: 4,
            ),
          ],
        ),
        headlineMedium: GoogleFonts.modernAntiqua(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
        headlineSmall: GoogleFonts.modernAntiqua(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
        bodyMedium: GoogleFonts.metamorphous(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
        bodySmall: GoogleFonts.metamorphous(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.appBlack,
        ),
        labelSmall: GoogleFonts.metamorphous(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.appBlack,
        ),
        titleLarge: GoogleFonts.modernAntiqua(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.appBlack,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.4),
              offset: Offset(4, 4),
              blurRadius: 2,
            ),
          ],
        ),
        titleMedium: GoogleFonts.metamorphous(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.appBlack,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.4),
              offset: Offset(2, 2),
              blurRadius: 2,
            ),
          ],
        ),
        titleSmall: GoogleFonts.metamorphous(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.appBlack,
          fontStyle: FontStyle.italic,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.3),
              offset: Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class AppSpacing {
  static const double spacingSmall = 4;
  static const double cornerRadiusSmall = 4;
  static const double cornerRadiusMedium = 8;
  static const double abilityBoxes = 24;
}
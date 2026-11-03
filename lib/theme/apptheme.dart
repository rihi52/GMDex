// Shared color palette, typography, and sizing constants for the app UI.
//
// Keeping these values centralized helps pages and reusable components stay
// visually consistent as the design evolves.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gmdex/components/responsive_layout.dart';

class AppColors {
  /// Brand and surface colors used throughout the dark theme.
  static const Color primary = Color.fromARGB(255, 68, 22, 148);
  static const Color background = Color.fromARGB(255, 24, 24, 24);
  static const Color accent = Color.fromARGB(255, 101, 39, 207);
  static const Color appBlack = Colors.black;
  static const Color sideSelectGrey = Color.fromARGB(255, 35, 35, 35);
  static const Color hoverGrey = Colors.grey;
  static const Color cardBackground = Color.fromARGB(255, 97, 95, 95);
  static const Color cardSelected = Color.fromARGB(140, 255, 255, 255);
  static const Color filterText = Color.fromARGB(120, 255, 255, 255);
  static const Color playerCard = Color.fromARGB(255, 140, 109, 226);
  static const Color creatureCard = Color.fromARGB(255, 189, 109, 109);
  static const Color cardHighlight = Color.fromARGB(255, 0, 255, 0);
  static const Color cardHighlightFill = Color.fromARGB(255, 255, 0, 0);

  AppColors._(); // Private constructor to prevent instantiation
}

class AppTheme {
  /// Builds the app-wide dark theme, including component defaults and fonts.
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
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.cornerRadiusMedium)),
          // minimumSize: Size(250, 55),
          textStyle: GoogleFonts.metamorphous(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: AppColors.background,
          overlayColor: AppColors.primary,
          selectedBackgroundColor: AppColors.primary,
          alignment: Alignment.centerLeft,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.cornerRadiusMedium),
          ),
        ),
      ),

      listTileTheme: ListTileThemeData(
        dense: false,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.cornerRadiusMedium)),
        selectedColor: AppColors.accent,
        selectedTileColor: AppColors.sideSelectGrey,
        titleTextStyle: GoogleFonts.metamorphous(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.hoverGrey,
        ),
      ),

      textTheme: TextTheme(
        headlineLarge: GoogleFonts.metamorphous(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.8),
              offset: Offset(3, 3),
              blurRadius: 4,
            ),
          ],
        ),
        headlineMedium: GoogleFonts.metamorphous(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: AppColors.cardSelected,
        ),
        headlineSmall: GoogleFonts.metamorphous(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          color: AppColors.primary,
        ),
        bodyLarge: GoogleFonts.metamorphous(
          fontSize: ResponsiveLayout.isMobilePlatform ? 13 : 14,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
        bodyMedium: GoogleFonts.metamorphous(
          fontSize: ResponsiveLayout.isMobilePlatform ? 14 : 16,
          fontWeight: FontWeight.normal,
          color: AppColors.filterText,
        ),
        bodySmall: GoogleFonts.metamorphous(
          fontSize: ResponsiveLayout.isMobilePlatform ? 14 : 16,
          fontWeight: FontWeight.bold,
          color: AppColors.appBlack,
        ),
        labelSmall: GoogleFonts.metamorphous(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.appBlack,
        ),
        labelMedium: GoogleFonts.metamorphous(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.cardSelected,
        ),
        titleLarge: GoogleFonts.metamorphous(
          fontSize: 28,
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
        titleMedium: GoogleFonts.metamorphous(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.appBlack,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.4),
              offset: Offset(1, 1),
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
        displayMedium: GoogleFonts.metamorphous(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.cardSelected,
        ),
      ),
    );
  }
}

class AppSpacing {
  /// Reusable layout dimensions so components use consistent spacing/radii.
  static const double spacingSmall = 4;
  static const double spacingMedium = 8;
  static const double spacingLarge = 16;
  static const double spacingExtraLarge = 32;
  static const double cornerRadiusSmall = 4;
  static const double cornerRadiusMedium = 8;
  static const double cornerRadiusLarge = 16;
  static const double abilityBoxes = 24;
}

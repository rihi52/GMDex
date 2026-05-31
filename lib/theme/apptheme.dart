import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color.fromARGB(255, 68, 22, 148);
  static const Color background = Color.fromARGB(255, 24, 24, 24);
  static const Color accent = Color.fromARGB(255, 101, 39, 207);
  static const Color appBlack = Colors.black;
  static const Color selectGrey = Color.fromARGB(255, 35, 35, 35);
  static const Color hoverGrey = Colors.grey;

  AppColors._(); // Private constructor to prevent instantiation
}

class AppTheme {
  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,

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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        selectedColor: AppColors.accent,
        selectedTileColor: AppColors.selectGrey,
        titleTextStyle: GoogleFonts.metamorphous(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.hoverGrey,
        )
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.cinzelDecorative(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
        headlineMedium: GoogleFonts.cinzelDecorative(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
        bodyMedium: GoogleFonts.metamorphous(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      background: AppColors.background,
      surface: AppColors.surface,
      error: AppColors.error,
      onPrimary: AppColors.onPrimary,
      onSecondary: AppColors.onSecondary,
      onBackground: AppColors.onBackground,
      onSurface: AppColors.onSurface,
      onError: AppColors.onError,
    ),
    scaffoldBackgroundColor: AppColors.background,
    cardColor: AppColors.surface,
    dividerColor: AppColors.divider,
    hintColor: AppColors.textHint,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      titleTextStyle: GoogleFonts.poppins(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
      bodyLarge: GoogleFonts.lato(color: AppColors.textPrimary, fontSize: 16),
      bodyMedium: GoogleFonts.lato(color: AppColors.textSecondary, fontSize: 14),
      titleMedium: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
      titleSmall: GoogleFonts.poppins(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
    ),
    iconTheme: const IconThemeData(color: AppColors.textPrimary),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      background: AppColors.darkBackground,
      surface: AppColors.darkSurface,
      error: AppColors.error,
      onPrimary: AppColors.onPrimary,
      onSecondary: AppColors.onSecondary,
      onBackground: AppColors.darkOnBackground,
      onSurface: AppColors.darkOnSurface,
      onError: AppColors.onError,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    cardColor: AppColors.darkSurface,
    dividerColor: AppColors.darkDivider,
    hintColor: AppColors.darkTextSecondary,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.darkOnBackground,
      elevation: 0,
      titleTextStyle: GoogleFonts.poppins(
        color: AppColors.darkOnBackground,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      iconTheme: const IconThemeData(color: AppColors.darkOnSurface),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.poppins(color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold),
      bodyLarge: GoogleFonts.lato(color: AppColors.darkTextPrimary, fontSize: 16),
      bodyMedium: GoogleFonts.lato(color: AppColors.darkTextSecondary, fontSize: 14),
      titleMedium: GoogleFonts.poppins(color: AppColors.darkTextPrimary, fontWeight: FontWeight.w600),
      titleSmall: GoogleFonts.poppins(color: AppColors.darkTextSecondary, fontWeight: FontWeight.w500),
    ),
    iconTheme: const IconThemeData(color: AppColors.darkOnSurface),
  );
}
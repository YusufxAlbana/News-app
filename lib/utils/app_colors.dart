import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF2196F3);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color accent = Color(0xFFFF4081);

  // Background Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE0E0E0);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkDivider = Color(0xFF2C2C2C);
  
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB3B3B3);
  static const Color darkTextHint = Color(0xFF666666);

  // State Colors
  static const Color error = Color(0xFFB00020);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // On Colors (Text/Icon colors for contrast)
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFF000000);
  static const Color onBackground = Color(0xFF000000);
  static const Color onSurface = Color(0xFF000000);
  static const Color onError = Color(0xFFFFFFFF);

  // Dark Theme On Colors
  static const Color darkOnBackground = Color(0xFFFFFFFF);
  static const Color darkOnSurface = Color(0xFFFFFFFF);
  static const Color darkOnPrimary = Color(0xFF000000);
  static const Color darkOnSecondary = Color(0xFF000000);
  static const Color darkOnError = Color(0xFF000000);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF64B5F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [darkBackground, Color(0xFF1F1F1F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shimmer Effect Colors
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
}
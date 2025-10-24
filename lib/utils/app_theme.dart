import 'package:flutter/material.dart';
import 'package:news_app/utils/app_colors.dart';
class AppTheme {
  
static final ThemeData lightTheme = ThemeData(
  primaryColor: AppColors.primary,
  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.surface,
    background: AppColors.background,
    error: AppColors.error,
    onPrimary: AppColors.onPrimary,
    onSecondary: AppColors.onSecondary,
    onSurface: AppColors.onSurface,
    onBackground: AppColors.onBackground,
    onError: AppColors.onError,
  ),
  // ...other theme properties
);


static final ThemeData darkTheme = ThemeData(
  primaryColor: AppColors.primary,
  colorScheme: ColorScheme.dark(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.darkSurface,
    background: AppColors.darkBackground,
    error: AppColors.error,
    onPrimary: AppColors.darkOnPrimary,
    onSecondary: AppColors.darkOnSecondary,
    onSurface: AppColors.darkOnSurface,
    onBackground: AppColors.darkOnBackground,
    onError: AppColors.darkOnError,
  ),
  // ...other theme properties
);
}
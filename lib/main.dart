import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:news_app/bindings/app_bindings.dart';
import 'package:news_app/routes/app_pages.dart';
import 'package:news_app/utils/app_colors.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'News App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
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
        textTheme: TextTheme(
          displayLarge: TextStyle(color: AppColors.textPrimary),
          displayMedium: TextStyle(color: AppColors.textPrimary),
          displaySmall: TextStyle(color: AppColors.textPrimary),
          headlineMedium: TextStyle(color: AppColors.textPrimary),
          headlineSmall: TextStyle(color: AppColors.textPrimary),
          titleLarge: TextStyle(color: AppColors.textPrimary),
          bodyLarge: TextStyle(color: AppColors.textPrimary),
          bodyMedium: TextStyle(color: AppColors.textSecondary),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
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
        textTheme: TextTheme(
          displayLarge: TextStyle(color: AppColors.darkTextPrimary),
          displayMedium: TextStyle(color: AppColors.darkTextPrimary),
          displaySmall: TextStyle(color: AppColors.darkTextPrimary),
          headlineMedium: TextStyle(color: AppColors.darkTextPrimary),
          headlineSmall: TextStyle(color: AppColors.darkTextPrimary),
          titleLarge: TextStyle(color: AppColors.darkTextPrimary),
          bodyLarge: TextStyle(color: AppColors.darkTextPrimary),
          bodyMedium: TextStyle(color: AppColors.darkTextSecondary),
        ),
      ),
      themeMode: ThemeMode.system,
      initialRoute: Routes.SPLASH,
      getPages: AppPages.routes,
      initialBinding: AppBindings(),
    );
  }
}
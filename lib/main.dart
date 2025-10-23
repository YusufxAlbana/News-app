import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:news_app/bindings/app_bindings.dart';
import 'package:news_app/controllers/theme_controller.dart';
import 'package:news_app/routes/app_pages.dart';
import 'package:news_app/utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: 'assets/.env');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller diinisialisasi di AppBindings
    final ThemeController themeController = Get.put(ThemeController());

    return Obx(() => GetMaterialApp(
          title: 'News App',
          debugShowCheckedModeBanner: false,
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          initialBinding: AppBindings(),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.themeMode,
        ));
  }
}
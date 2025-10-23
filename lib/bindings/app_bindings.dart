import 'package:get/get.dart';
import 'package:news_app/controllers/news_controller.dart';
import 'package:news_app/controllers/theme_controller.dart';

class AppBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<NewsController>(NewsController(), permanent: true);
    Get.put<ThemeController>(ThemeController(), permanent: true);
  }
}

import 'package:get/get.dart';
import 'package:clash_royale_history/app/routes/app_routes.dart';
import 'package:clash_royale_history/app/feature/home/bindings/home_binding.dart';
import 'package:clash_royale_history/app/feature/home/views/home_page.dart';

abstract class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
  ];
}

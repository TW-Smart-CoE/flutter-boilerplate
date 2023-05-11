import 'package:first_demo/pages/home/home_page.dart';
import 'package:first_demo/pages/other/other_page.dart';
import 'package:first_demo/routes.dart';
import 'package:get/get.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomePage(),
      // bindings: [HomeBinding()]
    ),
    GetPage(
      name: Routes.OTHER,
      page: () => const OtherPage(),
      // bindings: [HomeBinding()]
    ),
  ];
}

// ignore_for_file: constant_identifier_names

import 'package:first_demo/pages/home/home_controller.dart';
import 'package:first_demo/pages/home/home_page.dart';
import 'package:first_demo/pages/other/other_page.dart';
import 'package:get/get.dart';

abstract class Routes {
  static const HOME = '/home';
  static const OTHER = '/other';
}

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomePage(),
      binding: homeBinding,
    ),
    GetPage(
      name: Routes.OTHER,
      page: () => const OtherPage(),
    ),
  ];
}

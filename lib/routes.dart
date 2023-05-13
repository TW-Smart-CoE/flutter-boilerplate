// ignore_for_file: constant_identifier_names

import 'package:first_demo/pages/counter/counter_controller.dart';
import 'package:first_demo/pages/counter/counter_page.dart';
import 'package:first_demo/pages/home/home_page.dart';
import 'package:get/get.dart';

abstract class Routes {
  static const HOME = '/home';
  static const COUNTER = '/counter';
}

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.HOME,
      page: () => HomePage(),
    ),
    GetPage(
      name: Routes.COUNTER,
      page: () => const CounterPage(),
      binding: counterBinding,
    ),
  ];
}

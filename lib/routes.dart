import 'package:first_demo/pages/animal_image/controller.dart';
import 'package:first_demo/pages/animal_image/page.dart';
import 'package:first_demo/pages/counter/controller.dart';
import 'package:first_demo/pages/counter/page.dart';
import 'package:first_demo/pages/moments/page.dart';
import 'package:get/get.dart';

abstract class Routes {
  static const COUNTER = '/counter';
  static const ANIMAL_IMAGE = '/animal_image';
  static const MOMENTS = '/moments';
}

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.COUNTER,
      page: () => const CounterPage(),
      binding: counterBinding,
    ),
    GetPage(
      name: Routes.ANIMAL_IMAGE,
      page: () => const AnimalImagePage(),
      binding: animalImageBinding,
    ),
    GetPage(
      name: Routes.MOMENTS,
      page: () => MomentsPage(),
    ),
  ];
}

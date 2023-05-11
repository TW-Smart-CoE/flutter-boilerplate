import 'package:get/get.dart';

final homeBinding = BindingsBuilder(() {
  Get.lazyPut<HomeController>(() => HomeController());
});

class HomeController extends GetxController {
  var count = 0.obs;

  increment() => count++;
}

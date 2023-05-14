import 'package:get/get.dart';

final counterBinding = BindingsBuilder(() {
  Get.lazyPut(
    () => CounterController(),
  );
});

class CounterController extends GetxController {
  var count = 0.obs;

  increment() => count++;

  decrement() => count--;
}

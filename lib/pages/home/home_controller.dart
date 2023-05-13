import 'package:first_demo/common/utils/logger.dart';
import 'package:first_demo/pages/home/home_repository.dart';
import 'package:get/get.dart';

final homeBinding = BindingsBuilder(() {
  Get.lazyPut(
    () => HomeController(HomeRepository(Get.find())),
  );
});

class HomeController extends GetxController {
  final HomeRepository _repository;

  var count = 0.obs;

  HomeController(this._repository);

  increment() => count++;

  @override
  void onInit() async {
    super.onInit();
    var dogs = await _repository.getDogs();
    logger.d(dogs);
  }
}

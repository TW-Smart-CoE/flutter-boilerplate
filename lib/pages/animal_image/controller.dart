import 'package:first_demo/common/network/animal/model/animal.dart';
import 'package:first_demo/common/utils/logger.dart';
import 'package:first_demo/pages/animal_image/repository.dart';
import 'package:get/get.dart';

final animalImageBinding = BindingsBuilder(() {
  Get.lazyPut(() => AnimalImageController(AnimalImageRepository(Get.find())));
});

class AnimalImageController extends GetxController {
  final AnimalImageRepository _repository;

  final animals = Rx<List<Animal>?>(null);

  AnimalImageController(this._repository);

  @override
  void onInit() async {
    super.onInit();
    try {
      animals.value = await _repository.getAnimals();
    } catch (e) {
      logger.e(e);
      Get.snackbar('Network Error', e.toString());
    }
  }
}

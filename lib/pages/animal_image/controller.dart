import 'package:first_demo/common/async_loader/data_controller.dart';
import 'package:first_demo/common/network/animal/model/animal.dart';
import 'package:first_demo/pages/animal_image/repository.dart';
import 'package:get/get.dart';

final animalImageBinding = BindingsBuilder(() {
  Get.lazyPut(() => AnimalImageController(AnimalImageRepository()));
});

class AnimalImageController extends DataController<List<Animal>> {
  final AnimalImageRepository _repository;

  AnimalImageController(this._repository);

  @override
  Future<List<Animal>> fetch() => _repository.getAnimals();
}

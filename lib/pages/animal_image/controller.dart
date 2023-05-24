import 'package:first_demo/common/async_loader/data_controller.dart';
import 'package:first_demo/common/network/animal/model/animal.dart';
import 'package:first_demo/pages/animal_image/repository.dart';

class AnimalImageController extends DataController<List<Animal>> {
  final AnimalImageRepository _repository;

  AnimalImageController({AnimalImageRepository? animalImageRepository})
      : _repository = animalImageRepository ?? AnimalImageRepository();

  @override
  Future<List<Animal>> fetch() => _repository.getAnimals();
}

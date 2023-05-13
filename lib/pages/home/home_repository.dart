import 'package:first_demo/common/network/animal/animal_api.dart';
import 'package:first_demo/common/network/animal/model/animal.dart';

class HomeRepository {
  final AnimalApi _animalApi;

  HomeRepository(this._animalApi);

  Future<List<Animal>> getCats() => _animalApi.getAnimals('cat');

  Future<List<Animal>> getDogs() => _animalApi.getAnimals('dog');
}

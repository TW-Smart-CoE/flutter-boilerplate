import 'dart:math';

import 'package:first_demo/common/utils/http_client.dart';
import 'package:first_demo/pages/animal_image/api.dart';
import 'package:first_demo/pages/animal_image/model/animal.dart';

class AnimalImageRepository {
  final AnimalApi _animalApi;

  AnimalImageRepository({AnimalApi? animalApi})
      : _animalApi = animalApi ?? AnimalApi(httpClient.dio);

  Future<List<Animal>> getCats() => _animalApi.getAnimals('cat');

  Future<List<Animal>> getDogs() => _animalApi.getAnimals('dog');

  Future<List<Animal>> getAnimals() =>
      Future.wait([getCats(), getDogs()]).then((value) {
        final list = [...value[0].sublist(1), ...value[1].sublist(1)];
        list.shuffle(Random());
        return list;
      });
}

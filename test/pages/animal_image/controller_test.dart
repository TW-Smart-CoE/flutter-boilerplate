import 'package:first_demo/common/network/animal/model/animal.dart';
import 'package:first_demo/pages/animal_image/controller.dart';
import 'package:first_demo/pages/animal_image/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'controller_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AnimalImageRepository>()])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  final List<Animal> animals = List.filled(
      5,
      const Animal(
        id: 'id',
        url: 'image_url',
        width: 100,
        height: 100,
      ));
  final repository = MockAnimalImageRepository();

  late AnimalImageController controller;

  setUp(() {
    controller = AnimalImageController(repository);
  });

  test('animals should start at null', () {
    // then
    expect(controller.animals(), null);
  });

  test('animals should be correct if load success', () async {
    // given
    when(repository.getAnimals()).thenAnswer((_) async => animals);

    // when
    await controller.load();

    // then
    expect(controller.animals(), animals);
  });

  test('animals should be null if load failed', () async {
    // given
    when(repository.getAnimals()).thenThrow(Exception());

    // when
    await controller.load();

    // then
    expect(controller.animals(), null);
  });
}

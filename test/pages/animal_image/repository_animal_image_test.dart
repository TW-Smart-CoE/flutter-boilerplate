import 'package:first_demo/pages/animal_image/api_animal_image.dart';
import 'package:first_demo/pages/animal_image/model_animal_image.dart';
import 'package:first_demo/pages/animal_image/repository_animal_image.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'repository_animal_image_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AnimalApi>()])
void main() {
  late MockAnimalApi mockApi;
  late AnimalImageRepository repository;

  final cats = List.generate(
    5,
    (i) => Animal('cat_$i', 'cat_url_$i', 100, 100),
  );

  final dogs = List.generate(
    5,
    (i) => Animal('dog_$i', 'dog_url_$i', 100, 100),
  );

  setUp(() {
    mockApi = MockAnimalApi();
    repository = AnimalImageRepository(animalApi: mockApi);
  });

  test('should call api with "cat"', () async {
    when(mockApi.getAnimals('cat')).thenAnswer((_) async => cats);

    final result = await repository.getCats();

    expect(result, cats);
    verify(mockApi.getAnimals('cat')).called(1);
  });

  test('should call api with "dog"', () async {
    when(mockApi.getAnimals('dog')).thenAnswer((_) async => dogs);

    final result = await repository.getDogs();

    expect(result, dogs);
    verify(mockApi.getAnimals('dog')).called(1);
  });

  test('should combine cats and dogs excluding first element of each', () async {
    when(mockApi.getAnimals('cat')).thenAnswer((_) async => cats);
    when(mockApi.getAnimals('dog')).thenAnswer((_) async => dogs);

    final result = await repository.getAnimals();

    // First element of each list is excluded (sublist(1))
    expect(result.length, (cats.length - 1) + (dogs.length - 1));
    // All remaining cats and dogs should be present
    for (final cat in cats.sublist(1)) {
      expect(result.contains(cat), isTrue);
    }
    for (final dog in dogs.sublist(1)) {
      expect(result.contains(dog), isTrue);
    }
  });

  test('should call both cat and dog APIs', () async {
    when(mockApi.getAnimals('cat')).thenAnswer((_) async => cats);
    when(mockApi.getAnimals('dog')).thenAnswer((_) async => dogs);

    await repository.getAnimals();

    verify(mockApi.getAnimals('cat')).called(1);
    verify(mockApi.getAnimals('dog')).called(1);
  });

  test('should throw when cat API fails', () async {
    when(mockApi.getAnimals('cat')).thenThrow(Exception('cat API error'));
    when(mockApi.getAnimals('dog')).thenAnswer((_) async => dogs);

    expect(() => repository.getAnimals(), throwsException);
  });

  test('should throw when dog API fails', () async {
    when(mockApi.getAnimals('cat')).thenAnswer((_) async => cats);
    when(mockApi.getAnimals('dog')).thenThrow(Exception('dog API error'));

    expect(() => repository.getAnimals(), throwsException);
  });
}

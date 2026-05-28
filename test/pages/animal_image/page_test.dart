import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:first_demo/pages/animal_image/model/animal.dart';
import 'package:first_demo/pages/animal_image/page.dart';
import 'package:first_demo/pages/animal_image/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../common/utils/test_util.dart';
import 'page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AnimalImageRepository>()])
void main() {
  late MockAnimalImageRepository mockRepository;

  final animals = List.generate(
    6,
    (i) => Animal('id_$i', 'https://example.com/animal_$i.jpg', 100, 100),
  );

  setUp(() {
    mockRepository = MockAnimalImageRepository();
  });

  testPage('should show loading indicator initially',
      (tester, buildPage) async {
    final completer = Completer<List<Animal>>();
    when(mockRepository.getAnimals()).thenAnswer((_) => completer.future);

    await tester.pumpWidget(
      buildPage(AnimalImagePage(repository: mockRepository)),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(animals);
    await tester.pumpAndSettle();
  });

  testPage('should show grid of animals when data loads successfully',
      (tester, buildPage) async {
    when(mockRepository.getAnimals()).thenAnswer((_) async => animals);

    await tester.pumpWidget(
      buildPage(AnimalImagePage(repository: mockRepository)),
    );
    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsNWidgets(animals.length));
  });

  testPage('should show error view when fetch fails',
      (tester, buildPage) async {
    when(mockRepository.getAnimals())
        .thenAnswer((_) async => throw Exception('Network error'));

    await tester.pumpWidget(
      buildPage(AnimalImagePage(repository: mockRepository)),
    );
    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsNothing);
    expect(find.byType(FilledButton), findsOneWidget);
  });

  testPage('should show empty grid when animal list is empty',
      (tester, buildPage) async {
    when(mockRepository.getAnimals()).thenAnswer((_) async => []);

    await tester.pumpWidget(
      buildPage(AnimalImagePage(repository: mockRepository)),
    );
    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsNothing);
  });

  testPage('should show AppBar with title', (tester, buildPage) async {
    when(mockRepository.getAnimals()).thenAnswer((_) async => animals);

    await tester.pumpWidget(
      buildPage(AnimalImagePage(repository: mockRepository)),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppBar), findsOneWidget);
  });
}

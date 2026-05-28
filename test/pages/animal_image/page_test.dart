import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:first_demo/pages/animal_image/model/animal.dart';
import 'package:first_demo/pages/animal_image/page.dart';
import 'package:first_demo/pages/animal_image/repository.dart';
import 'package:first_demo/res/string/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fquery/fquery.dart';
import 'package:fquery_core/fquery_core.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AnimalImageRepository>()])
void main() {
  late MockAnimalImageRepository mockRepository;
  late QueryCache queryCache;

  final animals = List.generate(
    6,
    (i) => Animal('id_$i', 'https://example.com/animal_$i.jpg', 100, 100),
  );

  setUp(() {
    mockRepository = MockAnimalImageRepository();
    queryCache = QueryCache();
  });

  Widget buildTestApp(Widget child) {
    return CacheProvider(
      cache: queryCache,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: child,
      ),
    );
  }

  /// Dispose the fquery widget tree and advance past GC timers
  /// to avoid "A Timer is still pending" errors.
  Future<void> disposeQueryCache(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(minutes: 6));
  }

  testWidgets('should show loading indicator initially', (tester) async {
    final completer = Completer<List<Animal>>();
    when(mockRepository.getAnimals()).thenAnswer((_) => completer.future);

    await tester.pumpWidget(
      buildTestApp(AnimalImagePage(repository: mockRepository)),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(animals);
    await tester.pumpAndSettle();
    await disposeQueryCache(tester);
  });

  testWidgets('should show grid of animals when data loads successfully',
      (tester) async {
    when(mockRepository.getAnimals()).thenAnswer((_) async => animals);

    await tester.pumpWidget(
      buildTestApp(AnimalImagePage(repository: mockRepository)),
    );
    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsNWidgets(animals.length));

    await disposeQueryCache(tester);
  });

  testWidgets('should show error view when fetch fails', (tester) async {
    when(mockRepository.getAnimals())
        .thenAnswer((_) async => throw Exception('Network error'));

    await tester.pumpWidget(
      buildTestApp(AnimalImagePage(repository: mockRepository)),
    );
    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsNothing);
    expect(find.byType(FilledButton), findsOneWidget);

    await disposeQueryCache(tester);
  });

  testWidgets('should show empty grid when animal list is empty',
      (tester) async {
    when(mockRepository.getAnimals()).thenAnswer((_) async => []);

    await tester.pumpWidget(
      buildTestApp(AnimalImagePage(repository: mockRepository)),
    );
    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsNothing);

    await disposeQueryCache(tester);
  });

  testWidgets('should show AppBar with title', (tester) async {
    when(mockRepository.getAnimals()).thenAnswer((_) async => animals);

    await tester.pumpWidget(
      buildTestApp(AnimalImagePage(repository: mockRepository)),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppBar), findsOneWidget);

    await disposeQueryCache(tester);
  });
}

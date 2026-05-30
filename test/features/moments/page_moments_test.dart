import 'dart:async';

import 'package:first_demo/features/moments/page_moments.dart';
import 'package:first_demo/features/moments/repository_moments.dart';
import 'package:first_demo/features/moments/tweet/model/comment.dart';
import 'package:first_demo/features/moments/tweet/model/image.dart' as model;
import 'package:first_demo/features/moments/tweet/model/sender.dart';
import 'package:first_demo/features/moments/tweet/model/tweet.dart';
import 'package:first_demo/features/moments/user/model_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test_utils/test_util.dart';
import 'page_moments_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MomentsRepository>()])
void main() {
  late MockMomentsRepository mockRepository;

  const user = User('john', 'John Doe', 'https://avatar.url', 'https://profile.url');
  const sender = Sender('john', 'John Doe', 'https://avatar.url');
  final tweets = [
    const Tweet(
      'Hello World',
      [model.Image('https://img.url')],
      sender,
      [Comment('Nice!', Sender('alice', 'Alice', 'https://alice.url'))],
    ),
    const Tweet('Second tweet', null, sender, null),
  ];
  final momentsData = MomentsData(user: user, tweets: tweets);

  setUp(() {
    mockRepository = MockMomentsRepository();
  });

  testPage('should show loading indicator initially', (tester, buildPage) async {
    final completer = Completer<MomentsData>();
    when(mockRepository.getMoments()).thenAnswer((_) => completer.future);

    await tester.pumpWidget(
      buildPage(MomentsPage(repository: mockRepository)),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(momentsData);
    await tester.pumpAndSettle();
  });

  testPage('should show AppBar with moments title', (tester, buildPage) async {
    when(mockRepository.getMoments()).thenAnswer((_) async => momentsData);

    await tester.pumpWidget(
      buildPage(MomentsPage(repository: mockRepository)),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Moments'), findsOneWidget);
  });

  testPage('should show user nick name when data loaded', (tester, buildPage) async {
    when(mockRepository.getMoments()).thenAnswer((_) async => momentsData);

    await tester.pumpWidget(
      buildPage(MomentsPage(repository: mockRepository)),
    );
    await tester.pumpAndSettle();

    expect(find.text('John Doe'), findsWidgets);
  });

  testPage('should show tweet content', (tester, buildPage) async {
    when(mockRepository.getMoments()).thenAnswer((_) async => momentsData);

    await tester.pumpWidget(
      buildPage(MomentsPage(repository: mockRepository)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Hello World'), findsOneWidget);
  });

  testPage('should show error view when fetch fails', (tester, buildPage) async {
    when(mockRepository.getMoments()).thenAnswer((_) async => throw Exception('Network error'));

    await tester.pumpWidget(
      buildPage(MomentsPage(repository: mockRepository)),
    );
    await tester.pumpAndSettle();

    expect(find.byType(FilledButton), findsOneWidget);
  });

  testPage('should show comment content', (tester, buildPage) async {
    when(mockRepository.getMoments()).thenAnswer((_) async => momentsData);

    await tester.pumpWidget(
      buildPage(MomentsPage(repository: mockRepository)),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Nice!'), findsOneWidget);
  });
}

import 'package:first_demo/features/moments/api_moments.dart';
import 'package:first_demo/features/moments/tweet/model/image.dart';
import 'package:first_demo/features/moments/tweet/model/sender.dart';
import 'package:first_demo/features/moments/tweet/model/tweet.dart';
import 'package:first_demo/features/moments/tweet/repository_tweet.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'repository_tweet_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MomentsApi>()])
void main() {
  late MockMomentsApi mockApi;
  late TweetRepository repository;

  const sender = Sender('user1', 'Nick', 'https://avatar.url');

  final validTweets = [
    const Tweet('Hello', null, sender, null),
    const Tweet('World', [Image('https://img.url')], sender, null),
    const Tweet(null, [Image('https://img2.url')], sender, null),
  ];

  final invalidTweets = [
    const Tweet(null, null, sender, null), // no content, no images
    const Tweet('text', null, null, null), // no sender
    const Tweet(null, [], null, null), // no sender, empty images
    const Tweet('', null, sender, null), // empty content, no images
    const Tweet('', [], sender, null), // empty content, empty images
  ];

  setUp(() {
    mockApi = MockMomentsApi();
    repository = TweetRepository(momentsApi: mockApi);
  });

  group('filtering', () {
    test('should filter out tweets without sender', () async {
      when(mockApi.getTweets()).thenAnswer((_) async => [
            const Tweet('content', null, null, null),
            const Tweet('content', null, sender, null),
          ]);

      final result = await repository.getTweets(0, 20);

      expect(result.length, 1);
      expect(result[0].sender, sender);
    });

    test('should filter out tweets without content and images', () async {
      when(mockApi.getTweets()).thenAnswer((_) async => [
            const Tweet(null, null, sender, null),
            const Tweet('', null, sender, null),
            const Tweet(null, [], sender, null),
            const Tweet('valid', null, sender, null),
          ]);

      final result = await repository.getTweets(0, 20);

      expect(result.length, 1);
      expect(result[0].content, 'valid');
    });

    test('should keep tweets with images but no content', () async {
      when(mockApi.getTweets()).thenAnswer((_) async => [
            const Tweet(null, [Image('url')], sender, null),
          ]);

      final result = await repository.getTweets(0, 20);

      expect(result.length, 1);
    });

    test('should filter all invalid tweets', () async {
      when(mockApi.getTweets()).thenAnswer((_) async => invalidTweets);

      final result = await repository.getTweets(0, 20);

      expect(result, isEmpty);
    });

    test('should keep all valid tweets', () async {
      when(mockApi.getTweets()).thenAnswer((_) async => validTweets);

      final result = await repository.getTweets(0, 20);

      expect(result.length, validTweets.length);
    });
  });

  group('pagination', () {
    test('should return first N tweets', () async {
      when(mockApi.getTweets()).thenAnswer((_) async => validTweets);

      final result = await repository.getTweets(0, 2);

      expect(result.length, 2);
      expect(result[0].content, 'Hello');
      expect(result[1].content, 'World');
    });

    test('should return tweets from start index', () async {
      when(mockApi.getTweets()).thenAnswer((_) async => validTweets);

      final result = await repository.getTweets(1, 2);

      expect(result.length, 2);
      expect(result[0].content, 'World');
    });

    test('should handle count exceeding list length', () async {
      when(mockApi.getTweets()).thenAnswer((_) async => validTweets);

      final result = await repository.getTweets(0, 100);

      expect(result.length, validTweets.length);
    });

    test('should return empty when start index equals list length', () async {
      when(mockApi.getTweets()).thenAnswer((_) async => validTweets);

      final result = await repository.getTweets(validTweets.length, 10);

      expect(result, isEmpty);
    });
  });

  group('caching', () {
    test('should call api only once for consecutive requests', () async {
      when(mockApi.getTweets()).thenAnswer((_) async => validTweets);

      await repository.getTweets(0, 20);
      await repository.getTweets(0, 20);

      verify(mockApi.getTweets()).called(1);
    });

    test('should return cached data on second call', () async {
      when(mockApi.getTweets()).thenAnswer((_) async => validTweets);

      final first = await repository.getTweets(0, 20);
      final second = await repository.getTweets(0, 20);

      expect(first.length, second.length);
    });
  });

  group('error handling', () {
    test('should propagate api error', () async {
      when(mockApi.getTweets()).thenThrow(Exception('Network error'));

      expect(() => repository.getTweets(0, 20), throwsException);
    });
  });
}

import 'package:first_demo/features/moments/tweet/model/sender.dart';
import 'package:first_demo/features/moments/tweet/model/tweet.dart';
import 'package:first_demo/features/moments/tweet/store_tweet.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late TweetStore store;

  final tweets = List.generate(
    5,
    (i) => Tweet('content_$i', null, const Sender('user', 'nick', 'avatar'), null),
  );

  setUp(() {
    store = TweetStore();
  });

  test('should have no cache initially', () {
    expect(store.tweets, isNull);
    expect(store.isCacheAvailable(), isFalse);
  });

  test('should save and retrieve cache', () {
    store.saveCache(tweets);

    expect(store.tweets, tweets);
    expect(store.isCacheAvailable(), isTrue);
  });

  test('should return saved tweets', () {
    store.saveCache(tweets);

    expect(store.tweets!.length, 5);
    expect(store.tweets![0].content, 'content_0');
  });

  test('should overwrite previous cache', () {
    store.saveCache(tweets);

    final newTweets = [
      const Tweet('new_content', null, Sender('u', 'n', 'a'), null),
    ];
    store.saveCache(newTweets);

    expect(store.tweets!.length, 1);
    expect(store.tweets![0].content, 'new_content');
  });
}

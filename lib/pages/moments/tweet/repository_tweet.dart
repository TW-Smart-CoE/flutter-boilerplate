import 'package:first_demo/pages/moments/api_moments.dart';
import 'package:first_demo/pages/moments/tweet/model/tweet.dart';
import 'package:first_demo/pages/moments/tweet/store_tweet.dart';
import 'package:first_demo/shared/http_client.dart';

class TweetRepository {
  final MomentsApi _momentsApi;
  final _tweetStore = TweetStore();

  TweetRepository({MomentsApi? momentsApi})
      : _momentsApi = momentsApi ?? MomentsApi(httpClient.dio);

  Future<List<Tweet>> getTweets(int startIndex, int count) async {
    final List<Tweet> tweetList;
    if (_tweetStore.isCacheAvailable()) {
      tweetList = _tweetStore.tweets!;
    } else {
      final tweetsFromNet = await _momentsApi.getTweets();
      final filteredList = _filterTweetList(tweetsFromNet);
      _tweetStore.saveCache(filteredList);
      tweetList = filteredList;
    }
    return _cutTweetsList(startIndex, count, tweetList);
  }

  static List<Tweet> _filterTweetList(List<Tweet> tweetList) {
    final filteredList = <Tweet>[];
    for (final tweet in tweetList) {
      if (tweet.sender != null &&
          (tweet.content?.isNotEmpty == true || tweet.images?.isNotEmpty == true)) {
        filteredList.add(tweet);
      }
    }
    return filteredList;
  }

  static List<Tweet> _cutTweetsList(int startIndex, int count, List<Tweet> tweetList) {
    var endIndex = startIndex + count;
    if (endIndex >= tweetList.length) {
      endIndex = tweetList.length;
    }
    return tweetList.sublist(startIndex, endIndex);
  }
}

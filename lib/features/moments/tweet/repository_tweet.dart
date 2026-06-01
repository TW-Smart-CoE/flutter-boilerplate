import 'package:first_demo/features/moments/api_moments.dart';
import 'package:first_demo/features/moments/tweet/model/tweet.dart';
import 'package:first_demo/shared/http_client.dart';

class TweetRepository {
  final MomentsApi _momentsApi;

  TweetRepository({MomentsApi? momentsApi})
      : _momentsApi = momentsApi ?? MomentsApi(httpClient.dio);

  Future<List<Tweet>> getTweets(int startIndex, int count) async {
    final tweetsFromNet = await _momentsApi.getTweets();
    final tweetList = _filterTweetList(tweetsFromNet);
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

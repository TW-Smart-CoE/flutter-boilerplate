import 'package:first_demo/features/moments/tweet/model/tweet.dart';
import 'package:first_demo/features/moments/tweet/repository_tweet.dart';
import 'package:first_demo/features/moments/user/model_user.dart';
import 'package:first_demo/features/moments/user/repository_user.dart';

class MomentsData {
  final User user;
  final List<Tweet> tweets;

  const MomentsData({required this.user, required this.tweets});
}

class MomentsRepository {
  final UserRepository _userRepository;
  final TweetRepository _tweetRepository;

  MomentsRepository({
    UserRepository? userRepository,
    TweetRepository? tweetRepository,
  })  : _userRepository = userRepository ?? UserRepository(),
        _tweetRepository = tweetRepository ?? TweetRepository();

  Future<MomentsData> getMoments() async {
    final results = await Future.wait([
      _userRepository.getUser(),
      _tweetRepository.getTweets(0, 20),
    ]);
    return MomentsData(
      user: results[0] as User,
      tweets: results[1] as List<Tweet>,
    );
  }
}

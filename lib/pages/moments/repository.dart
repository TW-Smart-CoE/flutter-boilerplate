import 'package:first_demo/pages/moments/tweet/model/tweet.dart';
import 'package:first_demo/pages/moments/tweet/repository.dart';
import 'package:first_demo/pages/moments/user/model/user.dart';
import 'package:first_demo/pages/moments/user/repository.dart';

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

import 'package:first_demo/common/async_loader/data_controller.dart';
import 'package:first_demo/common/network/moments/model/tweet.dart';
import 'package:first_demo/pages/moments/tweet/repository.dart';

class TweetController extends DataController<List<Tweet>> {
  final TweetRepository _repository;

  TweetController({TweetRepository? repository})
      : _repository = repository ?? TweetRepository();

  @override
  Future<List<Tweet>> fetch() => _repository.getTweets(0, 20);
}

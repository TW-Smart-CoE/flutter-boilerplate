import 'package:dio/dio.dart';
import 'package:first_demo/common/network/moments/model/tweet.dart';
import 'package:first_demo/common/network/moments/model/user.dart';
import 'package:retrofit/retrofit.dart';

part 'api.g.dart';

@RestApi(baseUrl: 'https://tw-mobile-xian.github.io/moments-data/')
abstract class MomentsApi {
  factory MomentsApi(Dio dio, {String baseUrl}) = _MomentsApi;

  @GET('user.json')
  Future<User> getUser();

  @GET('tweets.json')
  Future<List<Tweet>> getTweets();
}

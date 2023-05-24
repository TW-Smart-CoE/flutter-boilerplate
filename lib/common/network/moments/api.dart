import 'package:dio/dio.dart';
import 'package:first_demo/common/network/moments/model/tweet.dart';
import 'package:first_demo/common/network/moments/model/user.dart';
import 'package:first_demo/common/utils/environment_config.dart';
import 'package:retrofit/retrofit.dart';

part 'api.g.dart';

@RestApi()
abstract class MomentsApi {
  factory MomentsApi(Dio dio) => _MomentsApi(dio, baseUrl: Env['BASE_URL']);

  @GET('user.json')
  Future<User> getUser();

  @GET('tweets.json')
  Future<List<Tweet>> getTweets();
}

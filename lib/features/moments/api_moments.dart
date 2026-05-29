import 'package:dio/dio.dart';
import 'package:first_demo/features/moments/tweet/model/tweet.dart';
import 'package:first_demo/features/moments/user/model_user.dart';
import 'package:first_demo/shared/environment_config.dart';
import 'package:retrofit/retrofit.dart';

part 'api_moments.g.dart';

@RestApi()
abstract class MomentsApi {
  factory MomentsApi(Dio dio) => _MomentsApi(dio, baseUrl: Env['BASE_URL']);

  @GET('user.json')
  Future<User> getUser();

  @GET('tweets.json')
  Future<List<Tweet>> getTweets();
}

import 'package:first_demo/features/moments/api_moments.dart';
import 'package:first_demo/features/moments/user/model_user.dart';
import 'package:first_demo/shared/http_client.dart';

class UserRepository {
  final MomentsApi _momentsApi;

  UserRepository({MomentsApi? momentsApi}) : _momentsApi = momentsApi ?? MomentsApi(httpClient.dio);

  Future<User> getUser() => _momentsApi.getUser();
}

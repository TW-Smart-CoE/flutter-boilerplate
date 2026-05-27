import 'package:first_demo/common/di/service_locator.dart';
import 'package:first_demo/common/network/moments/api.dart';
import 'package:first_demo/common/network/moments/model/user.dart';

class UserRepository {
  final MomentsApi _momentsApi;

  UserRepository({MomentsApi? momentsApi})
      : _momentsApi = momentsApi ?? getIt<MomentsApi>();

  Future<User> getUser() => _momentsApi.getUser();
}

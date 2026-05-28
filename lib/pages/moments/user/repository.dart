import 'package:first_demo/common/utils/di.dart';
import 'package:first_demo/pages/moments/api.dart';
import 'package:first_demo/pages/moments/user/model/user.dart';

class UserRepository {
  final MomentsApi _momentsApi;

  UserRepository({MomentsApi? momentsApi})
      : _momentsApi = momentsApi ?? getIt<MomentsApi>();

  Future<User> getUser() => _momentsApi.getUser();
}

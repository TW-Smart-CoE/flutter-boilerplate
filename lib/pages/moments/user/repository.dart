import 'package:first_demo/common/network/moments/api.dart';
import 'package:first_demo/common/network/moments/model/user.dart';
import 'package:first_demo/common/utils/di.dart';

class UserRepository {
  final MomentsApi _momentsApi;

  UserRepository({MomentsApi? momentsApi})
      : _momentsApi = momentsApi ?? getIt<MomentsApi>();

  Future<User> getUser() => _momentsApi.getUser();
}

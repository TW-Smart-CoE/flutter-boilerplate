import 'package:first_demo/common/network/moments/api.dart';
import 'package:first_demo/common/network/moments/model/user.dart';
import 'package:get/get.dart';

class UserRepository {
  final MomentsApi _momentsApi;

  UserRepository({MomentsApi? momentsApi})
      : _momentsApi = momentsApi ?? Get.find();

  Future<User> getUser() => _momentsApi.getUser();
}

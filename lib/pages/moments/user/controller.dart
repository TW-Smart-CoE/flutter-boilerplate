import 'package:first_demo/common/async_loader/data_controller.dart';
import 'package:first_demo/common/network/moments/model/user.dart';
import 'package:first_demo/pages/moments/user/repository.dart';

class UserController extends DataController<User> {
  final UserRepository _repository;

  UserController({UserRepository? repository})
      : _repository = repository ?? UserRepository();

  @override
  Future<User> fetch() => _repository.getUser();
}

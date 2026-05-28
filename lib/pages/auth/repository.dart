import 'package:first_demo/common/states/auth_state.dart';
import 'package:first_demo/common/utils/http_client.dart';
import 'package:first_demo/pages/auth/api.dart';
import 'package:first_demo/pages/auth/model.dart';

class AuthRepository {
  final AuthApi _authApi;
  final AuthState _authState;

  AuthRepository({AuthApi? authApi, AuthState? state})
      : _authApi = authApi ?? AuthApi(httpClient.dio),
        _authState = state ?? authState;

  Future<void> login(String username, String password) async {
    final response = await _authApi.login(
      AuthRequest(username: username, password: password),
    );
    await _authState.login(response.token);
  }

  Future<void> logout() => _authState.logout();
}

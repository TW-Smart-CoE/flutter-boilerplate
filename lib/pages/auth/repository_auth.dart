import 'package:first_demo/pages/auth/api_auth.dart';
import 'package:first_demo/pages/auth/model_auth.dart';
import 'package:first_demo/shared/http_client.dart';
import 'package:first_demo/states/state_auth.dart';

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

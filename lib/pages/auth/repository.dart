import 'package:first_demo/common/utils/http_client.dart';
import 'package:first_demo/common/utils/token_store.dart';
import 'package:first_demo/pages/auth/api.dart';
import 'package:first_demo/pages/auth/model.dart';

class AuthRepository {
  final AuthApi _authApi;
  final TokenStore _tokenStore;

  AuthRepository({AuthApi? authApi, TokenStore? store})
      : _authApi = authApi ?? AuthApi(httpClient.dio),
        _tokenStore = store ?? tokenStore;

  Future<void> login(String username, String password) async {
    final response = await _authApi.login(
      AuthRequest(username: username, password: password),
    );
    await _tokenStore.saveToken(response.token);
  }

  Future<void> logout() => _tokenStore.clearToken();

  Future<bool> isLoggedIn() => _tokenStore.hasToken();
}

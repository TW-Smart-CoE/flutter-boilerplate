import 'package:first_demo/common/utils/di.dart';
import 'package:first_demo/common/utils/token_store.dart';
import 'package:first_demo/pages/auth/api.dart';
import 'package:first_demo/pages/auth/model.dart';

class AuthRepository {
  final AuthApi _authApi;
  final TokenStore _tokenStore;

  AuthRepository({AuthApi? authApi, TokenStore? tokenStore})
      : _authApi = authApi ?? getIt<AuthApi>(),
        _tokenStore = tokenStore ?? getIt<TokenStore>();

  Future<void> login(String username, String password) async {
    final response = await _authApi.login(
      AuthRequest(username: username, password: password),
    );
    await _tokenStore.saveToken(response.token);
  }

  Future<void> logout() => _tokenStore.clearToken();

  Future<bool> isLoggedIn() => _tokenStore.hasToken();
}

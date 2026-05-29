import 'package:first_demo/shared/store_token.dart';
import 'package:signals/signals_flutter.dart';

class AuthState {
  final TokenStore _tokenStore;

  late final isLoggedIn = signal<bool>(false);

  AuthState({TokenStore? store}) : _tokenStore = store ?? tokenStore;

  Future<void> init() async {
    isLoggedIn.value = await _tokenStore.hasToken();
  }

  Future<void> login(String token) async {
    await _tokenStore.saveToken(token);
    isLoggedIn.value = true;
  }

  Future<void> logout() async {
    await _tokenStore.clearToken();
    isLoggedIn.value = false;
  }
}

final authState = AuthState();

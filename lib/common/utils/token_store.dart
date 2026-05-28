import 'package:shared_preferences/shared_preferences.dart';

class TokenStore {
  static const _tokenKey = 'auth_token';

  final SharedPreferencesAsync _prefs;

  TokenStore({SharedPreferencesAsync? prefs})
      : _prefs = prefs ?? SharedPreferencesAsync();

  Future<String?> getToken() => _prefs.getString(_tokenKey);

  Future<void> saveToken(String token) => _prefs.setString(_tokenKey, token);

  Future<void> clearToken() => _prefs.remove(_tokenKey);

  Future<bool> hasToken() async => (await getToken()) != null;
}

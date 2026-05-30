import 'package:first_demo/shared/store_token.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'store_token_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SharedPreferencesAsync>()])
void main() {
  late MockSharedPreferencesAsync mockPrefs;
  late TokenStore store;

  setUp(() {
    mockPrefs = MockSharedPreferencesAsync();
    store = TokenStore(prefs: mockPrefs);
  });

  group('getToken', () {
    test('should return token when exists', () async {
      when(mockPrefs.getString('auth_token')).thenAnswer((_) async => 'my_token');

      final result = await store.getToken();

      expect(result, 'my_token');
      verify(mockPrefs.getString('auth_token')).called(1);
    });

    test('should return null when no token', () async {
      when(mockPrefs.getString('auth_token')).thenAnswer((_) async => null);

      final result = await store.getToken();

      expect(result, isNull);
    });
  });

  group('saveToken', () {
    test('should save token to preferences', () async {
      when(mockPrefs.setString('auth_token', 'new_token')).thenAnswer((_) async {});

      await store.saveToken('new_token');

      verify(mockPrefs.setString('auth_token', 'new_token')).called(1);
    });
  });

  group('clearToken', () {
    test('should remove token from preferences', () async {
      when(mockPrefs.remove('auth_token')).thenAnswer((_) async {});

      await store.clearToken();

      verify(mockPrefs.remove('auth_token')).called(1);
    });
  });

  group('hasToken', () {
    test('should return true when token exists', () async {
      when(mockPrefs.getString('auth_token')).thenAnswer((_) async => 'some_token');

      final result = await store.hasToken();

      expect(result, isTrue);
    });

    test('should return false when no token', () async {
      when(mockPrefs.getString('auth_token')).thenAnswer((_) async => null);

      final result = await store.hasToken();

      expect(result, isFalse);
    });
  });
}

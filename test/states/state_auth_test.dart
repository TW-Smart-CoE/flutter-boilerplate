import 'package:first_demo/shared/store_token.dart';
import 'package:first_demo/states/state_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'state_auth_test.mocks.dart';

@GenerateNiceMocks([MockSpec<TokenStore>()])
void main() {
  late MockTokenStore mockStore;
  late AuthState authState;

  setUp(() {
    mockStore = MockTokenStore();
    authState = AuthState(store: mockStore);
  });

  group('init', () {
    test('should set isLoggedIn to true when token exists', () async {
      when(mockStore.hasToken()).thenAnswer((_) async => true);

      await authState.init();

      expect(authState.isLoggedIn.value, isTrue);
    });

    test('should set isLoggedIn to false when no token', () async {
      when(mockStore.hasToken()).thenAnswer((_) async => false);

      await authState.init();

      expect(authState.isLoggedIn.value, isFalse);
    });
  });

  group('login', () {
    test('should save token and set isLoggedIn to true', () async {
      when(mockStore.saveToken('my_token')).thenAnswer((_) async {});

      await authState.login('my_token');

      verify(mockStore.saveToken('my_token')).called(1);
      expect(authState.isLoggedIn.value, isTrue);
    });
  });

  group('logout', () {
    test('should clear token and set isLoggedIn to false', () async {
      when(mockStore.saveToken(any)).thenAnswer((_) async {});
      when(mockStore.clearToken()).thenAnswer((_) async {});

      // First login
      await authState.login('token');
      expect(authState.isLoggedIn.value, isTrue);

      // Then logout
      await authState.logout();

      verify(mockStore.clearToken()).called(1);
      expect(authState.isLoggedIn.value, isFalse);
    });
  });
}

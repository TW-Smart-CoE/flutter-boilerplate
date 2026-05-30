import 'package:first_demo/features/auth/api_auth.dart';
import 'package:first_demo/features/auth/model_auth.dart';
import 'package:first_demo/features/auth/repository_auth.dart';
import 'package:first_demo/states/state_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'repository_auth_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthApi>(), MockSpec<AuthState>()])
void main() {
  late MockAuthApi mockApi;
  late MockAuthState mockState;
  late AuthRepository repository;

  setUp(() {
    mockApi = MockAuthApi();
    mockState = MockAuthState();
    repository = AuthRepository(authApi: mockApi, state: mockState);
  });

  group('login', () {
    test('should call api login and save token to state', () async {
      const username = 'admin';
      const password = '123456';
      final response = const AuthResponse(
        data: {'username': username},
      );

      when(mockApi.login(any)).thenAnswer((_) async => response);
      when(mockState.login(any)).thenAnswer((_) async {});

      await repository.login(username, password);

      final captured = verify(mockApi.login(captureAny)).captured.single as AuthRequest;
      expect(captured.username, username);
      expect(captured.password, password);
      verify(mockState.login(response.token)).called(1);
    });

    test('should propagate api error', () async {
      when(mockApi.login(any)).thenThrow(Exception('Network error'));

      expect(
        () => repository.login('user', 'pass'),
        throwsException,
      );
    });

    test('should propagate state error', () async {
      final response = const AuthResponse(data: {'username': 'user'});
      when(mockApi.login(any)).thenAnswer((_) async => response);
      when(mockState.login(any)).thenThrow(Exception('Storage error'));

      expect(
        () => repository.login('user', 'pass'),
        throwsException,
      );
    });
  });

  group('logout', () {
    test('should delegate to state logout', () async {
      when(mockState.logout()).thenAnswer((_) async {});

      await repository.logout();

      verify(mockState.logout()).called(1);
    });

    test('should propagate state logout error', () async {
      when(mockState.logout()).thenThrow(Exception('Logout error'));

      expect(() => repository.logout(), throwsException);
    });
  });
}

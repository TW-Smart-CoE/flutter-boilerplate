import 'dart:async';

import 'package:first_demo/features/auth/page_auth.dart';
import 'package:first_demo/features/auth/repository_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test_utils/test_util.dart';
import 'page_auth_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthRepository>()])
void main() {
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
  });

  testPage('should show AppBar with login title', (tester, buildPage) async {
    await tester.pumpWidget(
      buildPage(AuthPage(repository: mockRepository)),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testPage('should show username and password fields with default values',
      (tester, buildPage) async {
    await tester.pumpWidget(
      buildPage(AuthPage(repository: mockRepository)),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('admin'), findsOneWidget);
    expect(find.text('123456'), findsOneWidget);
  });

  testPage('should show sign in button', (tester, buildPage) async {
    await tester.pumpWidget(
      buildPage(AuthPage(repository: mockRepository)),
    );
    await tester.pumpAndSettle();

    expect(find.widgetWithText(FilledButton, 'Sign In'), findsOneWidget);
  });

  testPage('should call repository login on button tap', (tester, buildPage) async {
    final completer = Completer<void>();
    when(mockRepository.login(any, any)).thenAnswer((_) => completer.future);

    await tester.pumpWidget(
      buildPage(AuthPage(repository: mockRepository)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Sign In'));
    await tester.pump();

    verify(mockRepository.login('admin', '123456')).called(1);

    completer.complete();
    await tester.pumpAndSettle();
  });

  testPage('should show loading indicator while login is pending', (tester, buildPage) async {
    final completer = Completer<void>();
    when(mockRepository.login(any, any)).thenAnswer((_) => completer.future);

    await tester.pumpWidget(
      buildPage(AuthPage(repository: mockRepository)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Sign In'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete();
    await tester.pumpAndSettle();
  });

  testPage('should show error message when login fails', (tester, buildPage) async {
    when(mockRepository.login(any, any)).thenAnswer((_) async => throw Exception('Login failed'));

    await tester.pumpWidget(
      buildPage(AuthPage(repository: mockRepository)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Login failed. Please try again.'), findsOneWidget);
  });

  testPage('should not call login when username is empty', (tester, buildPage) async {
    await tester.pumpWidget(
      buildPage(AuthPage(repository: mockRepository)),
    );
    await tester.pumpAndSettle();

    // Clear username field
    final usernameField = find.byType(TextField).first;
    await tester.enterText(usernameField, '');
    await tester.pump();

    await tester.tap(find.widgetWithText(FilledButton, 'Sign In'));
    await tester.pump();

    verifyNever(mockRepository.login(any, any));
  });

  testPage('should not call login when password is empty', (tester, buildPage) async {
    await tester.pumpWidget(
      buildPage(AuthPage(repository: mockRepository)),
    );
    await tester.pumpAndSettle();

    // Clear password field
    final passwordField = find.byType(TextField).last;
    await tester.enterText(passwordField, '');
    await tester.pump();

    await tester.tap(find.widgetWithText(FilledButton, 'Sign In'));
    await tester.pump();

    verifyNever(mockRepository.login(any, any));
  });

  testPage('should call login with entered text', (tester, buildPage) async {
    final completer = Completer<void>();
    when(mockRepository.login(any, any)).thenAnswer((_) => completer.future);

    await tester.pumpWidget(
      buildPage(AuthPage(repository: mockRepository)),
    );
    await tester.pumpAndSettle();

    final usernameField = find.byType(TextField).first;
    final passwordField = find.byType(TextField).last;
    await tester.enterText(usernameField, 'testuser');
    await tester.enterText(passwordField, 'testpass');
    await tester.pump();

    await tester.tap(find.widgetWithText(FilledButton, 'Sign In'));
    await tester.pump();

    verify(mockRepository.login('testuser', 'testpass')).called(1);

    completer.complete();
    await tester.pumpAndSettle();
  });
}

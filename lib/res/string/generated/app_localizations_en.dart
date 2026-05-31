// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Flutter Demo';

  @override
  String get counterPageTitle => 'Counter';

  @override
  String get counterMainTip => 'You have pushed the button this many times:';

  @override
  String get animalImagePageTitle => 'Animal Image';

  @override
  String get loading => 'Loading...';

  @override
  String get devMenu => 'Dev Menu';

  @override
  String get connectionErrorTitle => 'Connection Error';

  @override
  String get connectionErrorSubtitle => 'Please check your network connection.';

  @override
  String get loadingOrParsingErrorTitle => 'Loading or Parsing Error';

  @override
  String get loadingOrParsingErrorSubtitle => 'Oops, something went wrong.';

  @override
  String get retry => 'Retry';

  @override
  String get momentsPageTitle => 'Moments';

  @override
  String get loginPageTitle => 'Login';

  @override
  String get loginUsername => 'Username';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginButton => 'Sign In';

  @override
  String get loginEmptyFieldsError => 'Please enter username and password.';

  @override
  String get loginFailedError => 'Login failed. Please try again.';

  @override
  String get calculatorPageTitle => 'Calculator';
}

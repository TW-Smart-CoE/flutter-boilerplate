import 'package:first_demo/common/di/service_locator.dart';
import 'package:first_demo/common/utils/environment_config.dart';
import 'package:first_demo/res/string/generated/app_localizations.dart';
import 'package:first_demo/res/theme/theme.dart';
import 'package:first_demo/routes.dart';
import 'package:flutter/material.dart';

final myApp = MaterialApp.router(
  debugShowCheckedModeBanner: false,
  theme: lightTheme,
  darkTheme: lightTheme,
  routerConfig: appRouter,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadEnvironmentConfig();

  // Initialize global dependencies
  setupServiceLocator();

  runApp(myApp);
}

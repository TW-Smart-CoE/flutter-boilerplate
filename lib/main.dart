import 'package:first_demo/common/di/service_locator.dart';
import 'package:first_demo/common/utils/environment_config.dart';
import 'package:first_demo/res/string/strings.dart';
import 'package:first_demo/res/theme/theme.dart';
import 'package:first_demo/routes.dart';
import 'package:flutter/material.dart';

final myApp = MaterialApp.router(
  debugShowCheckedModeBanner: false,
  theme: lightTheme,
  darkTheme: lightTheme,
  routerConfig: appRouter,
  locale: StringResources.locale,
  localizationsDelegates: const [],
  supportedLocales: const [Locale('en', 'US')],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadEnvironmentConfig();

  // Initialize global dependencies
  setupServiceLocator();

  runApp(myApp);
}

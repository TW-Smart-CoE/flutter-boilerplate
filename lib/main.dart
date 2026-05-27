import 'package:first_demo/common/utils/di.dart';
import 'package:first_demo/common/utils/environment_config.dart';
import 'package:first_demo/res/string/generated/app_localizations.dart';
import 'package:first_demo/res/theme/theme.dart';
import 'package:first_demo/routes.dart';
import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';
import 'package:fquery_core/fquery_core.dart';

final queryCache = QueryCache();

final myApp = CacheProvider(
  cache: queryCache,
  child: MaterialApp.router(
    debugShowCheckedModeBanner: false,
    theme: lightTheme,
    darkTheme: lightTheme,
    routerConfig: appRouter,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadEnvironmentConfig();
  setupDependencyInjection();

  runApp(myApp);
}

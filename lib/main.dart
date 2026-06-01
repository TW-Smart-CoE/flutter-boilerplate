import 'package:first_demo/res/string/generated/app_localizations.dart';
import 'package:first_demo/res/theme/theme.dart';
import 'package:first_demo/routes.dart';
import 'package:first_demo/shared/environment_config.dart';
import 'package:first_demo/states/state_auth.dart';
import 'package:first_demo/utils/global_error_handler.dart';
import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';
import 'package:fquery_core/fquery_core.dart';

final _app = MaterialApp.router(
  debugShowCheckedModeBanner: false,
  theme: lightTheme,
  darkTheme: darkTheme,
  routerConfig: appRouter,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
);

final _queryCache = QueryCache(
  defaultQueryOptions: DefaultQueryOptions(
    cacheDuration: Duration(minutes: 20),
    refetchInterval: Duration(minutes: 5),
    refetchOnMount: RefetchOnMount.stale,
    staleDuration: Duration(minutes: 3),
  ),
);

void main() {
  GlobalErrorHandler.run(() async {
    await loadEnvironmentConfig();
    await authState.init();

    runApp(CacheProvider(
      cache: _queryCache,
      child: _app,
    ));
  });
}

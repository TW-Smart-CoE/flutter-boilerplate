import 'package:first_demo/res/string/generated/app_localizations.dart';
import 'package:flutter/material.dart';

Widget testPage(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: child,
  );
}

import 'package:first_demo/common/di/global_binding.dart';
import 'package:first_demo/res/string/strings.dart';
import 'package:first_demo/res/theme/themes.dart';
import 'package:first_demo/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final myApp = GetMaterialApp(
  debugShowCheckedModeBanner: false,
  theme: lightTheme,
  darkTheme: darkTheme,
  getPages: AppPages.pages,
  initialBinding: GlobalBinding(),
  initialRoute: Routes.COUNTER,
  navigatorObservers: [GetXRouterObserver()],
  locale: StringResources.locale,
  fallbackLocale: StringResources.fallbackLocale,
  translations: StringResources(),
);

void main() async {
  runApp(myApp);
}

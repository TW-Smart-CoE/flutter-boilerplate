import 'package:first_demo/pages.dart';
import 'package:first_demo/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  runApp(GetMaterialApp(
    initialRoute: Routes.HOME,
    getPages: AppPages.pages,
    theme: ThemeData.light(),
    darkTheme: ThemeData.dark(),
    debugShowCheckedModeBanner: false,
  ));
}

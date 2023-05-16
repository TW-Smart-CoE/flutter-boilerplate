import 'package:first_demo/common/scaffold/app_bar.dart';
import 'package:first_demo/res/string/strings.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget BaseScaffold({
  String? title,
  PreferredSizeWidget? appBar,
  Widget? drawer,
  required Widget body,
  Widget? floatingActionButton,
}) {
  return Scaffold(
    appBar: appBar ?? DefaultAppBar(title ?? stringRes(R.app_name)),
    drawer: drawer,
    body: body,
    floatingActionButton: floatingActionButton,
  );
}

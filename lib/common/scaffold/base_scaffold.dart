import 'package:first_demo/common/scaffold/app_bar.dart';
import 'package:first_demo/dev_menu/factory.dart';
import 'package:first_demo/res/string/strings.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget BaseScaffold({
  required BuildContext context,
  String? title,
  PreferredSizeWidget? appBar,
  Widget? drawer,
  required Widget body,
  Widget? floatingActionButton,
}) {
  return Scaffold(
    appBar: appBar ?? DefaultAppBar(title ?? l10n(context).appName),
    drawer: drawer ?? createDevMenu(),
    body: body,
    floatingActionButton: floatingActionButton,
  );
}

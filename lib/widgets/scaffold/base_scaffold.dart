import 'package:first_demo/dev_menu/factory.dart';
import 'package:first_demo/res/string/strings.dart';
import 'package:first_demo/widgets/scaffold/app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget BaseScaffold({
  required BuildContext context,
  String? title,
  PreferredSizeWidget? appBar,
  Widget? drawer,
  required Widget body,
  Widget? floatingActionButton,
  FloatingActionButtonLocation? floatingActionButtonLocation,
  Widget? bottomNavigationBar,
  bool useSafeArea = true,
  bool resizeToAvoidBottomInset = true,
  Color? backgroundColor,
}) =>
    Scaffold(
      appBar: appBar ?? DefaultAppBar(title ?? stringsOf(context).appName),
      drawer: drawer ?? (kDebugMode ? createDevMenu() : null),
      body: useSafeArea ? SafeArea(child: body) : body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor,
    );

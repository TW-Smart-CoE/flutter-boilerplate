import 'package:first_demo/res/string/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: non_constant_identifier_names
Widget LoadingPlaceholder() {
  return Container(
    color: Get.theme.colorScheme.background,
    child: Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(stringRes(R.loading)),
          ],
        ),
      ),
    ),
  );
}

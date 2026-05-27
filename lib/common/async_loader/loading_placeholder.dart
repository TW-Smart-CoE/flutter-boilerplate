import 'package:first_demo/res/string/strings.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget LoadingPlaceholder(BuildContext context) {
  final theme = Theme.of(context);
  return Container(
    width: double.infinity,
    height: double.infinity,
    color: theme.colorScheme.surface,
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text(l10n(context).loading),
      ],
    ),
  );
}

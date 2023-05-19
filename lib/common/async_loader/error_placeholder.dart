import 'package:first_demo/res/string/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

enum ErrorType {
  connection(
    title: R.connection_error_title,
    subTitle: R.connection_error_subtitle,
    imageRes: 'assets/images/error_no_connection.png',
  ),
  loadingOrParsing(
    title: R.loading_or_parsing_error_title,
    subTitle: R.loading_or_parsing_error_subtitle,
    imageRes: 'assets/images/error_loading_or_parsing.png',
  );

  const ErrorType({
    required this.title,
    required this.subTitle,
    required this.imageRes,
  });

  final R title;
  final R subTitle;
  final String imageRes;
}

const double _imageSize = 180;

// ignore: non_constant_identifier_names
Widget ErrorPlaceholder({
  ErrorType errorType = ErrorType.loadingOrParsing,
  required VoidCallback onRetry,
}) {
  final theme = Get.theme;
  return Container(
    color: theme.colorScheme.background,
    child: Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              errorType.imageRes,
              width: _imageSize,
              height: _imageSize,
            ),
            const SizedBox(height: 16),
            Text(
              stringRes(errorType.title),
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onBackground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              stringRes(errorType.subTitle),
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 16),
            CupertinoButton(
              onPressed: onRetry,
              child: Text(stringRes(R.retry)),
            ),
          ],
        ),
      ),
    ),
  );
}

import 'package:first_demo/res/string/generated/app_localizations.dart';
import 'package:first_demo/res/string/strings.dart';
import 'package:flutter/material.dart';

enum ErrorType {
  connection(
    imageRes: 'assets/images/error_no_connection.png',
  ),
  loadingOrParsing(
    imageRes: 'assets/images/error_loading_or_parsing.png',
  );

  const ErrorType({
    required this.imageRes,
  });

  final String imageRes;

  String title(AppLocalizations loc) {
    switch (this) {
      case ErrorType.connection:
        return loc.connectionErrorTitle;
      case ErrorType.loadingOrParsing:
        return loc.loadingOrParsingErrorTitle;
    }
  }

  String subTitle(AppLocalizations loc) {
    switch (this) {
      case ErrorType.connection:
        return loc.connectionErrorSubtitle;
      case ErrorType.loadingOrParsing:
        return loc.loadingOrParsingErrorSubtitle;
    }
  }
}

const double _imageSize = 180;

// ignore: non_constant_identifier_names
Widget ErrorPlaceholder({
  required BuildContext context,
  ErrorType errorType = ErrorType.loadingOrParsing,
  required VoidCallback onRetry,
}) {
  final theme = Theme.of(context);
  final loc = l10n(context);
  return Container(
    width: double.infinity,
    height: double.infinity,
    color: theme.colorScheme.surface,
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          errorType.imageRes,
          width: _imageSize,
          height: _imageSize,
          color: theme.colorScheme.onSurface,
        ),
        const SizedBox(height: 16),
        Text(
          errorType.title(loc),
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          errorType.subTitle(loc),
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: onRetry,
          child: Text(loc.retry),
        ),
      ],
    ),
  );
}

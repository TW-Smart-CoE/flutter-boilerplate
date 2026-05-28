import 'dart:async';

import 'package:first_demo/common/utils/logger.dart';
import 'package:flutter/foundation.dart';

/// Global error handler that captures all uncaught errors in the application.
///
/// - Flutter framework errors (widget build errors, layout errors, etc.)
/// - Dart async errors (uncaught Future errors, Stream errors)
/// - Platform dispatcher errors
///
/// In debug mode, errors are logged to console.
/// In release mode, errors can be reported to a crash reporting service.
class GlobalErrorHandler {
  GlobalErrorHandler._();

  /// Initialize global error handling. Call this to wrap the entire app bootstrap.
  static void run(void Function() appRunner) {
    // Catch all uncaught async errors in a guarded zone
    runZonedGuarded(
      () {
        // Catch Flutter framework errors (e.g. build/layout/paint errors)
        FlutterError.onError = _handleFlutterError;

        // Catch platform dispatcher errors (e.g. plugin errors)
        PlatformDispatcher.instance.onError = _handlePlatformError;

        appRunner();
      },
      _handleZoneError,
    );
  }

  /// Handles errors reported by the Flutter framework.
  static void _handleFlutterError(FlutterErrorDetails details) {
    logger.e(
      'Flutter framework error',
      error: details.exception,
      stackTrace: details.stack,
    );

    // In debug mode, also print the detailed Flutter error report
    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details, forceReport: true);
    }

    _reportError(details.exception, details.stack);
  }

  /// Handles errors from the platform dispatcher.
  static bool _handlePlatformError(Object error, StackTrace stack) {
    logger.e(
      'Platform error',
      error: error,
      stackTrace: stack,
    );

    _reportError(error, stack);
    return true; // Prevent the error from propagating
  }

  /// Handles uncaught async errors in the root zone.
  static void _handleZoneError(Object error, StackTrace stack) {
    logger.e(
      'Uncaught async error',
      error: error,
      stackTrace: stack,
    );

    _reportError(error, stack);
  }

  /// Report error to crash reporting service.
  /// TODO: Integrate with a crash reporting service (e.g. Firebase Crashlytics, Sentry)
  static void _reportError(Object error, StackTrace? stack) {
    if (kReleaseMode) {
      // Example: FirebaseCrashlytics.instance.recordError(error, stack);
      // Example: Sentry.captureException(error, stackTrace: stack);
    }
  }
}

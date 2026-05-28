import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  filter: AppLogFilter(),
);

class AppLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (kDebugMode) {
      return true;
    } else {
      return event.level.index >= Level.debug.index;
    }
  }
}

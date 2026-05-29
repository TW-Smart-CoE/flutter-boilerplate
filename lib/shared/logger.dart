import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  filter: _AppLogFilter(),
);

class _AppLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (kDebugMode) {
      return true;
    } else {
      return event.level.index >= Level.debug.index;
    }
  }
}

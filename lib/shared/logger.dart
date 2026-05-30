import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  filter: _AppLogFilter(),
);

class _AppLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (Platform.environment['FLUTTER_TEST'] == 'true') {
      return false;
    }
    if (kDebugMode) {
      return true;
    } else {
      return event.level.index >= Level.debug.index;
    }
  }
}

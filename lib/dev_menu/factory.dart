import 'package:first_demo/dev_menu/menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

StatelessWidget? createDevMenu() {
  return kDebugMode ? const DevMenu() : null;
}

import 'dart:io';
import 'dart:ui';

import 'package:first_demo/res/string/en-US.dart';
import 'package:first_demo/res/string/zh-CN.dart';
import 'package:get/get.dart';

class StringResources extends Translations {
  static Locale? get locale {
    final local = Platform.localeName.split('_');
    return Locale.fromSubtags(languageCode: local[0], countryCode: local[1]);
  }

  static const fallbackLocale = Locale('en', 'US');

  static final Map<String, String> _enUS =
      enUS.map((key, value) => MapEntry(key.name, value));
  static final Map<String, String> _zhCN =
      zhCN.map((key, value) => MapEntry(key.name, value));

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': _enUS,
        'zh_CN': _zhCN,
      };
}

stringRes(R key) => key.name.tr;

// keys for string resources
enum R {
  app_name,
  counter_page_title,
  counter_main_tip,
  animal_image_page_title,
  loading,
  dev_menu,
  connection_error_title,
  connection_error_subtitle,
  loading_or_parsing_error_title,
  loading_or_parsing_error_subtitle,
  retry,
}

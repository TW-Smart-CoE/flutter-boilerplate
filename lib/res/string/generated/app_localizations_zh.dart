// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'Flutter 示例';

  @override
  String get counterPageTitle => '计数器';

  @override
  String get counterMainTip => '你已经点击了这个按钮(次数)：';

  @override
  String get animalImagePageTitle => '动物图片';

  @override
  String get loading => '加载中...';

  @override
  String get devMenu => '开发菜单';

  @override
  String get connectionErrorTitle => '连接错误';

  @override
  String get connectionErrorSubtitle => '请检查你的网络连接。';

  @override
  String get loadingOrParsingErrorTitle => '加载或解析错误';

  @override
  String get loadingOrParsingErrorSubtitle => '哎呀，出了点问题。';

  @override
  String get retry => '重试';

  @override
  String get momentsPageTitle => '朋友圈';

  @override
  String get loginPageTitle => '登录';

  @override
  String get loginUsername => '用户名';

  @override
  String get loginPassword => '密码';

  @override
  String get loginButton => '登录';

  @override
  String get loginEmptyFieldsError => '请输入用户名和密码。';

  @override
  String get loginFailedError => '登录失败，请重试。';

  @override
  String get calculatorPageTitle => '计算器';
}

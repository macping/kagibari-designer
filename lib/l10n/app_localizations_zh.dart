// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '钩针编织图设计';

  @override
  String get settingsTooltip => '设置';

  @override
  String get inputError => '请检查输入值（0或负值无法计算）';

  @override
  String get enterValues => '请输入数值';

  @override
  String get settingsTitle => '设置';

  @override
  String get proActive => 'Pro版 使用中';

  @override
  String get proActiveSubtitle => '所有功能已解锁';

  @override
  String get upgradeTitle => '升级到Pro版';

  @override
  String get upgradeSubtitle => 'TODO: Pro卖点一句话（买断制）';

  @override
  String get restorePurchase => '恢复购买';

  @override
  String get restoreSubtitle => '更换设备或重新安装后';

  @override
  String get restoreStarted => '已开始恢复';

  @override
  String get restoreFailed => '无法恢复，请检查商店连接';

  @override
  String get disclaimerTitle => '免责声明';

  @override
  String get disclaimerBody => 'TODO: 本应用计算结果为参考值。（按应用替换）';

  @override
  String get languageTitle => '语言';

  @override
  String get languageSystem => '跟随系统';

  @override
  String get paywallTitle => '升级到Pro版';

  @override
  String paywallSubtitle(String price) {
    return '买断制 $price・非订阅';
  }

  @override
  String get paywallBenefit1 => 'TODO: 特典1';

  @override
  String get paywallBenefit2 => 'TODO: 特典2';

  @override
  String get paywallBenefit3 => 'TODO: 特典3';

  @override
  String get paywallBenefit4 => '即使今后加入广告也不显示';

  @override
  String buyButton(String price) {
    return '以 $price 购买';
  }

  @override
  String get storeUnavailable => '无法连接到商店';

  @override
  String get purchaseError => '购买过程中发生错误';
}

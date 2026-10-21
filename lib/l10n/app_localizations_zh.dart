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
  String get upgradeSubtitle => '环形编织无限制・全部记号・无水印导出';

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
  String get disclaimerBody => '本应用的记号为参考JIS表记惯例的自制图案。实际编织效果因毛线和密度而异。';

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
  String get paywallBenefit1 => '环形编织图不限段数';

  @override
  String get paywallBenefit2 => '全部32种钩针记号';

  @override
  String get paywallBenefit3 => '高分辨率・无水印导出';

  @override
  String get paywallBenefit4 => '完全无广告（今后也是）';

  @override
  String buyButton(String price) {
    return '以 $price 购买';
  }

  @override
  String get storeUnavailable => '无法连接到商店';

  @override
  String get purchaseError => '购买过程中发生错误';

  @override
  String get homeTabCharts => '作品';

  @override
  String get homeTabSettings => '设置';

  @override
  String get newRoundChart => '环形编织（玩偶）';

  @override
  String get newGridChart => '方格编织';

  @override
  String get chartDefaultTitle => '未命名编织图';

  @override
  String get emptyGallery => '还没有编织图。\n从上方按钮开始创建。';

  @override
  String get renameTitle => '重命名';

  @override
  String get duplicateChart => '复制';

  @override
  String get deleteChart => '删除';

  @override
  String deleteConfirm(String title) {
    return '要删除「$title」吗？';
  }

  @override
  String get deleteOk => '删除';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String roundsCount(int n) {
    return '$n段';
  }

  @override
  String gridSize(int c, int r) {
    return '$c×$r格';
  }

  @override
  String get undoTooltip => '撤销';

  @override
  String get redoTooltip => '重做';

  @override
  String get eraserTooltip => '橡皮擦';

  @override
  String get roundSettingsTooltip => '每段针数';

  @override
  String get exportTooltip => '导出・分享';

  @override
  String get catBasic => '基础';

  @override
  String get catIncDec => '加减针';

  @override
  String get catFancy => '玉编・花样';

  @override
  String get proLockedSymbol => '此记号需要Pro版解锁';

  @override
  String get addRound => '添加一段';

  @override
  String get removeRound => '删除最后一段';

  @override
  String roundLabel(int n) {
    return '第$n段';
  }

  @override
  String get freeRoundLimit => '免费版最多6段，Pro版无限制。';

  @override
  String get gridSizeTitle => '方格尺寸';

  @override
  String get rowsLabel => '行（段）';

  @override
  String get colsLabel => '列（针）';

  @override
  String get exportTitle => '导出';

  @override
  String get exportPng => '分享PNG';

  @override
  String get exportPdf => '分享PDF';

  @override
  String get resolutionLabel => '分辨率';

  @override
  String get watermarkNotice => '免费版导出带有小水印';

  @override
  String get proResolution => '高分辨率需要Pro版';

  @override
  String get exportFailed => '导出失败';

  @override
  String get backupExport => '导出全部编织图';

  @override
  String get backupExportSubtitle => '保存或分享为一个备份文件';

  @override
  String get backupImport => '导入备份';

  @override
  String get backupImportSubtitle => '从备份文件恢复编织图';

  @override
  String backupImported(int n) {
    return '已导入$n张编织图';
  }

  @override
  String get backupFailed => '无法读取该文件';

  @override
  String get backupEmpty => '没有可导出的编织图';

  @override
  String get replayOnboarding => '再看一次使用说明';

  @override
  String get onboardingSkip => '跳过';

  @override
  String get onboardingStart => '开始';

  @override
  String get onboardingNext => '下一页';

  @override
  String get onboarding1Title => '把脑海中的编织图画出来';

  @override
  String get onboarding1Body => '玩偶的环形编织图和方格图，每段针数都能精确设定。';

  @override
  String get onboarding2Title => '选择记号，点击放置';

  @override
  String get onboarding2Body => '自动吸附到网格，环形图中记号方向也会自动对齐。';

  @override
  String get onboarding3Title => '无广告，完全离线';

  @override
  String get onboarding3Body => 'Pro版解锁不限段数、全部记号和高分辨率无水印导出。';
}

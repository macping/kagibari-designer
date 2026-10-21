// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '編み図デザイナー';

  @override
  String get settingsTooltip => '設定';

  @override
  String get inputError => '入力値を確認してください（0や負の値は計算できません）';

  @override
  String get enterValues => '値を入力してください';

  @override
  String get settingsTitle => '設定';

  @override
  String get proActive => 'Pro版 利用中';

  @override
  String get proActiveSubtitle => 'すべての機能が解放されています';

  @override
  String get upgradeTitle => 'Pro版にアップグレード';

  @override
  String get upgradeSubtitle => '円編み無制限・全記号・透かしなし書き出し';

  @override
  String get restorePurchase => '購入を復元';

  @override
  String get restoreSubtitle => '機種変更・再インストールした場合';

  @override
  String get restoreStarted => '復元処理を開始しました';

  @override
  String get restoreFailed => '復元できませんでした。ストア接続をご確認ください';

  @override
  String get disclaimerTitle => '免責事項';

  @override
  String get disclaimerBody =>
      '本アプリの記号はJISの表記慣行を参考にした自社制作の図案です。実際の編み上がりは毛糸やゲージにより異なります。';

  @override
  String get languageTitle => '言語';

  @override
  String get languageSystem => 'システムに従う';

  @override
  String get paywallTitle => 'Pro版にアップグレード';

  @override
  String paywallSubtitle(String price) {
    return '買い切り $price ・ サブスクではありません';
  }

  @override
  String get paywallBenefit1 => '円編みの段数無制限';

  @override
  String get paywallBenefit2 => '全32種のかぎ針記号';

  @override
  String get paywallBenefit3 => '高解像度・透かしなしで書き出し';

  @override
  String get paywallBenefit4 => '広告は一切なし（今後もずっと）';

  @override
  String buyButton(String price) {
    return '$price で購入';
  }

  @override
  String get storeUnavailable => 'ストアに接続できませんでした';

  @override
  String get purchaseError => '購入処理でエラーが発生しました';

  @override
  String get homeTabCharts => '作品';

  @override
  String get homeTabSettings => '設定';

  @override
  String get newRoundChart => '円編み（あみぐるみ）';

  @override
  String get newGridChart => '方眼編み';

  @override
  String get chartDefaultTitle => '無題の編み図';

  @override
  String get emptyGallery => 'まだ編み図がありません。\n上のボタンから作成できます。';

  @override
  String get renameTitle => '名前を変更';

  @override
  String get duplicateChart => '複製';

  @override
  String get deleteChart => '削除';

  @override
  String deleteConfirm(String title) {
    return '「$title」を削除しますか？';
  }

  @override
  String get deleteOk => '削除する';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String roundsCount(int n) {
    return '$n段';
  }

  @override
  String gridSize(int c, int r) {
    return '$c×$rマス';
  }

  @override
  String get undoTooltip => '元に戻す';

  @override
  String get redoTooltip => 'やり直す';

  @override
  String get eraserTooltip => '消しゴム';

  @override
  String get roundSettingsTooltip => '段ごとの目数';

  @override
  String get exportTooltip => '書き出し・共有';

  @override
  String get catBasic => '基本';

  @override
  String get catIncDec => '増減目';

  @override
  String get catFancy => '玉編み・模様';

  @override
  String get proLockedSymbol => 'この記号はProで解放されます';

  @override
  String get addRound => '段を追加';

  @override
  String get removeRound => '最終段を削除';

  @override
  String roundLabel(int n) {
    return '$n段目';
  }

  @override
  String get freeRoundLimit => '無料版は6段まで。Proで無制限になります。';

  @override
  String get gridSizeTitle => '方眼サイズ';

  @override
  String get rowsLabel => '行（段）';

  @override
  String get colsLabel => '列（目）';

  @override
  String get exportTitle => '書き出し';

  @override
  String get exportPng => 'PNGで共有';

  @override
  String get exportPdf => 'PDFで共有';

  @override
  String get resolutionLabel => '解像度';

  @override
  String get watermarkNotice => '無料版は小さな透かし入りで書き出されます';

  @override
  String get proResolution => '高解像度はPro版で利用できます';

  @override
  String get exportFailed => '書き出しに失敗しました';

  @override
  String get backupExport => 'すべての編み図を書き出す';

  @override
  String get backupExportSubtitle => '1つのバックアップファイルに保存・共有できます';

  @override
  String get backupImport => 'バックアップを読み込む';

  @override
  String get backupImportSubtitle => 'バックアップファイルから復元します';

  @override
  String backupImported(int n) {
    return '$n件の編み図を読み込みました';
  }

  @override
  String get backupFailed => 'ファイルを読み込めませんでした';

  @override
  String get backupEmpty => '書き出す編み図がありません';

  @override
  String get replayOnboarding => '使い方をもう一度見る';

  @override
  String get onboardingSkip => 'スキップ';

  @override
  String get onboardingStart => 'はじめる';

  @override
  String get onboardingNext => '次へ';

  @override
  String get onboarding1Title => '頭の中の編み図を、そのまま';

  @override
  String get onboarding1Body => 'あみぐるみの円編みも方眼も。段ごとの目数も正確に。';

  @override
  String get onboarding2Title => '記号を選んで、置くだけ';

  @override
  String get onboarding2Body => 'マス目に自動で吸着。円編みでは記号の向きも自動で揃います。';

  @override
  String get onboarding3Title => '広告なし。すべて端末の中で';

  @override
  String get onboarding3Body => 'Pro版は段数無制限・全記号・高解像度の透かしなし書き出し。';
}

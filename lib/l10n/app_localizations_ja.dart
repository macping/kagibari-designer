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
  String get upgradeSubtitle => 'TODO: Pro特典の一行説明（買い切り）';

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
  String get disclaimerBody => 'TODO: 本アプリの計算結果は参考値です。（アプリ固有の免責に差し替え）';

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
  String get paywallBenefit1 => 'TODO: 特典1';

  @override
  String get paywallBenefit2 => 'TODO: 特典2';

  @override
  String get paywallBenefit3 => 'TODO: 特典3';

  @override
  String get paywallBenefit4 => '今後広告が追加されても非表示';

  @override
  String buyButton(String price) {
    return '$price で購入';
  }

  @override
  String get storeUnavailable => 'ストアに接続できませんでした';

  @override
  String get purchaseError => '購入処理でエラーが発生しました';
}

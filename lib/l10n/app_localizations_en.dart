// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Crochet Chart Designer';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get inputError =>
      'Check the inputs (zero or negative values cannot be calculated)';

  @override
  String get enterValues => 'Enter values';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get proActive => 'Pro active';

  @override
  String get proActiveSubtitle => 'All features are unlocked';

  @override
  String get upgradeTitle => 'Upgrade to Pro';

  @override
  String get upgradeSubtitle => 'TODO: one-line Pro pitch (one-time)';

  @override
  String get restorePurchase => 'Restore purchase';

  @override
  String get restoreSubtitle => 'After changing or resetting your device';

  @override
  String get restoreStarted => 'Restore started';

  @override
  String get restoreFailed => 'Could not restore. Check your store connection';

  @override
  String get disclaimerTitle => 'Disclaimer';

  @override
  String get disclaimerBody =>
      'TODO: results are reference values. (replace per app)';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageSystem => 'Follow system';

  @override
  String get paywallTitle => 'Upgrade to Pro';

  @override
  String paywallSubtitle(String price) {
    return 'One-time $price — not a subscription';
  }

  @override
  String get paywallBenefit1 => 'TODO: benefit 1';

  @override
  String get paywallBenefit2 => 'TODO: benefit 2';

  @override
  String get paywallBenefit3 => 'TODO: benefit 3';

  @override
  String get paywallBenefit4 => 'No ads, even if added in the future';

  @override
  String buyButton(String price) {
    return 'Buy for $price';
  }

  @override
  String get storeUnavailable => 'Could not connect to the store';

  @override
  String get purchaseError => 'An error occurred during purchase';
}

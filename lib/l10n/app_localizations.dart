import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Crochet Chart Designer'**
  String get appTitle;

  /// No description provided for @settingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTooltip;

  /// No description provided for @inputError.
  ///
  /// In en, this message translates to:
  /// **'Check the inputs (zero or negative values cannot be calculated)'**
  String get inputError;

  /// No description provided for @enterValues.
  ///
  /// In en, this message translates to:
  /// **'Enter values'**
  String get enterValues;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @proActive.
  ///
  /// In en, this message translates to:
  /// **'Pro active'**
  String get proActive;

  /// No description provided for @proActiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All features are unlocked'**
  String get proActiveSubtitle;

  /// No description provided for @upgradeTitle.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro'**
  String get upgradeTitle;

  /// No description provided for @upgradeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'TODO: one-line Pro pitch (one-time)'**
  String get upgradeSubtitle;

  /// No description provided for @restorePurchase.
  ///
  /// In en, this message translates to:
  /// **'Restore purchase'**
  String get restorePurchase;

  /// No description provided for @restoreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'After changing or resetting your device'**
  String get restoreSubtitle;

  /// No description provided for @restoreStarted.
  ///
  /// In en, this message translates to:
  /// **'Restore started'**
  String get restoreStarted;

  /// No description provided for @restoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not restore. Check your store connection'**
  String get restoreFailed;

  /// No description provided for @disclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer'**
  String get disclaimerTitle;

  /// No description provided for @disclaimerBody.
  ///
  /// In en, this message translates to:
  /// **'TODO: results are reference values. (replace per app)'**
  String get disclaimerBody;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get languageSystem;

  /// No description provided for @paywallTitle.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro'**
  String get paywallTitle;

  /// No description provided for @paywallSubtitle.
  ///
  /// In en, this message translates to:
  /// **'One-time {price} — not a subscription'**
  String paywallSubtitle(String price);

  /// No description provided for @paywallBenefit1.
  ///
  /// In en, this message translates to:
  /// **'TODO: benefit 1'**
  String get paywallBenefit1;

  /// No description provided for @paywallBenefit2.
  ///
  /// In en, this message translates to:
  /// **'TODO: benefit 2'**
  String get paywallBenefit2;

  /// No description provided for @paywallBenefit3.
  ///
  /// In en, this message translates to:
  /// **'TODO: benefit 3'**
  String get paywallBenefit3;

  /// No description provided for @paywallBenefit4.
  ///
  /// In en, this message translates to:
  /// **'No ads, even if added in the future'**
  String get paywallBenefit4;

  /// No description provided for @buyButton.
  ///
  /// In en, this message translates to:
  /// **'Buy for {price}'**
  String buyButton(String price);

  /// No description provided for @storeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to the store'**
  String get storeUnavailable;

  /// No description provided for @purchaseError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred during purchase'**
  String get purchaseError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

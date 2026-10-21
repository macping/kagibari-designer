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
  /// **'Unlimited rounds, all symbols, clean export'**
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
  /// **'All chart symbols are original artwork following JIS conventions. Finished work may vary with yarn and gauge.'**
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
  /// **'Unlimited rounds on round charts'**
  String get paywallBenefit1;

  /// No description provided for @paywallBenefit2.
  ///
  /// In en, this message translates to:
  /// **'All 32 crochet symbols'**
  String get paywallBenefit2;

  /// No description provided for @paywallBenefit3.
  ///
  /// In en, this message translates to:
  /// **'High-res export without watermark'**
  String get paywallBenefit3;

  /// No description provided for @paywallBenefit4.
  ///
  /// In en, this message translates to:
  /// **'No ads — ever'**
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

  /// No description provided for @homeTabCharts.
  ///
  /// In en, this message translates to:
  /// **'Charts'**
  String get homeTabCharts;

  /// No description provided for @homeTabSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get homeTabSettings;

  /// No description provided for @newRoundChart.
  ///
  /// In en, this message translates to:
  /// **'Round (amigurumi)'**
  String get newRoundChart;

  /// No description provided for @newGridChart.
  ///
  /// In en, this message translates to:
  /// **'Filet grid'**
  String get newGridChart;

  /// No description provided for @chartDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get chartDefaultTitle;

  /// No description provided for @emptyGallery.
  ///
  /// In en, this message translates to:
  /// **'No charts yet.\nCreate one from the buttons above.'**
  String get emptyGallery;

  /// No description provided for @renameTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get renameTitle;

  /// No description provided for @duplicateChart.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get duplicateChart;

  /// No description provided for @deleteChart.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteChart;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{title}\"?'**
  String deleteConfirm(String title);

  /// No description provided for @deleteOk.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteOk;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @roundsCount.
  ///
  /// In en, this message translates to:
  /// **'{n} rounds'**
  String roundsCount(int n);

  /// No description provided for @gridSize.
  ///
  /// In en, this message translates to:
  /// **'{c}×{r} cells'**
  String gridSize(int c, int r);

  /// No description provided for @undoTooltip.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undoTooltip;

  /// No description provided for @redoTooltip.
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get redoTooltip;

  /// No description provided for @eraserTooltip.
  ///
  /// In en, this message translates to:
  /// **'Eraser'**
  String get eraserTooltip;

  /// No description provided for @roundSettingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Stitches per round'**
  String get roundSettingsTooltip;

  /// No description provided for @exportTooltip.
  ///
  /// In en, this message translates to:
  /// **'Export & share'**
  String get exportTooltip;

  /// No description provided for @catBasic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get catBasic;

  /// No description provided for @catIncDec.
  ///
  /// In en, this message translates to:
  /// **'Inc / dec'**
  String get catIncDec;

  /// No description provided for @catFancy.
  ///
  /// In en, this message translates to:
  /// **'Bobbles & texture'**
  String get catFancy;

  /// No description provided for @proLockedSymbol.
  ///
  /// In en, this message translates to:
  /// **'This symbol unlocks with Pro'**
  String get proLockedSymbol;

  /// No description provided for @addRound.
  ///
  /// In en, this message translates to:
  /// **'Add round'**
  String get addRound;

  /// No description provided for @removeRound.
  ///
  /// In en, this message translates to:
  /// **'Remove last round'**
  String get removeRound;

  /// No description provided for @roundLabel.
  ///
  /// In en, this message translates to:
  /// **'Round {n}'**
  String roundLabel(int n);

  /// No description provided for @freeRoundLimit.
  ///
  /// In en, this message translates to:
  /// **'The free version is limited to 6 rounds. Pro removes the limit.'**
  String get freeRoundLimit;

  /// No description provided for @gridSizeTitle.
  ///
  /// In en, this message translates to:
  /// **'Grid size'**
  String get gridSizeTitle;

  /// No description provided for @rowsLabel.
  ///
  /// In en, this message translates to:
  /// **'Rows'**
  String get rowsLabel;

  /// No description provided for @colsLabel.
  ///
  /// In en, this message translates to:
  /// **'Columns'**
  String get colsLabel;

  /// No description provided for @exportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get exportTitle;

  /// No description provided for @exportPng.
  ///
  /// In en, this message translates to:
  /// **'Share as PNG'**
  String get exportPng;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Share as PDF'**
  String get exportPdf;

  /// No description provided for @resolutionLabel.
  ///
  /// In en, this message translates to:
  /// **'Resolution'**
  String get resolutionLabel;

  /// No description provided for @watermarkNotice.
  ///
  /// In en, this message translates to:
  /// **'Free exports include a small watermark'**
  String get watermarkNotice;

  /// No description provided for @proResolution.
  ///
  /// In en, this message translates to:
  /// **'High resolutions are available with Pro'**
  String get proResolution;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed'**
  String get exportFailed;

  /// No description provided for @backupExport.
  ///
  /// In en, this message translates to:
  /// **'Export all charts'**
  String get backupExport;

  /// No description provided for @backupExportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save or share everything as one backup file'**
  String get backupExportSubtitle;

  /// No description provided for @backupImport.
  ///
  /// In en, this message translates to:
  /// **'Import backup'**
  String get backupImport;

  /// No description provided for @backupImportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Restore charts from a backup file'**
  String get backupImportSubtitle;

  /// No description provided for @backupImported.
  ///
  /// In en, this message translates to:
  /// **'Imported {n} charts'**
  String backupImported(int n);

  /// No description provided for @backupFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not read that file'**
  String get backupFailed;

  /// No description provided for @backupEmpty.
  ///
  /// In en, this message translates to:
  /// **'There are no charts to export'**
  String get backupEmpty;

  /// No description provided for @replayOnboarding.
  ///
  /// In en, this message translates to:
  /// **'View the tutorial again'**
  String get replayOnboarding;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get onboardingStart;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Sketch the chart in your head'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Body.
  ///
  /// In en, this message translates to:
  /// **'Round charts for amigurumi and filet grids — with true per-round stitch counts.'**
  String get onboarding1Body;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Pick a symbol, place it'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Body.
  ///
  /// In en, this message translates to:
  /// **'Symbols snap to the grid and rotate automatically on round charts.'**
  String get onboarding2Body;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'No ads. Fully offline.'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Body.
  ///
  /// In en, this message translates to:
  /// **'Pro unlocks unlimited rounds, all symbols, and high-res watermark-free export.'**
  String get onboarding3Body;
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

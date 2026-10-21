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
  String get upgradeSubtitle => 'Unlimited rounds, all symbols, clean export';

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
      'All chart symbols are original artwork following JIS conventions. Finished work may vary with yarn and gauge.';

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
  String get paywallBenefit1 => 'Unlimited rounds on round charts';

  @override
  String get paywallBenefit2 => 'All 32 crochet symbols';

  @override
  String get paywallBenefit3 => 'High-res export without watermark';

  @override
  String get paywallBenefit4 => 'No ads — ever';

  @override
  String buyButton(String price) {
    return 'Buy for $price';
  }

  @override
  String get storeUnavailable => 'Could not connect to the store';

  @override
  String get purchaseError => 'An error occurred during purchase';

  @override
  String get homeTabCharts => 'Charts';

  @override
  String get homeTabSettings => 'Settings';

  @override
  String get newRoundChart => 'Round (amigurumi)';

  @override
  String get newGridChart => 'Filet grid';

  @override
  String get chartDefaultTitle => 'Untitled';

  @override
  String get emptyGallery =>
      'No charts yet.\nCreate one from the buttons above.';

  @override
  String get renameTitle => 'Rename';

  @override
  String get duplicateChart => 'Duplicate';

  @override
  String get deleteChart => 'Delete';

  @override
  String deleteConfirm(String title) {
    return 'Delete \"$title\"?';
  }

  @override
  String get deleteOk => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String roundsCount(int n) {
    return '$n rounds';
  }

  @override
  String gridSize(int c, int r) {
    return '$c×$r cells';
  }

  @override
  String get undoTooltip => 'Undo';

  @override
  String get redoTooltip => 'Redo';

  @override
  String get eraserTooltip => 'Eraser';

  @override
  String get roundSettingsTooltip => 'Stitches per round';

  @override
  String get exportTooltip => 'Export & share';

  @override
  String get catBasic => 'Basic';

  @override
  String get catIncDec => 'Inc / dec';

  @override
  String get catFancy => 'Bobbles & texture';

  @override
  String get proLockedSymbol => 'This symbol unlocks with Pro';

  @override
  String get addRound => 'Add round';

  @override
  String get removeRound => 'Remove last round';

  @override
  String roundLabel(int n) {
    return 'Round $n';
  }

  @override
  String get freeRoundLimit =>
      'The free version is limited to 6 rounds. Pro removes the limit.';

  @override
  String get gridSizeTitle => 'Grid size';

  @override
  String get rowsLabel => 'Rows';

  @override
  String get colsLabel => 'Columns';

  @override
  String get exportTitle => 'Export';

  @override
  String get exportPng => 'Share as PNG';

  @override
  String get exportPdf => 'Share as PDF';

  @override
  String get resolutionLabel => 'Resolution';

  @override
  String get watermarkNotice => 'Free exports include a small watermark';

  @override
  String get proResolution => 'High resolutions are available with Pro';

  @override
  String get exportFailed => 'Export failed';

  @override
  String get backupExport => 'Export all charts';

  @override
  String get backupExportSubtitle =>
      'Save or share everything as one backup file';

  @override
  String get backupImport => 'Import backup';

  @override
  String get backupImportSubtitle => 'Restore charts from a backup file';

  @override
  String backupImported(int n) {
    return 'Imported $n charts';
  }

  @override
  String get backupFailed => 'Could not read that file';

  @override
  String get backupEmpty => 'There are no charts to export';

  @override
  String get replayOnboarding => 'View the tutorial again';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingStart => 'Start';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboarding1Title => 'Sketch the chart in your head';

  @override
  String get onboarding1Body =>
      'Round charts for amigurumi and filet grids — with true per-round stitch counts.';

  @override
  String get onboarding2Title => 'Pick a symbol, place it';

  @override
  String get onboarding2Body =>
      'Symbols snap to the grid and rotate automatically on round charts.';

  @override
  String get onboarding3Title => 'No ads. Fully offline.';

  @override
  String get onboarding3Body =>
      'Pro unlocks unlimited rounds, all symbols, and high-res watermark-free export.';
}

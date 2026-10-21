import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/purchase/paywall_sheet.dart';
import '../../../core/purchase/pro_entitlement.dart';
import '../../../core/purchase/purchase_service.dart';
import '../../../core/settings/locale_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../../charts/data/chart_repository.dart';
import '../../onboarding/onboarding_screen.dart';

/// 設定: Pro購入/復元・言語・バックアップ・使い方再視聴・免責事項。
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.entitlement,
    required this.purchaseService,
    required this.localeController,
    this.repository,
  });

  final ProEntitlement entitlement;
  final PurchaseService? purchaseService;
  final LocaleController localeController;

  /// null ならバックアップ節を出さない（単体テスト用）。
  final ChartRepository? repository;

  /// 各言語は必ず自言語で表記（今の表示言語に依存しない）
  static const _languageNames = {'ja': '日本語', 'en': 'English', 'zh': '简体中文'};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        automaticallyImplyLeading: false,
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([entitlement, localeController]),
        builder: (context, _) => ListView(
          children: [
            if (entitlement.isPro)
              ListTile(
                leading: Icon(Icons.verified, color: theme.colorScheme.primary),
                title: Text(l10n.proActive),
                subtitle: Text(l10n.proActiveSubtitle),
              )
            else ...[
              ListTile(
                leading: const Icon(Icons.workspace_premium),
                title: Text(l10n.upgradeTitle),
                subtitle: Text(l10n.upgradeSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    showPaywallSheet(context, purchaseService: purchaseService),
              ),
              ListTile(
                leading: const Icon(Icons.restore),
                title: Text(l10n.restorePurchase),
                subtitle: Text(l10n.restoreSubtitle),
                onTap: purchaseService == null
                    ? null
                    : () async {
                        final messenger = ScaffoldMessenger.of(context);
                        final result = await purchaseService!.restore();
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(switch (result) {
                              PurchaseUiResult.pending ||
                              PurchaseUiResult.success => l10n.restoreStarted,
                              _ => l10n.restoreFailed,
                            }),
                          ),
                        );
                      },
              ),
            ],
            const Divider(),
            if (repository != null) ...[
              ListTile(
                leading: const Icon(Icons.upload_file_outlined),
                title: Text(l10n.backupExport),
                subtitle: Text(l10n.backupExportSubtitle),
                onTap: () => _exportBackup(context, l10n),
              ),
              ListTile(
                leading: const Icon(Icons.download_outlined),
                title: Text(l10n.backupImport),
                subtitle: Text(l10n.backupImportSubtitle),
                onTap: () => _importBackup(context, l10n),
              ),
              const Divider(),
            ],
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(l10n.languageTitle),
              subtitle: Text(
                localeController.locale == null
                    ? l10n.languageSystem
                    : _languageNames[localeController.locale!.languageCode] ??
                          localeController.locale!.languageCode,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showLanguagePicker(context, l10n),
            ),
            ListTile(
              leading: const Icon(Icons.school_outlined),
              title: Text(l10n.replayOnboarding),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (routeContext) => OnboardingScreen(
                    review: true,
                    onFinished: () => Navigator.of(routeContext).pop(),
                  ),
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.disclaimerTitle),
              subtitle: Text(l10n.disclaimerBody),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportBackup(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final charts = await repository!.loadAll();
      if (charts.isEmpty) {
        messenger.showSnackBar(SnackBar(content: Text(l10n.backupEmpty)));
        return;
      }
      final payload = repository!.encodeBackup(charts);
      final dir = await getTemporaryDirectory();
      final stamp = DateTime.now().toIso8601String().split('T').first;
      final file = File('${dir.path}/kagibari-backup-$stamp.json');
      await file.writeAsString(payload, flush: true);
      await Share.shareXFiles([
        XFile(file.path, mimeType: 'application/json'),
      ]);
    } on Exception {
      messenger.showSnackBar(SnackBar(content: Text(l10n.backupFailed)));
    }
  }

  Future<void> _importBackup(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      const typeGroup = XTypeGroup(
        label: 'backup',
        extensions: ['json'],
        mimeTypes: ['application/json'],
      );
      final file = await openFile(acceptedTypeGroups: const [typeGroup]);
      if (file == null) return;
      final imported = await repository!.importBackup(
        await file.readAsString(),
      );
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.backupImported(imported))),
      );
    } on Exception {
      messenger.showSnackBar(SnackBar(content: Text(l10n.backupFailed)));
    }
  }

  Future<void> _showLanguagePicker(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final current = localeController.locale?.languageCode;
    final choice = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.languageTitle),
        children: [
          RadioGroup<String>(
            groupValue: current ?? 'system',
            onChanged: (v) => Navigator.pop(context, v),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  value: 'system',
                  title: Text(l10n.languageSystem),
                ),
                for (final code in LocaleController.supported)
                  RadioListTile<String>(
                    value: code.languageCode,
                    title: Text(_languageNames[code.languageCode]!),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
    if (choice == null) return;
    await localeController.setLocale(
      choice == 'system' ? null : Locale(choice),
    );
  }
}

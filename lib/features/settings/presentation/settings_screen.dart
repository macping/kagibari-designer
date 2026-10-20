import 'package:flutter/material.dart';

import '../../../core/purchase/paywall_sheet.dart';
import '../../../core/purchase/pro_entitlement.dart';
import '../../../core/purchase/purchase_service.dart';
import '../../../core/settings/locale_controller.dart';
import '../../../l10n/app_localizations.dart';

/// 設定: Pro購入/復元・言語・免責事項。
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.entitlement,
    required this.purchaseService,
    required this.localeController,
  });

  final ProEntitlement entitlement;
  final PurchaseService? purchaseService;
  final LocaleController localeController;

  /// 各言語は必ず自言語で表記（今の表示言語に依存しない）
  static const _languageNames = {'ja': '日本語', 'en': 'English', 'zh': '简体中文'};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
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

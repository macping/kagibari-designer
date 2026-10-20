import 'package:flutter/material.dart';

import 'core/purchase/pro_entitlement.dart';
import 'core/purchase/purchase_service.dart';
import 'core/settings/locale_controller.dart';
import 'features/settings/presentation/settings_screen.dart';
import 'l10n/app_localizations.dart';

/// 占位ホーム。类型砖（microcalc_shell 等）が本文件を上書きする。
class HomeShell extends StatelessWidget {
  const HomeShell({
    super.key,
    required this.entitlement,
    this.purchaseService,
    required this.localeController,
  });

  final ProEntitlement entitlement;
  final PurchaseService? purchaseService;
  final LocaleController localeController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settingsTooltip,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => SettingsScreen(
                  entitlement: entitlement,
                  purchaseService: purchaseService,
                  localeController: localeController,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(child: Text(l10n.appTitle)),
    );
  }
}

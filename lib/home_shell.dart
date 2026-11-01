import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'core/purchase/pro_entitlement.dart';
import 'core/purchase/purchase_service.dart';
import 'core/settings/locale_controller.dart';
import 'core/update/update_checker.dart';
import 'features/charts/data/chart_repository.dart';
import 'features/charts/presentation/chart_list_screen.dart';
import 'features/settings/presentation/settings_screen.dart';
import 'l10n/app_localizations.dart';

/// ホーム: 作品一覧 ⇄ 設定（手势红线: 並列画面は PageView で swipe 同期、
/// タブタップ= animateToPage、各ページは KeepAlive で状態保持）。
class HomeShell extends StatefulWidget {
  const HomeShell({
    super.key,
    required this.entitlement,
    this.purchaseService,
    required this.localeController,
    required this.repository,
    this.updateChecker,
  });

  final ProEntitlement entitlement;
  final PurchaseService? purchaseService;
  final LocaleController localeController;
  final ChartRepository repository;

  /// null = 検出しない（テスト・プレビュー既定）。
  final UpdateChecker? updateChecker;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final PageController _pageController = PageController();
  int _page = 0;

  /// 非強制アップデート案内（§6）: 検出時のみ非 null。
  /// 閉じると null に戻し、この起動中は再表示しない（次回起動で再検出）。
  UpdateInfo? _updateInfo;

  @override
  void initState() {
    super.initState();
    widget.updateChecker?.check().then((info) {
      if (mounted && info != null) setState(() => _updateInfo = info);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _openStore(Uri uri) async {
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Exception {
      // ストアが開けない環境では何もしない（非強制）
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final updateInfo = _updateInfo;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) => setState(() => _page = page),
              children: [
                ChartListScreen(
                  repository: widget.repository,
                  entitlement: widget.entitlement,
                  purchaseService: widget.purchaseService,
                ),
                SettingsScreen(
                  entitlement: widget.entitlement,
                  purchaseService: widget.purchaseService,
                  localeController: widget.localeController,
                  repository: widget.repository,
                ),
              ],
            ),
          ),
          // 非模态提示条: 画面操作を一切阻断しない（ホームのみ・編集器には出ない）
          if (updateInfo != null)
            Material(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: SafeArea(
                top: false,
                bottom: false,
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Icon(
                      Icons.system_update_alt,
                      size: 20,
                      color:
                          Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.updateAvailable,
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _openStore(updateInfo.storeUri),
                      child: Text(l10n.updateAction),
                    ),
                    IconButton(
                      tooltip: l10n.closeTooltip,
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => setState(() => _updateInfo = null),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _page,
        onDestinationSelected: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.collections_bookmark_outlined),
            selectedIcon: const Icon(Icons.collections_bookmark),
            label: l10n.homeTabCharts,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.homeTabSettings,
          ),
        ],
      ),
    );
  }
}

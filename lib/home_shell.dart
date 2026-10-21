import 'package:flutter/material.dart';

import 'core/purchase/pro_entitlement.dart';
import 'core/purchase/purchase_service.dart';
import 'core/settings/locale_controller.dart';
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
  });

  final ProEntitlement entitlement;
  final PurchaseService? purchaseService;
  final LocaleController localeController;
  final ChartRepository repository;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final PageController _pageController = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: PageView(
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

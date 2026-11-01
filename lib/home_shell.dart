import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'core/app_links.dart';
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
    this.updatePromptSuppressed = false,
  });

  final ProEntitlement entitlement;
  final PurchaseService? purchaseService;
  final LocaleController localeController;
  final ChartRepository repository;

  /// 升級検出（mobile-day1 §6 改訂 8462454）。検出のみ・底部シートで案内・
  /// 閉じたら**その版は二度と出さない**（版本記憶——ストアにさらに新しい版が
  /// 出たときだけ再案内）。null = 検出しない（テスト・プレビュー既定）。
  final UpdateChecker? updateChecker;

  /// true = この起動は首回引導から始まった——引導に被せない（次回起動で再検出）。
  final bool updatePromptSuppressed;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final PageController _pageController = PageController();
  int _page = 0;

  /// 「この版は案内済み」の記憶キー（版本記憶）。
  static const _dismissedVersionKey = 'update.dismissedVersion';

  @override
  void initState() {
    super.initState();
    _checkUpdate();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _checkUpdate() async {
    final checker = widget.updateChecker;
    if (checker == null) return;
    // 首回起動の引導があった起動では案内しない（次回起動で再検出される）
    if (widget.updatePromptSuppressed) return;
    final offer = await checker.checkForUpdate();
    if (offer == null || !mounted) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      // 版本記憶: 一度閉じた版は再案内しない（より新しい版でのみ再び出す）
      if (prefs.getString(_dismissedVersionKey) == offer.availableVersion) {
        return;
      }
      if (!mounted) return;
      await _showUpdateSheet(offer);
      await prefs.setString(_dismissedVersionKey, offer.availableVersion);
    } catch (_) {
      // prefs 不達は静默（案内が出ないだけ）
    }
  }

  /// e5 単行緊湊シート（2026-11-01 用户裁决定稿）: dragHandle +
  /// 丸底アイコン + 単行タイトル + 右下「あとで/更新する」。
  /// 遮罩タップ・下スワイプ・あとで、いずれの閉じ方でも版本記憶が効く。
  Future<void> _showUpdateSheet(UpdateOffer offer) async {
    final l10n = AppLocalizations.of(context)!;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        final scheme = Theme.of(sheetContext).colorScheme;
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: scheme.primaryContainer,
                    child: Icon(
                      Icons.rocket_launch_outlined,
                      size: 18,
                      color: scheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.updateAvailable,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    child: Text(l10n.updateLater),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      _openStore(offer.storeUri);
                    },
                    child: Text(l10n.updateAction),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// ストアの詳細ページへ。market: が開けない環境では https へ回落。
  Future<void> _openStore(Uri uri) async {
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && uri.scheme == 'market') {
        await launchUrl(
          Uri.parse(kPlayStoreUrl),
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (_) {
      // ストアが開けない環境では何もしない（非強制）
    }
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

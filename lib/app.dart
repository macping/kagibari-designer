import 'package:flutter/material.dart';

import 'core/purchase/pro_entitlement.dart';
import 'core/purchase/purchase_service.dart';
import 'core/settings/locale_controller.dart';
import 'core/theme/app_theme.dart';
import 'home_shell.dart';
import 'l10n/app_localizations.dart';

/// アプリのルート。日/英/中の3言語、既定はシステム追従。
/// （类型砖——如 microcalc_shell——会用带 DB 注入的版本覆盖本文件）
class App extends StatefulWidget {
  const App({
    super.key,
    this.entitlement,
    this.purchaseService,
    this.localeController,
  });

  /// null なら未購入状態で起動（テスト・プレビュー用）。
  final ProEntitlement? entitlement;

  final PurchaseService? purchaseService;

  /// null ならシステム追従で起動。
  final LocaleController? localeController;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // purchaseService だけ渡された場合も同一の entitlement を見る
  //（別インスタンスだと購入完了がUIに反映されない）。
  late final ProEntitlement _entitlement = widget.entitlement ??
      widget.purchaseService?.entitlement ??
      ProEntitlement();
  late final LocaleController _localeController =
      widget.localeController ?? LocaleController();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _localeController,
      builder: (context, _) => MaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        locale: _localeController.locale,
        supportedLocales: LocaleController.supported,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        // 非対応言語のシステムは en へフォールバック（既定の「先頭=ja」を避ける）
        localeResolutionCallback: (device, supported) {
          final wanted = _localeController.locale ?? device;
          if (wanted != null) {
            for (final l in supported) {
              if (l.languageCode == wanted.languageCode) return l;
            }
          }
          return const Locale('en');
        },
        home: HomeShell(
          entitlement: _entitlement,
          purchaseService: widget.purchaseService,
          localeController: _localeController,
        ),
      ),
    );
  }
}

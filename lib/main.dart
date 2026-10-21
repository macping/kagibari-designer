import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/purchase/pro_entitlement.dart';
import 'core/purchase/purchase_service.dart';
import 'core/settings/locale_controller.dart';
import 'features/charts/data/chart_repository.dart';
import 'features/charts/presentation/chart_canvas.dart';
import 'features/onboarding/onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 描画例外の最終兜底: release の灰色画面/白画面の代わりに
  // 最小限のメッセージを出す（l10n 到達前でも安全な静的3言語）。
  ErrorWidget.builder = (details) => const Directionality(
    textDirection: TextDirection.ltr,
    child: ColoredBox(
      color: Color(0xFFF9F9FF),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            '⚠️\nエラーが発生しました\nAn error occurred / 发生错误',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF1A1B20)),
          ),
        ),
      ),
    ),
  );
  final entitlement = ProEntitlement();
  final localeController = LocaleController();
  await entitlement.load();
  await localeController.load();
  final repository = await ChartRepository.openDefault();
  final prefs = await SharedPreferences.getInstance();
  final onboardingSeen = prefs.getBool(onboardingSeenKey) ?? false;
  final purchaseService = PurchaseService(entitlement: entitlement)..init();
  // 記号 SVG の Picture 化はバックグラウンドで先行開始（エディタ初回表示を速く）
  unawaited(SymbolPictureCache.warmUp());
  runApp(
    App(
      entitlement: entitlement,
      purchaseService: purchaseService,
      localeController: localeController,
      repository: repository,
      showOnboarding: !onboardingSeen,
    ),
  );
}

import 'package:flutter/material.dart';

import 'app.dart';
import 'core/purchase/pro_entitlement.dart';
import 'core/purchase/purchase_service.dart';
import 'core/settings/locale_controller.dart';

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
  final purchaseService = PurchaseService(entitlement: entitlement)..init();
  runApp(
    App(
      entitlement: entitlement,
      purchaseService: purchaseService,
      localeController: localeController,
    ),
  );
}

/// paywall 回帰: 失敗フィードバックはモーダルシート内に表示される
/// （SnackBar はシート背後の Scaffold に出て見えない——2026-09-07 schiessbuch 実機確認）。
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:kagibari_designer/app.dart';
import 'package:kagibari_designer/core/purchase/pro_entitlement.dart';
import 'package:kagibari_designer/core/purchase/purchase_service.dart';
import 'package:kagibari_designer/core/settings/locale_controller.dart';

/// コンストラクタ経由でしか触られないダミー（メソッドは一切呼ばれない）。
class _NoopIap implements InAppPurchase {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('IAP はテストで触ってはいけない');
}

/// ストア不達を再現するサービス。
class _UnavailableService extends PurchaseService {
  _UnavailableService(ProEntitlement entitlement)
    : super(entitlement: entitlement, iap: _NoopIap());

  @override
  Future<ProductDetails?> queryProduct() async => null;

  @override
  Future<PurchaseUiResult> buy() async => PurchaseUiResult.unavailable;

  @override
  Future<PurchaseUiResult> restore() async => PurchaseUiResult.unavailable;
}

void main() {
  testWidgets('購入失敗フィードバックがシート内に出る（ja）', (tester) async {
    final entitlement = ProEntitlement.forTest();
    await tester.pumpWidget(
      App(
        entitlement: entitlement,
        purchaseService: _UnavailableService(entitlement),
        localeController: LocaleController.forTest('ja'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pro版にアップグレード'));
    await tester.pumpAndSettle();

    // 購入ボタン（シート内唯一の FilledButton）を押す → シート内に文言
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(find.text('ストアに接続できませんでした'), findsOneWidget);
    // シートは開いたまま（リトライ可能）
    expect(find.byType(FilledButton), findsOneWidget);
  });
}

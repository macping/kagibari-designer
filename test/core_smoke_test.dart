/// コア骨格のスモークテスト（狭小画面 320×568 で溢れ検知込み）。
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kagibari_designer/app.dart';
import 'package:kagibari_designer/core/purchase/pro_entitlement.dart';
import 'package:kagibari_designer/core/settings/locale_controller.dart';

void main() {
  // テスト機のシステム locale は en のため、ja を明示固定する。
  Widget buildApp({bool isPro = false}) => App(
    entitlement: ProEntitlement.forTest(isPro: isPro),
    localeController: LocaleController.forTest('ja'),
  );

  testWidgets('起動して設定を開ける（320×568）', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('設定'), findsOneWidget);
  });

  testWidgets('未購入: 設定からペイウォールが開き価格が出る', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pro版にアップグレード'));
    await tester.pumpAndSettle();

    expect(find.textContaining('¥800'), findsWidgets);
  });

  testWidgets('Pro購入済み: 設定に利用中表示', (tester) async {
    await tester.pumpWidget(buildApp(isPro: true));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Pro版 利用中'), findsOneWidget);
  });
}

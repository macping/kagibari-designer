/// 升級提示（§6 改訂 8462454・be-dagontvangsten 標準モード）の红线回归:
/// 新版→底部シート→閉じたらその版は二度と出ない（版本記憶）、
/// さらに新しい版でのみ再案内、首回引導の起動では出ない。
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kagibari_designer/app.dart';
import 'package:kagibari_designer/core/purchase/pro_entitlement.dart';
import 'package:kagibari_designer/core/settings/locale_controller.dart';
import 'package:kagibari_designer/core/update/update_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeUpdateChecker implements UpdateChecker {
  _FakeUpdateChecker(this.offer);

  final UpdateOffer? offer;

  @override
  Future<UpdateOffer?> checkForUpdate() async => offer;
}

UpdateOffer _offer(String version) => UpdateOffer(
      storeUri: Uri.parse('market://details?id=test'),
      availableVersion: version,
    );

void main() {
  Widget buildApp({UpdateChecker? updateChecker, bool showOnboarding = false}) =>
      App(
        entitlement: ProEntitlement.forTest(),
        localeController: LocaleController.forTest('ja'),
        showOnboarding: showOnboarding,
        updateChecker: updateChecker,
      );

  testWidgets('新版あり: シートが出て「あとで」で閉じ、版本記憶が保存される', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      buildApp(updateChecker: _FakeUpdateChecker(_offer('7'))),
    );
    await tester.pumpAndSettle();

    expect(find.text('新しいバージョンがあります'), findsOneWidget);
    expect(find.text('あとで'), findsOneWidget);
    expect(find.text('更新する'), findsOneWidget);

    await tester.tap(find.text('あとで'));
    await tester.pumpAndSettle();
    expect(find.text('新しいバージョンがあります'), findsNothing);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('update.dismissedVersion'), '7');
  });

  testWidgets('同版は記憶済みなら再案内しない（同版重启不再弹）', (tester) async {
    SharedPreferences.setMockInitialValues({'update.dismissedVersion': '7'});
    await tester.pumpWidget(
      buildApp(updateChecker: _FakeUpdateChecker(_offer('7'))),
    );
    await tester.pumpAndSettle();
    expect(find.text('新しいバージョンがあります'), findsNothing);
  });

  testWidgets('より新しい版が出たときだけ再案内する', (tester) async {
    SharedPreferences.setMockInitialValues({'update.dismissedVersion': '7'});
    await tester.pumpWidget(
      buildApp(updateChecker: _FakeUpdateChecker(_offer('8'))),
    );
    await tester.pumpAndSettle();
    expect(find.text('新しいバージョンがあります'), findsOneWidget);
  });

  testWidgets('新版なし: シートは出ない', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(buildApp(updateChecker: _FakeUpdateChecker(null)));
    await tester.pumpAndSettle();
    expect(find.text('新しいバージョンがあります'), findsNothing);
  });

  testWidgets('首回引導のあった起動では案内しない（引导互斥）', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      buildApp(
        updateChecker: _FakeUpdateChecker(_offer('7')),
        showOnboarding: true,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('スキップ'));
    await tester.pumpAndSettle();

    // 主画面には到達するが、この起動では升級案内を出さない
    expect(find.text('編み図デザイナー'), findsOneWidget);
    expect(find.text('新しいバージョンがあります'), findsNothing);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('update.dismissedVersion'), isNull);
  });

  test('バージョン比較: ドット区切り数値で正しく判定', () {
    expect(AppUpdateChecker.isNewerVersion('1.0.1', '1.0.0'), isTrue);
    expect(AppUpdateChecker.isNewerVersion('1.2.10', '1.2.9'), isTrue);
    expect(AppUpdateChecker.isNewerVersion('2.0', '1.9.9'), isTrue);
    expect(AppUpdateChecker.isNewerVersion('1.0.0', '1.0.0'), isFalse);
    expect(AppUpdateChecker.isNewerVersion('1.0.0', '1.0.1'), isFalse);
    expect(AppUpdateChecker.isNewerVersion('1.0', '1.0.0'), isFalse);
  });

  testWidgets('設定: 応援・連絡は二菜単（評価tileなし・邮箱非表示）', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    // PageView と設定の ListView で Scrollable が複数あるため対象を明示
    await tester.dragUntilVisible(
      find.text('フィードバック'),
      find.byType(ListView),
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();
    expect(find.text('応援・連絡'), findsOneWidget);
    expect(find.text('友達に教える'), findsOneWidget);
    // 2026-11-01 改订: 評価は成功时刻 requestReview に一本化、設定から撤去
    expect(find.text('評価する'), findsNothing);
    // 宛先アドレスは UI に出さない（mailto 内のみ）
    expect(find.textContaining('@'), findsNothing);
  });
}

/// 升级提示条の红线回归（mobile-day1 §6）:
/// 新版あり→条が出る→閉じで消える→主画面操作は一切阻断されない。
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kagibari_designer/app.dart';
import 'package:kagibari_designer/core/purchase/pro_entitlement.dart';
import 'package:kagibari_designer/core/settings/locale_controller.dart';
import 'package:kagibari_designer/core/update/update_checker.dart';

class _FakeUpdateChecker implements UpdateChecker {
  _FakeUpdateChecker(this.info);

  final UpdateInfo? info;

  @override
  Future<UpdateInfo?> check() async => info;
}

void main() {
  Widget buildApp({UpdateChecker? updateChecker}) => App(
    entitlement: ProEntitlement.forTest(),
    localeController: LocaleController.forTest('ja'),
    updateChecker: updateChecker,
  );

  testWidgets('新版あり: 提示条が出て、閉じると消え、操作を阻断しない', (tester) async {
    await tester.pumpWidget(
      buildApp(
        updateChecker: _FakeUpdateChecker(
          UpdateInfo(storeUri: Uri.parse('market://details?id=test')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('新しいバージョンがあります'), findsOneWidget);
    expect(find.text('更新'), findsOneWidget);

    // 条が出ている間も主画面操作は通る（設定タブへ移動できる）
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('言語'), findsOneWidget);
    expect(find.text('新しいバージョンがあります'), findsOneWidget);

    // 閉じる → 消える
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.text('新しいバージョンがあります'), findsNothing);
  });

  testWidgets('新版なし: 提示条は出ない', (tester) async {
    await tester.pumpWidget(buildApp(updateChecker: _FakeUpdateChecker(null)));
    await tester.pumpAndSettle();
    expect(find.text('新しいバージョンがあります'), findsNothing);
  });

  testWidgets('checker 未指定（テスト既定）: 提示条は出ない', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();
    expect(find.text('新しいバージョンがあります'), findsNothing);
  });

  test('バージョン比較: ドット区切り数値で正しく判定', () {
    expect(isNewerVersion('1.0.1', '1.0.0'), isTrue);
    expect(isNewerVersion('1.2.10', '1.2.9'), isTrue);
    expect(isNewerVersion('2.0', '1.9.9'), isTrue);
    expect(isNewerVersion('1.0.0', '1.0.0'), isFalse);
    expect(isNewerVersion('1.0.0', '1.0.1'), isFalse);
    expect(isNewerVersion('1.0', '1.0.0'), isFalse);
  });

  testWidgets('設定: 応援・連絡の三菜単が並ぶ（ja）', (tester) async {
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
    expect(find.text('評価する'), findsOneWidget);
    expect(find.text('友達に教える'), findsOneWidget);
  });
}

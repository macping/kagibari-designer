/// 首次启动引导の红线回归: スキップ→主画面直達・seen 持久化・再起動では出ない。
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kagibari_designer/app.dart';
import 'package:kagibari_designer/core/purchase/pro_entitlement.dart';
import 'package:kagibari_designer/core/settings/locale_controller.dart';
import 'package:kagibari_designer/features/onboarding/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Widget buildApp({required bool showOnboarding}) => App(
    entitlement: ProEntitlement.forTest(),
    localeController: LocaleController.forTest('ja'),
    showOnboarding: showOnboarding,
  );

  testWidgets('スキップ→主画面直達＋seen フラグ保存', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(buildApp(showOnboarding: true));
    await tester.pumpAndSettle();

    // 引導が出ている（スキップ常駐）
    expect(find.text('スキップ'), findsOneWidget);
    expect(find.text('編み図デザイナー'), findsNothing);

    await tester.tap(find.text('スキップ'));
    await tester.pumpAndSettle();

    // 主画面（作品一覧）に到達
    expect(find.text('編み図デザイナー'), findsOneWidget);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool(onboardingSeenKey), isTrue);
  });

  testWidgets('3ページ目まで進んで「はじめる」で完了する', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(buildApp(showOnboarding: true));
    await tester.pumpAndSettle();

    await tester.tap(find.text('次へ'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('次へ'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('はじめる'));
    await tester.pumpAndSettle();

    expect(find.text('編み図デザイナー'), findsOneWidget);
  });

  testWidgets('seen 済み（showOnboarding=false）では出ない', (tester) async {
    SharedPreferences.setMockInitialValues({onboardingSeenKey: true});
    await tester.pumpWidget(buildApp(showOnboarding: false));
    await tester.pumpAndSettle();

    expect(find.text('スキップ'), findsNothing);
    expect(find.text('編み図デザイナー'), findsOneWidget);
  });
}

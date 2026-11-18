/// 回帰（palette-scroll-rule・mobile-day1 §6 114746c／bobari 同病の横展開）:
/// 記号パレットの横 ListView 内タイルは Draggable で包むが、affinity 無指定だと
/// 即時認識器が横スワイプを奪い、360dp 級の窄屏で画面外に溢れた記号が
/// スクロールで永遠に出せない（2026-11-18 用户実機指摘）。
/// 処方 = `Draggable(affinity: Axis.vertical)`。本テストは修正前は赤。
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kagibari_designer/core/purchase/pro_entitlement.dart';
import 'package:kagibari_designer/features/charts/data/chart_repository.dart';
import 'package:kagibari_designer/features/charts/domain/chart.dart';
import 'package:kagibari_designer/features/charts/presentation/editor_screen.dart';
import 'package:kagibari_designer/l10n/app_localizations.dart';

void main() {
  late Directory tmp;

  setUp(() => tmp = Directory.systemTemp.createTempSync('kagibari_palette_'));
  tearDown(() => tmp.deleteSync(recursive: true));

  Future<void> pumpEditor(WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ja'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: EditorScreen(
          chart: Chart.newGrid(id: 'p', title: 'palette'),
          repository: ChartRepository(tmp),
          // Pro＝全タイルがロック解除＝全タイルが Draggable（最悪ケース）。
          // 無料層だとロックタイルは Draggable で包まれず再現にならない。
          entitlement: ProEntitlement.forTest(isPro: true),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1)); // warmUp 完了待ち
  }

  testWidgets('360dp: 増減目11記号はタイル上の横スワイプで末尾まで出せる', (tester) async {
    await pumpEditor(tester);

    await tester.tap(find.text('増減目'));
    await tester.pump();

    // 末尾記号（中長編み2目一度）は画面外＝ListView.builder 未ビルド
    expect(find.text('細2目入'), findsOneWidget);
    expect(find.text('中長2度'), findsNothing);

    // タイルの真上から横スワイプ（工単③の定式 drag(-400,0)）
    await tester.drag(find.text('細2目入'), const Offset(-400, 0));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(
      find.text('中長2度'),
      findsOneWidget,
      reason: 'タイル上の横スワイプでパレットが滑らない＝Draggable が手勢を奪っている',
    );
  });

  testWidgets('縦ドラッグではキャンバスへの Draggable が開始される（横譲渡の代償なし）',
      (tester) async {
    await pumpEditor(tester);

    final gesture =
        await tester.startGesture(tester.getCenter(find.text('鎖編み')));
    await gesture.moveBy(const Offset(0, -80));
    await tester.pump();

    // ドラッグ中は childWhenDragging = Opacity(0.4) が出る
    expect(
      tester
          .widgetList<Opacity>(find.byType(Opacity))
          .where((o) => o.opacity == 0.4),
      isNotEmpty,
      reason: '縦ドラッグで記号の Draggable が開始されること',
    );

    await gesture.up();
    await tester.pump();
  });
}

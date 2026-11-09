/// 回帰（title-overflow-rule）: 編集画面の顶栏題は単行硬截しない。
/// 2026-11-09 実機 QA: 日本語既定名「無題の編み図」が窄屏（360dp 級）で
/// 「無題の…」に截断された。実画面は一覧から push されるので戻るボタン付き
/// （題の容量 = 幅 − 戻る 56 − 右 4 アイコン 192 − 余白）——テストも同条件で測る。
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kagibari_designer/core/purchase/pro_entitlement.dart';
import 'package:kagibari_designer/features/charts/data/chart_repository.dart';
import 'package:kagibari_designer/features/charts/domain/chart.dart';
import 'package:kagibari_designer/features/charts/presentation/editor_screen.dart';
import 'package:kagibari_designer/l10n/app_localizations.dart';

void main() {
  late Directory tmp;

  setUp(() => tmp = Directory.systemTemp.createTempSync('kagibari_title_'));
  tearDown(() => tmp.deleteSync(recursive: true));

  /// 編集画面を push して、顶栏題の描画段落を返す。
  Future<RenderParagraph> pumpEditorTitle(
    WidgetTester tester, {
    required String locale,
    required String title,
    required double width,
    double textScale = 1.0,
  }) async {
    tester.view.physicalSize = Size(width, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        locale: Locale(locale),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
        home: const Scaffold(),
      ),
    );
    tester
        .state<NavigatorState>(find.byType(Navigator))
        .push(
          MaterialPageRoute<void>(
            builder: (_) => EditorScreen(
              chart: Chart.newGrid(id: 't', title: title),
              repository: ChartRepository(tmp),
              entitlement: ProEntitlement.forTest(),
            ),
          ),
        );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1)); // ルート遷移を終わらせる

    final titleText = find.descendant(
      of: find.byType(AppBar),
      matching: find.text(title),
    );
    expect(titleText, findsOneWidget);
    expect(find.byType(BackButton), findsOneWidget, reason: '実画面は戻るボタン付き');
    return tester.renderObject<RenderParagraph>(titleText);
  }

  Future<String> jaDefaultTitle() async =>
      (await AppLocalizations.delegate.load(const Locale('ja')))
          .chartDefaultTitle;

  testWidgets('日本語既定名は 360dp の顶栏で単行・全文表示（縮字号のみ）', (tester) async {
    final p = await pumpEditorTitle(
      tester,
      locale: 'ja',
      title: await jaDefaultTitle(),
      width: 360,
    );
    expect(p.didExceedMaxLines, isFalse, reason: '題が「…」に截断されている');
    // 22sp から縮んで入る（下限 15sp を割らない）
    final size = p.text.style!.fontSize!;
    expect(size, inInclusiveRange(15, 22));
  });

  testWidgets('日本語既定名は 360dp・文字拡大 1.15 でも截断されない', (tester) async {
    final p = await pumpEditorTitle(
      tester,
      locale: 'ja',
      title: await jaDefaultTitle(),
      width: 360,
      textScale: 1.15,
    );
    expect(p.didExceedMaxLines, isFalse);
  });

  testWidgets('日本語既定名は 340dp でも截断されない', (tester) async {
    final p = await pumpEditorTitle(
      tester,
      locale: 'ja',
      title: await jaDefaultTitle(),
      width: 340,
    );
    expect(p.didExceedMaxLines, isFalse);
  });

  // 英語/中国語は計測しない: flutter test の既定フォント（Ahem）は全字が
  // 正方形で、ラテン文字が実機より大幅に広く出るため。全角の日本語は実機と
  // 同寸なので、最悪ケースの日本語だけを守れば足りる。
}

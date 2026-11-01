/// 評価=成功时刻触发の計数ロジック単測（§6 改订红线:
/// requestReview 通道は必ず mock——実通道は测试で永久挂起する）。
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:kagibari_designer/core/review/review_prompter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('第3回目の書き出し成功でだけ requestReview が飛ぶ', () async {
    SharedPreferences.setMockInitialValues({});
    var calls = 0;
    final prompter = ReviewPrompter(requestReview: () async => calls++);

    await prompter.onExportSucceeded(); // 1
    await prompter.onExportSucceeded(); // 2
    expect(calls, 0, reason: '第1・2回では触发しない');

    await prompter.onExportSucceeded(); // 3
    expect(calls, 1, reason: '第3回でちょうど1回');

    await prompter.onExportSucceeded(); // 4
    await prompter.onExportSucceeded(); // 5
    expect(calls, 1, reason: '以降は再触发しない（配額は Google 管理に委ねる）');
  });

  test('計数はインスタンスを跨いで永続する', () async {
    SharedPreferences.setMockInitialValues({'export_success_count': 2});
    var calls = 0;
    final prompter = ReviewPrompter(requestReview: () async => calls++);
    await prompter.onExportSucceeded(); // 永続2 + 今回1 = 3
    expect(calls, 1);
  });

  test('requestReview の例外は静黙（計数は進む）', () async {
    SharedPreferences.setMockInitialValues({'export_success_count': 2});
    final prompter =
        ReviewPrompter(requestReview: () async => throw Exception('quota'));
    await prompter.onExportSucceeded();
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt('export_success_count'), 3);
  });
}

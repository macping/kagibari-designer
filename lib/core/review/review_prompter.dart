/// 評価リクエスト＝成功时刻触发（mobile-day1 §6 改订・2026-11-01 用户裁决）。
///
/// 本案の成功时刻 = **編み図の書き出し（共有）成功**。
/// - 同一インストールで第 [triggerCount] 回目の成功時に一度だけ
///   `InAppReview.requestReview()` を呼ぶ（応用内弹窗・ストアへ飛ばない）
/// - 表示配額・頻度は Google 側が管理——**静默不显示=正常**、
///   コードも UX も表示に依存しない
/// - 評分操纵红线: 前置提问・星级指定・奖励・诱导 UI は一切付けない
///   （API を黙って呼ぶだけ。この方針を変える変更は禁止）
library;

import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewPrompter {
  /// [requestReview] はテスト用注入口（実機では in_app_review 既定実装）。
  ReviewPrompter({Future<void> Function()? requestReview})
      : _requestReview = requestReview ?? _defaultRequestReview;

  static const _countKey = 'export_success_count';

  /// 第3回目の書き出し成功で一度だけ（建议≥3 準拠）。
  static const triggerCount = 3;

  final Future<void> Function() _requestReview;

  /// 書き出し成功時に呼ぶ。計数して、ちょうど [triggerCount] 回目なら
  /// 評価リクエストを投げる（それ以外は何もしない）。失敗は全て静黙。
  Future<void> onExportSucceeded() async {
    int count;
    try {
      final prefs = await SharedPreferences.getInstance();
      count = (prefs.getInt(_countKey) ?? 0) + 1;
      await prefs.setInt(_countKey, count);
    } on Exception {
      return; // 計数できない環境ではリクエストもしない
    }
    if (count != triggerCount) return;
    try {
      await _requestReview();
    } on Exception {
      // 配額切れ・ストア不在などは静黙（表示保証のない API）
    }
  }

  static Future<void> _defaultRequestReview() async {
    final review = InAppReview.instance;
    if (await review.isAvailable()) {
      await review.requestReview();
    }
  }
}

/// 起動後の非強制アップデート検出（mobile-day1 §6・2026-11-01 用户新规）。
///
/// - 検出のみ: in_app_update の flexible/immediate フローは使わない
/// - 失敗（機内モード・Play 不在・審査中など）は全て静黙で「新版なし」扱い
/// - 升级検出は「完全ローカル」原則下で唯一許可された読み取り専用
///   ネットワーク呼び出し（零データ送信・AdMob 同様の平台サービス例外）
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../app_links.dart';

/// 新版が検出されたときだけ値が返る。
class UpdateInfo {
  const UpdateInfo({required this.storeUri});

  /// 「更新」ボタンの遷移先（Android=market:// / iOS=App Store URL）。
  final Uri storeUri;
}

abstract class UpdateChecker {
  Future<UpdateInfo?> check();

  /// 実機用のプラットフォーム別実装。
  static UpdateChecker platform() => switch (defaultTargetPlatform) {
        TargetPlatform.android => AndroidUpdateChecker(),
        TargetPlatform.iOS => IosUpdateChecker(),
        _ => const NoUpdateChecker(),
      };
}

/// デスクトップ/テスト用: 常に「新版なし」。
class NoUpdateChecker implements UpdateChecker {
  const NoUpdateChecker();

  @override
  Future<UpdateInfo?> check() async => null;
}

class AndroidUpdateChecker implements UpdateChecker {
  @override
  Future<UpdateInfo?> check() async {
    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        return UpdateInfo(storeUri: Uri.parse(kPlayMarketUri));
      }
    } on Exception {
      // 静黙（Play 不在の端末・サイドロード・オフライン等）
    }
    return null;
  }
}

/// iOS: iTunes Lookup API で bundleId の最新版と比較する（双平台红线）。
class IosUpdateChecker implements UpdateChecker {
  @override
  Future<UpdateInfo?> check() async {
    try {
      final package = await PackageInfo.fromPlatform();
      final client = HttpClient()
        ..connectionTimeout = const Duration(seconds: 8);
      try {
        final request = await client.getUrl(
          Uri.parse(
            'https://itunes.apple.com/lookup?bundleId=${package.packageName}',
          ),
        );
        final response = await request.close();
        if (response.statusCode != 200) return null;
        final json = jsonDecode(await response.transform(utf8.decoder).join());
        final results = (json is Map ? json['results'] : null) as List?;
        if (results == null || results.isEmpty) return null;
        final first = results.first as Map;
        final latest = '${first['version']}';
        final trackId = first['trackId'];
        if (trackId != null && isNewerVersion(latest, package.version)) {
          return UpdateInfo(
            storeUri: Uri.parse('https://apps.apple.com/app/id$trackId'),
          );
        }
      } finally {
        client.close(force: true);
      }
    } on Exception {
      // 静黙
    }
    return null;
  }
}

/// '1.2.10' > '1.2.9' のようなドット区切り数値比較（非数値片は0扱い）。
@visibleForTesting
bool isNewerVersion(String latest, String current) {
  final a = latest.split('.');
  final b = current.split('.');
  final length = a.length > b.length ? a.length : b.length;
  for (var i = 0; i < length; i++) {
    final x = i < a.length ? int.tryParse(a[i].trim()) ?? 0 : 0;
    final y = i < b.length ? int.tryParse(b[i].trim()) ?? 0 : 0;
    if (x != y) return x > y;
  }
  return false;
}

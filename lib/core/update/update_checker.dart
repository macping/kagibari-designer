/// 起動時の升級検出（非強制・検出のみ。mobile-day1 §6 改訂 8462454 /
/// 参考実装=be-dagontvangsten——2026-11-01 標準昇格モード）。
/// - Android: in_app_update の checkForUpdate を**検出だけ**に使う
///   （内蔵の flexible/immediate フローは使わない）→ market 導線 URI を返す
/// - iOS: iTunes lookup API（bundleId）で最新バージョンと比較 → App Store URI
/// - 失敗（機内モード/無網/ストア不達）は null で**静默**——矩阵「完全本地」
///   原則下で許される唯一の只読網絡呼び出し（平台服務例外）、データ上传ゼロ
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// 検出結果: ストア導線 + 利用可能バージョン識別子。
/// [availableVersion] は「この版は案内済み」の記憶キーに使う
/// （Android=availableVersionCode の文字列 / iOS=ストア版番 x.y.z）。
class UpdateOffer {
  const UpdateOffer({required this.storeUri, required this.availableVersion});

  final Uri storeUri;
  final String availableVersion;
}

/// 新しいバージョンがあれば [UpdateOffer] を返す（なし/不明は null）。
abstract class UpdateChecker {
  Future<UpdateOffer?> checkForUpdate();
}

class AppUpdateChecker implements UpdateChecker {
  @override
  Future<UpdateOffer?> checkForUpdate() async {
    try {
      if (kIsWeb) return null;
      if (Platform.isAndroid) return await _checkAndroid();
      if (Platform.isIOS) return await _checkIos();
    } catch (_) {
      // 静默: 升級提示が出ないだけで、エラーは一切表示しない。
    }
    return null;
  }

  Future<UpdateOffer?> _checkAndroid() async {
    final info = await InAppUpdate.checkForUpdate();
    if (info.updateAvailability != UpdateAvailability.updateAvailable) {
      return null;
    }
    final pkg = (await PackageInfo.fromPlatform()).packageName;
    return UpdateOffer(
      storeUri: Uri.parse('market://details?id=$pkg'),
      availableVersion: '${info.availableVersionCode ?? 0}',
    );
  }

  Future<UpdateOffer?> _checkIos() async {
    final pkg = await PackageInfo.fromPlatform();
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 8);
    try {
      final req = await client.getUrl(
        Uri.parse(
          'https://itunes.apple.com/lookup?bundleId=${pkg.packageName}',
        ),
      );
      final res = await req.close();
      if (res.statusCode != 200) return null;
      final body = await res.transform(utf8.decoder).join();
      final json = jsonDecode(body) as Map<String, dynamic>;
      final results = json['results'] as List<dynamic>? ?? const [];
      if (results.isEmpty) return null;
      final first = results.first as Map<String, dynamic>;
      final storeVersion = first['version'] as String?;
      final url = first['trackViewUrl'] as String?;
      if (storeVersion == null || url == null) return null;
      if (!isNewerVersion(storeVersion, pkg.version)) return null;
      return UpdateOffer(
        storeUri: Uri.parse(url),
        availableVersion: storeVersion,
      );
    } finally {
      client.close(force: true);
    }
  }

  /// 'a.b.c' の数値比較（桁欠けは 0 扱い・数字以外は無視）。
  @visibleForTesting
  static bool isNewerVersion(String store, String local) {
    List<int> parse(String v) => v
        .split('.')
        .map((p) => int.tryParse(p.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0)
        .toList(growable: false);
    final s = parse(store);
    final l = parse(local);
    final n = s.length > l.length ? s.length : l.length;
    for (var i = 0; i < n; i++) {
      final a = i < s.length ? s[i] : 0;
      final b = i < l.length ? l[i] : 0;
      if (a != b) return a > b;
    }
    return false;
  }
}

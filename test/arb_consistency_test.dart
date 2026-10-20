/// 全 ARB の key 集合が en 基準（gen-l10n の template 錨）と完全一致する
/// ことを保証する（漏訳の常設検知）。
/// 言語方針:「主戦場国の言語 + 中日英基線」——主戦場は日本とは限らず
/// 世界中どこでもあり得る。追加言語（pipeline/tools/add_locale.mjs）も
/// 自動的に検査対象になる。
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('all app_*.arb key sets match en template baseline', () {
    final dir = Directory('lib/l10n');
    final arbs = dir
        .listSync()
        .whereType<File>()
        .where((f) => RegExp(r'app_[a-zA-Z]+\.arb$').hasMatch(f.path))
        .toList();
    expect(arbs.length, greaterThanOrEqualTo(3),
        reason: '基線は ja/en/zh の3言語以上');

    Set<String> keysOf(File f) {
      final map = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
      return map.keys.where((k) => !k.startsWith('@')).toSet();
    }

    final base = keysOf(File('lib/l10n/app_en.arb'));
    for (final f in arbs) {
      if (f.path.endsWith('app_en.arb')) continue;
      final keys = keysOf(f);
      expect(keys.difference(base), isEmpty,
          reason: '${f.path} has extra keys');
      expect(base.difference(keys), isEmpty,
          reason: '${f.path} is missing keys');
    }
  });
}

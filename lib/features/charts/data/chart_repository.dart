/// 編み図の永続化（1図=1 JSON ファイル・完全ローカル）と L1 バックアップ。
/// DB は使わない: 図数は多くて数百、全読みでも軽い。
/// IO は同期実装（数KB×数百件=ms オーダー。widget テストの FakeAsync でも
/// 実イベントループ待ちが発生せず、スピナー無限回転のフレークを構造的に断つ）。
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../domain/chart.dart';

class ChartRepository {
  ChartRepository(this.directory) {
    if (!directory.existsSync()) directory.createSync(recursive: true);
  }

  /// 実機用: アプリ文書ディレクトリ配下 charts/。
  static Future<ChartRepository> openDefault() async {
    final docs = await getApplicationDocumentsDirectory();
    return ChartRepository(Directory('${docs.path}/charts'));
  }

  final Directory directory;

  /// 書き込みのたびに増える——一覧画面はこれを listen して再読込する
  /// （バックアップ取り込みなど別画面からの変更も反映される）。
  final ValueNotifier<int> revision = ValueNotifier(0);

  void _bump() => revision.value++;

  File _fileOf(String id) => File('${directory.path}/$id.json');

  /// 更新日の新しい順で全件。壊れたファイルは黙って飛ばす（1件の破損で
  /// 一覧全体を道連れにしない）。
  Future<List<Chart>> loadAll() async {
    final charts = <Chart>[];
    for (final entity in directory.listSync()) {
      if (entity is! File || !entity.path.endsWith('.json')) continue;
      try {
        final json = jsonDecode(entity.readAsStringSync());
        if (json is Map) {
          charts.add(Chart.fromJson(json.cast<String, Object?>()));
        }
      } on Exception {
        // 破損ファイルはスキップ
      }
    }
    charts.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return charts;
  }

  Future<void> save(Chart chart) async {
    chart.updatedAt = DateTime.now();
    _fileOf(chart.id).writeAsStringSync(jsonEncode(chart.toJson()));
    _bump();
  }

  Future<void> delete(String id) async {
    final file = _fileOf(id);
    if (file.existsSync()) file.deleteSync();
    _bump();
  }

  // ---- L1 バックアップ（全図を1ファイルに・アカウント不要） ----

  static const backupVersion = 1;

  String encodeBackup(List<Chart> charts) => jsonEncode({
        'app': 'kagibari-designer',
        'backupVersion': backupVersion,
        'exportedAt': DateTime.now().toIso8601String(),
        'charts': [for (final c in charts) c.toJson()],
      });

  /// バックアップ文字列を解析。形式不正は FormatException。
  static List<Chart> decodeBackup(String source) {
    final json = jsonDecode(source);
    if (json is! Map || json['charts'] is! List) {
      throw const FormatException('not a kagibari backup');
    }
    return [
      for (final c in json['charts'] as List)
        if (c is Map) Chart.fromJson(c.cast<String, Object?>()),
    ];
  }

  /// バックアップ取り込み: 同一 id は更新日が新しい方を残す。
  /// 戻り値 = 取り込んだ（新規+上書き）件数。
  Future<int> importBackup(String source) async {
    final incoming = decodeBackup(source);
    var imported = 0;
    for (final chart in incoming) {
      final file = _fileOf(chart.id);
      if (file.existsSync()) {
        try {
          final existing = Chart.fromJson(
            (jsonDecode(file.readAsStringSync()) as Map)
                .cast<String, Object?>(),
          );
          if (!chart.updatedAt.isAfter(existing.updatedAt)) continue;
        } on Exception {
          // 既存が壊れていれば取り込みで上書き
        }
      }
      file.writeAsStringSync(jsonEncode(chart.toJson()));
      imported++;
    }
    if (imported > 0) _bump();
    return imported;
  }
}

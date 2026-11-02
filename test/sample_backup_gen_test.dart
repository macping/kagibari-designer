/// 宣伝素材用サンプルデータ生成（store/assets/src/sample-backup.json）。
/// 実機截图の前に backup 取り込みで3作品を仕込む——REGEN.md の手順素材。
/// 界面が変わっても作り直し不要（データはモデル準拠の実バックアップ形式）。
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kagibari_designer/features/charts/data/chart_repository.dart';
import 'package:kagibari_designer/features/charts/domain/chart.dart';

Chart _bearHead() {
  final chart = Chart(
    id: 'sample-bear',
    title: 'くまのあたま',
    mode: ChartMode.round,
    rounds: [
      RoundSpec(stitchCount: 6),
      RoundSpec(stitchCount: 12),
      RoundSpec(stitchCount: 18),
      RoundSpec(stitchCount: 24),
      RoundSpec(stitchCount: 30),
      RoundSpec(stitchCount: 36),
    ],
  );
  for (var i = 0; i < 6; i++) {
    chart.rounds[0].cells[i] = 'koma';
  }
  for (var i = 0; i < 12; i++) {
    chart.rounds[1].cells[i] = i.isEven ? 'koma2in' : 'koma';
  }
  for (var i = 0; i < 18; i++) {
    chart.rounds[2].cells[i] = i % 3 == 2 ? 'koma2in' : 'koma';
  }
  for (var i = 0; i < 24; i++) {
    chart.rounds[3].cells[i] = i % 4 == 3 ? 'koma2in' : 'koma';
  }
  for (var i = 0; i < 30; i++) {
    chart.rounds[4].cells[i] = i % 5 == 4 ? 'koma2in' : 'koma';
  }
  for (var i = 0; i < 36; i++) {
    chart.rounds[5].cells[i] = 'koma';
  }
  return chart;
}

Chart _flowerMotif() {
  final chart = Chart(
    id: 'sample-flower',
    title: 'おはなモチーフ',
    mode: ChartMode.round,
    rounds: [
      RoundSpec(stitchCount: 6),
      RoundSpec(stitchCount: 12),
      RoundSpec(stitchCount: 12),
    ],
  );
  for (var i = 0; i < 6; i++) {
    chart.rounds[0].cells[i] = 'kusari';
  }
  for (var i = 0; i < 12; i++) {
    chart.rounds[1].cells[i] = i.isEven ? 'naga' : 'kusari';
  }
  for (var i = 0; i < 12; i++) {
    chart.rounds[2].cells[i] = i.isEven ? 'naga5in' : 'hikinuki';
  }
  return chart;
}

Chart _heartCoaster() {
  final chart = Chart.newGrid(id: 'sample-heart', title: 'ハートのコースター');
  const rows = 12;
  const cols = 12;
  chart.gridRows = rows;
  chart.gridCols = cols;
  // 外周=長編み
  for (var r = 0; r < rows; r++) {
    for (var c = 0; c < cols; c++) {
      if (r == 0 || c == 0 || r == rows - 1 || c == cols - 1) {
        chart.gridCells[Chart.gridKey(r, c)] = 'naga';
      }
    }
  }
  // ハート（filet: 塗りマス=kusari）
  const heart = [
    [2, 3], [2, 8],
    [3, 2], [3, 4], [3, 7], [3, 9],
    [4, 2], [4, 5], [4, 6], [4, 9],
    [5, 2], [5, 9],
    [6, 3], [6, 8],
    [7, 4], [7, 7],
    [8, 5], [8, 6],
  ];
  for (final cell in heart) {
    chart.gridCells[Chart.gridKey(rows - 1 - cell[0], cell[1])] = 'kusari';
  }
  return chart;
}

void main() {
  test('sample-backup.json を生成する', () async {
    final dir = Directory.systemTemp.createTempSync('kagibari_sample');
    addTearDown(() => dir.deleteSync(recursive: true));
    final repository = ChartRepository(dir);
    final payload = repository.encodeBackup([
      _bearHead(),
      _heartCoaster(),
      _flowerMotif(),
    ]);
    final out = File('store/assets/src/sample-backup.json')
      ..createSync(recursive: true)
      ..writeAsStringSync(payload);
    expect(out.lengthSync(), greaterThan(500));
  });
}

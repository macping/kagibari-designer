/// 書き出しパイプラインの実レンダリング検証。
/// build/preview/ に PNG を吐く——吸着幾何・切線回転・透かしの目視確認用
/// （エミュレータに乗せる前のオフライン検収）。
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kagibari_designer/core/export/chart_exporter.dart';
import 'package:kagibari_designer/features/charts/domain/chart.dart';
import 'package:kagibari_designer/features/charts/presentation/chart_canvas.dart';

Chart _sampleRound() {
  final chart = Chart(
    id: 'preview-round',
    title: 'あみぐるみサンプル',
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
  // 1段目: 細編み6目
  for (var i = 0; i < 6; i++) {
    chart.rounds[0].cells[i] = 'koma';
  }
  // 2段目: 全目編み入れ（6→12 の定番増し目）
  for (var i = 0; i < 12; i++) {
    chart.rounds[1].cells[i] = i.isEven ? 'koma2in' : 'koma';
  }
  // 3段目: 2目ごとに増し目
  for (var i = 0; i < 18; i++) {
    chart.rounds[2].cells[i] = i % 3 == 2 ? 'koma2in' : 'koma';
  }
  // 4段目: 長編み
  for (var i = 0; i < 24; i++) {
    chart.rounds[3].cells[i] = i % 4 == 3 ? 'naga2in' : 'naga';
  }
  // 5段目: 玉編みと鎖の模様
  for (var i = 0; i < 30; i++) {
    chart.rounds[4].cells[i] = i.isEven ? 'tama' : 'kusari';
  }
  // 6段目: シェルとピコット
  for (var i = 0; i < 36; i++) {
    if (i % 6 == 0) chart.rounds[5].cells[i] = 'naga5in';
    if (i % 6 == 3) chart.rounds[5].cells[i] = 'picot';
  }
  return chart;
}

Chart _sampleGrid() {
  final chart = Chart.newGrid(id: 'preview-grid', title: '方眼サンプル');
  // 外周=長編み、内部に鎖のハート柄もどき
  for (var row = 0; row < chart.gridRows; row++) {
    for (var col = 0; col < chart.gridCols; col++) {
      final border = row == 0 ||
          col == 0 ||
          row == chart.gridRows - 1 ||
          col == chart.gridCols - 1;
      if (border) {
        chart.gridCells[Chart.gridKey(row, col)] = 'naga';
      } else if ((row + col) % 3 == 0) {
        chart.gridCells[Chart.gridKey(row, col)] = 'kusari';
      }
    }
  }
  return chart;
}

void main() {
  testWidgets('円編み/方眼の実レンダリングが PNG に出る', (tester) async {
    await tester.runAsync(() async {
      await SymbolPictureCache.warmUp();
      expect(SymbolPictureCache.isReady, isTrue);

      final dir = Directory('build/preview')..createSync(recursive: true);

      final roundPng = await ChartExporter.renderPng(
        _sampleRound(),
        pixelWidth: 1200,
        watermark: true,
      );
      expect(roundPng.length, greaterThan(10000));
      File('${dir.path}/round.png').writeAsBytesSync(roundPng);

      final gridPng = await ChartExporter.renderPng(
        _sampleGrid(),
        pixelWidth: 1200,
        watermark: false,
      );
      expect(gridPng.length, greaterThan(10000));
      File('${dir.path}/grid.png').writeAsBytesSync(gridPng);
    });
  });
}

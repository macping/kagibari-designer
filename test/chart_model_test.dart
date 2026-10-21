/// 編み図モデル・コマンド・幾何・永続化のユニットテスト（W1 検収の論理面）。
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kagibari_designer/features/charts/data/chart_repository.dart';
import 'package:kagibari_designer/features/charts/domain/chart.dart';
import 'package:kagibari_designer/features/charts/domain/chart_commands.dart';
import 'package:kagibari_designer/features/charts/presentation/chart_canvas.dart';

void main() {
  group('コマンド/Undo', () {
    test('配置→取消→やり直しで完全往復する', () {
      final chart = Chart.newRound(id: 't', title: 't');
      final stack = UndoStack();

      stack.execute(chart, PlaceStitchCommand(0, 2, 'koma'));
      expect(chart.rounds[0].cells[2], 'koma');

      stack.execute(chart, PlaceStitchCommand(0, 2, 'naga')); // 置き換え
      expect(chart.rounds[0].cells[2], 'naga');

      stack.undo(chart);
      expect(chart.rounds[0].cells[2], 'koma');
      stack.undo(chart);
      expect(chart.rounds[0].cells.containsKey(2), isFalse);

      stack.redo(chart);
      stack.redo(chart);
      expect(chart.rounds[0].cells[2], 'naga');
    });

    test('目数変更: はみ出た記号は除去され Undo で戻る', () {
      final chart = Chart.newRound(id: 't', title: 't');
      final stack = UndoStack();
      chart.rounds[1].cells.addAll({0: 'koma', 11: 'koma2in'});

      stack.execute(chart, SetStitchCountCommand(1, 8));
      expect(chart.rounds[1].stitchCount, 8);
      expect(chart.rounds[1].cells.containsKey(11), isFalse);
      expect(chart.rounds[1].cells[0], 'koma');

      stack.undo(chart);
      expect(chart.rounds[1].stitchCount, 12);
      expect(chart.rounds[1].cells[11], 'koma2in');
    });

    test('Undo 上限100手でも落ちない（要件≥50）', () {
      final chart = Chart.newRound(id: 't', title: 't');
      final stack = UndoStack();
      for (var i = 0; i < 120; i++) {
        stack.execute(chart, PlaceStitchCommand(0, i % 6, 'koma'));
      }
      var undone = 0;
      while (stack.canUndo) {
        stack.undo(chart);
        undone++;
      }
      expect(undone, 100);
    });

    test('方眼: 縮小ではみ出しセルが消え Undo で戻る', () {
      final chart = Chart.newGrid(id: 't', title: 't');
      final stack = UndoStack();
      stack.execute(chart, PlaceGridCommand(11, 11, 'naga'));
      stack.execute(chart, ResizeGridCommand(8, 8));
      expect(chart.gridCells.containsKey('11:11'), isFalse);
      stack.undo(chart);
      expect(chart.gridCells['11:11'], 'naga');
    });
  });

  group('幾何（吸着の正当性）', () {
    test('円編み: 全スロット中心→hitTest が同じ (段,目) に戻る', () {
      final chart = Chart.newRound(id: 't', title: 't');
      chart.rounds.add(RoundSpec(stitchCount: 36));
      final geometry = RoundChartGeometry(chart);
      for (var round = 0; round < chart.rounds.length; round++) {
        final count = chart.rounds[round].stitchCount;
        for (var index = 0; index < count; index++) {
          final hit = geometry.hitTest(geometry.cellCenter(round, index));
          expect(hit, (round, index),
              reason: 'round=$round index=$index で吸着がずれた');
        }
      }
    });

    test('円編み: 中心やグリッド外は null', () {
      final chart = Chart.newRound(id: 't', title: 't');
      final geometry = RoundChartGeometry(chart);
      expect(geometry.hitTest(geometry.center), isNull);
      expect(geometry.hitTest(const Offset(-1000, -1000)), isNull);
    });

    test('方眼: 全セル中心→hitTest 往復', () {
      final chart = Chart.newGrid(id: 't', title: 't');
      final geometry = GridChartGeometry(chart);
      for (var row = 0; row < chart.gridRows; row++) {
        for (var col = 0; col < chart.gridCols; col++) {
          expect(
            geometry.hitTest(geometry.cellRect(row, col).center),
            (row, col),
          );
        }
      }
    });
  });

  group('永続化/バックアップ', () {
    test('保存→読込の round trip', () async {
      final dir = Directory.systemTemp.createTempSync('kagibari_test');
      addTearDown(() => dir.deleteSync(recursive: true));
      final repository = ChartRepository(dir);

      final chart = Chart.newRound(id: 'abc', title: 'くまの頭');
      chart.rounds[0].cells[0] = 'koma';
      await repository.save(chart);

      final loaded = await repository.loadAll();
      expect(loaded, hasLength(1));
      expect(loaded.first.title, 'くまの頭');
      expect(loaded.first.rounds[0].cells[0], 'koma');
      expect(loaded.first.mode, ChartMode.round);

      await repository.delete('abc');
      expect(await repository.loadAll(), isEmpty);
    });

    test('バックアップ encode→import（新しい方が勝つ）', () async {
      final dirA = Directory.systemTemp.createTempSync('kagibari_a');
      final dirB = Directory.systemTemp.createTempSync('kagibari_b');
      addTearDown(() => dirA.deleteSync(recursive: true));
      addTearDown(() => dirB.deleteSync(recursive: true));
      final repoA = ChartRepository(dirA);
      final repoB = ChartRepository(dirB);

      final chart1 = Chart.newRound(id: 'c1', title: '輪のコースター');
      final chart2 = Chart.newGrid(id: 'c2', title: '方眼ブランケット');
      await repoA.save(chart1);
      await repoA.save(chart2);

      final payload = repoA.encodeBackup(await repoA.loadAll());
      final imported = await repoB.importBackup(payload);
      expect(imported, 2);
      expect(await repoB.loadAll(), hasLength(2));

      // 同一 id の古いデータは上書きされない
      final importedAgain = await repoB.importBackup(payload);
      expect(importedAgain, 0);
    });

    test('壊れたバックアップは FormatException', () {
      expect(
        () => ChartRepository.decodeBackup('{"nope": true}'),
        throwsFormatException,
      );
    });
  });
}

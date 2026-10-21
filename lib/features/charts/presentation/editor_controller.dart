/// エディタ状態: 選択記号・消しゴム・Undo/Redo・自動保存（500msデバウンス）。
library;

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/chart_repository.dart';
import '../domain/chart.dart';
import '../domain/chart_commands.dart';

class ChartEditorController extends ChangeNotifier {
  ChartEditorController({required this.chart, required this.repository});

  final Chart chart;
  final ChartRepository repository;
  final undoStack = UndoStack();

  String selectedSymbolId = 'koma';
  bool eraser = false;
  Timer? _saveTimer;
  bool _disposed = false;

  void selectSymbol(String symbolId) {
    selectedSymbolId = symbolId;
    eraser = false;
    notifyListeners();
  }

  void toggleEraser() {
    eraser = !eraser;
    notifyListeners();
  }

  void execute(ChartCommand command) {
    undoStack.execute(chart, command);
    _afterEdit();
  }

  void undo() {
    if (!undoStack.canUndo) return;
    undoStack.undo(chart);
    _afterEdit();
  }

  void redo() {
    if (!undoStack.canRedo) return;
    undoStack.redo(chart);
    _afterEdit();
  }

  /// 円編み: スロットtaps/dropの共通入口。消しゴム時は削除、それ以外は
  /// 選択記号を配置（既存は置き換え）。
  void actOnRoundCell(int round, int index, {String? symbolId}) {
    final spec = chart.rounds[round];
    if (eraser && symbolId == null) {
      if (spec.cells.containsKey(index)) {
        execute(RemoveStitchCommand(round, index));
      }
      return;
    }
    execute(PlaceStitchCommand(round, index, symbolId ?? selectedSymbolId));
  }

  void actOnGridCell(int row, int col, {String? symbolId}) {
    if (eraser && symbolId == null) {
      if (chart.gridCells.containsKey(Chart.gridKey(row, col))) {
        execute(RemoveGridCommand(row, col));
      }
      return;
    }
    execute(PlaceGridCommand(row, col, symbolId ?? selectedSymbolId));
  }

  void removeRoundCell(int round, int index) {
    if (chart.rounds[round].cells.containsKey(index)) {
      execute(RemoveStitchCommand(round, index));
    }
  }

  void removeGridCell(int row, int col) {
    if (chart.gridCells.containsKey(Chart.gridKey(row, col))) {
      execute(RemoveGridCommand(row, col));
    }
  }

  void rename(String title) {
    chart.title = title;
    _afterEdit();
  }

  void _afterEdit() {
    notifyListeners();
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 500), () {
      if (!_disposed) unawaited(repository.save(chart));
    });
  }

  /// 画面を離れる前の確定保存。
  Future<void> flush() async {
    _saveTimer?.cancel();
    await repository.save(chart);
  }

  @override
  void dispose() {
    _disposed = true;
    _saveTimer?.cancel();
    super.dispose();
  }
}

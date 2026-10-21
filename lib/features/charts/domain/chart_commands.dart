/// 編集コマンド（コマンドパターン）と Undo スタック（上限100手・要件≥50）。
/// 各コマンドは apply 前の状態を自分で記録し、revert で完全復元する。
library;

import 'chart.dart';

abstract class ChartCommand {
  void apply(Chart chart);
  void revert(Chart chart);
}

/// 円編み: 記号を置く／置き換える。
class PlaceStitchCommand implements ChartCommand {
  PlaceStitchCommand(this.round, this.index, this.symbolId);

  final int round;
  final int index;
  final String symbolId;
  String? _previous;

  @override
  void apply(Chart chart) {
    final cells = chart.rounds[round].cells;
    _previous = cells[index];
    cells[index] = symbolId;
  }

  @override
  void revert(Chart chart) {
    final cells = chart.rounds[round].cells;
    if (_previous == null) {
      cells.remove(index);
    } else {
      cells[index] = _previous!;
    }
  }
}

/// 円編み: 記号を消す。
class RemoveStitchCommand implements ChartCommand {
  RemoveStitchCommand(this.round, this.index);

  final int round;
  final int index;
  String? _previous;

  @override
  void apply(Chart chart) {
    _previous = chart.rounds[round].cells.remove(index);
  }

  @override
  void revert(Chart chart) {
    if (_previous != null) {
      chart.rounds[round].cells[index] = _previous!;
    }
  }
}

/// 円編み: 段の目数を変える。位置は (index/目数) から導出されるので
/// 既存記号は自動で再分布する。新目数からはみ出た記号は取り除く（Undo可）。
class SetStitchCountCommand implements ChartCommand {
  SetStitchCountCommand(this.round, this.newCount);

  final int round;
  final int newCount;
  int _previousCount = 0;
  final Map<int, String> _removed = {};

  @override
  void apply(Chart chart) {
    final spec = chart.rounds[round];
    _previousCount = spec.stitchCount;
    _removed.clear();
    spec.cells.removeWhere((index, symbolId) {
      if (index >= newCount) {
        _removed[index] = symbolId;
        return true;
      }
      return false;
    });
    spec.stitchCount = newCount;
  }

  @override
  void revert(Chart chart) {
    final spec = chart.rounds[round];
    spec.stitchCount = _previousCount;
    spec.cells.addAll(_removed);
  }
}

/// 円編み: 段を末尾に追加。
class AddRoundCommand implements ChartCommand {
  AddRoundCommand(this.stitchCount);

  final int stitchCount;

  @override
  void apply(Chart chart) {
    chart.rounds.add(RoundSpec(stitchCount: stitchCount));
  }

  @override
  void revert(Chart chart) {
    chart.rounds.removeLast();
  }
}

/// 円編み: 最終段を削除。
class RemoveLastRoundCommand implements ChartCommand {
  RoundSpec? _removed;

  @override
  void apply(Chart chart) {
    _removed = chart.rounds.removeLast();
  }

  @override
  void revert(Chart chart) {
    if (_removed != null) chart.rounds.add(_removed!);
  }
}

/// 方眼: 記号を置く／置き換える。
class PlaceGridCommand implements ChartCommand {
  PlaceGridCommand(this.row, this.col, this.symbolId);

  final int row;
  final int col;
  final String symbolId;
  String? _previous;

  @override
  void apply(Chart chart) {
    final key = Chart.gridKey(row, col);
    _previous = chart.gridCells[key];
    chart.gridCells[key] = symbolId;
  }

  @override
  void revert(Chart chart) {
    final key = Chart.gridKey(row, col);
    if (_previous == null) {
      chart.gridCells.remove(key);
    } else {
      chart.gridCells[key] = _previous!;
    }
  }
}

/// 方眼: 記号を消す。
class RemoveGridCommand implements ChartCommand {
  RemoveGridCommand(this.row, this.col);

  final int row;
  final int col;
  String? _previous;

  @override
  void apply(Chart chart) {
    _previous = chart.gridCells.remove(Chart.gridKey(row, col));
  }

  @override
  void revert(Chart chart) {
    if (_previous != null) {
      chart.gridCells[Chart.gridKey(row, col)] = _previous!;
    }
  }
}

/// 方眼: サイズ変更。縮小ではみ出す記号は取り除く（Undo可）。
class ResizeGridCommand implements ChartCommand {
  ResizeGridCommand(this.newRows, this.newCols);

  final int newRows;
  final int newCols;
  int _previousRows = 0;
  int _previousCols = 0;
  final Map<String, String> _removed = {};

  @override
  void apply(Chart chart) {
    _previousRows = chart.gridRows;
    _previousCols = chart.gridCols;
    _removed.clear();
    chart.gridCells.removeWhere((key, symbolId) {
      final parts = key.split(':');
      final row = int.tryParse(parts[0]) ?? 0;
      final col = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
      if (row >= newRows || col >= newCols) {
        _removed[key] = symbolId;
        return true;
      }
      return false;
    });
    chart.gridRows = newRows;
    chart.gridCols = newCols;
  }

  @override
  void revert(Chart chart) {
    chart.gridRows = _previousRows;
    chart.gridCols = _previousCols;
    chart.gridCells.addAll(_removed);
  }
}

/// Undo/Redo スタック。上限を超えた最古の手は切り捨てる。
class UndoStack {
  UndoStack({this.capacity = 100});

  final int capacity;
  final List<ChartCommand> _undo = [];
  final List<ChartCommand> _redo = [];

  bool get canUndo => _undo.isNotEmpty;
  bool get canRedo => _redo.isNotEmpty;

  void execute(Chart chart, ChartCommand command) {
    command.apply(chart);
    _undo.add(command);
    if (_undo.length > capacity) _undo.removeAt(0);
    _redo.clear();
  }

  void undo(Chart chart) {
    if (_undo.isEmpty) return;
    final command = _undo.removeLast();
    command.revert(chart);
    _redo.add(command);
  }

  void redo(Chart chart) {
    if (_redo.isEmpty) return;
    final command = _redo.removeLast();
    command.apply(chart);
    _undo.add(command);
  }

  void clear() {
    _undo.clear();
    _redo.clear();
  }
}

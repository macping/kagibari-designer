/// 編み図データモデル。
/// 記号は (段, 目) の論理座標で持つ——ピクセル座標は一切保存しない。
/// 目数変更・ズームでの再配置は描画時に自動で導出される（W1 検収の核）。
library;

import 'dart:math' as math;

enum ChartMode { round, grid }

/// 円編み1段分: 目数と、目 index → 記号id。
class RoundSpec {
  RoundSpec({required this.stitchCount, Map<int, String>? cells})
      : cells = cells ?? {};

  int stitchCount;

  /// 目 index（0 = 真上から時計回り）→ 記号id。
  final Map<int, String> cells;

  RoundSpec copy() => RoundSpec(stitchCount: stitchCount, cells: {...cells});

  Map<String, Object?> toJson() => {
        'stitchCount': stitchCount,
        'cells': {for (final e in cells.entries) '${e.key}': e.value},
      };

  static RoundSpec fromJson(Map<String, Object?> json) {
    final rawCells = (json['cells'] as Map?) ?? const {};
    return RoundSpec(
      stitchCount: (json['stitchCount'] as num?)?.toInt() ?? 6,
      cells: {
        for (final e in rawCells.entries)
          if (int.tryParse('${e.key}') != null)
            int.parse('${e.key}'): '${e.value}',
      },
    );
  }
}

class Chart {
  Chart({
    required this.id,
    required this.title,
    required this.mode,
    List<RoundSpec>? rounds,
    this.gridRows = 12,
    this.gridCols = 12,
    Map<String, String>? gridCells,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : rounds = rounds ?? [],
        gridCells = gridCells ?? {},
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// 新規円編み: あみぐるみの定番 6→12→18→24 の4段から始める。
  factory Chart.newRound({required String id, required String title}) => Chart(
        id: id,
        title: title,
        mode: ChartMode.round,
        rounds: [
          RoundSpec(stitchCount: 6),
          RoundSpec(stitchCount: 12),
          RoundSpec(stitchCount: 18),
          RoundSpec(stitchCount: 24),
        ],
      );

  factory Chart.newGrid({required String id, required String title}) =>
      Chart(id: id, title: title, mode: ChartMode.grid);

  final String id;
  String title;
  final ChartMode mode;

  /// mode == round のとき使用。
  final List<RoundSpec> rounds;

  /// mode == grid のとき使用。
  int gridRows;
  int gridCols;

  /// 'row:col' → 記号id（row 0 = 最下段=1段目、filet 流儀）。
  final Map<String, String> gridCells;

  final DateTime createdAt;
  DateTime updatedAt;

  static String gridKey(int row, int col) => '$row:$col';

  int get placedCount => mode == ChartMode.round
      ? rounds.fold(0, (sum, r) => sum + r.cells.length)
      : gridCells.length;

  /// 全記号を一掃した論理サイズ上限の目安（描画・書き出しの守卫用）。
  int get maxStitchCount => mode == ChartMode.round
      ? rounds.fold(6, (m, r) => math.max(m, r.stitchCount))
      : math.max(gridRows, gridCols);

  Chart copy() => Chart(
        id: id,
        title: title,
        mode: mode,
        rounds: [for (final r in rounds) r.copy()],
        gridRows: gridRows,
        gridCols: gridCols,
        gridCells: {...gridCells},
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  Map<String, Object?> toJson() => {
        'version': 1,
        'id': id,
        'title': title,
        'mode': mode.name,
        'rounds': [for (final r in rounds) r.toJson()],
        'gridRows': gridRows,
        'gridCols': gridCols,
        'gridCells': gridCells,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  static Chart fromJson(Map<String, Object?> json) {
    final rawGridCells = (json['gridCells'] as Map?) ?? const {};
    return Chart(
      id: '${json['id']}',
      title: '${json['title'] ?? ''}',
      mode: json['mode'] == 'grid' ? ChartMode.grid : ChartMode.round,
      rounds: [
        for (final r in (json['rounds'] as List?) ?? const [])
          if (r is Map) RoundSpec.fromJson(r.cast<String, Object?>()),
      ],
      gridRows: (json['gridRows'] as num?)?.toInt() ?? 12,
      gridCols: (json['gridCols'] as num?)?.toInt() ?? 12,
      gridCells: {
        for (final e in rawGridCells.entries) '${e.key}': '${e.value}',
      },
      createdAt:
          DateTime.tryParse('${json['createdAt']}') ?? DateTime.now(),
      updatedAt:
          DateTime.tryParse('${json['updatedAt']}') ?? DateTime.now(),
    );
  }
}

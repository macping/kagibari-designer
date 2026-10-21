/// 編み図キャンバス描画（領域コンポーネント＝本アプリの視覚的核心）。
///
/// 性能設計（W1 検収: 中端末60fps / 20段×最密で落ちない）:
/// - SVG 記号は起動時に ui.Picture 化して全キャッシュ（1記号1回だけパース）
/// - 記号は (段,目) 論理座標から毎フレーム導出——ピクセル座標の保存なし
/// - 再描画はモデル変更時のみ（CustomPainter.repaint に ChangeNotifier）
/// - ズーム/パンは InteractiveViewer の行列変換（painter は再実行されない）
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../domain/chart.dart';
import '../domain/symbol_registry.dart';

/// 紙色（ライト/ダーク共通——編み図は常に「紙」。書き出しと見た目が一致する）。
const chartPaperColor = Color(0xFFFDFAF4);
const _inkColor = Color(0xFF1A1A1A);
const _gridLineColor = Color(0x2E5D4A3C);
const _gridLineStrong = Color(0x4D5D4A3C);
const _labelColor = Color(0x995D4A3C);
const _emptyDotColor = Color(0x335D4A3C);

/// 全記号 SVG → ui.Picture の事前キャッシュ。
abstract final class SymbolPictureCache {
  static final Map<String, PictureInfo> _pictures = {};
  static bool _ready = false;

  static bool get isReady => _ready;

  static Future<void> warmUp() async {
    if (_ready) return;
    await Future.wait([
      for (final symbol in SymbolRegistry.all)
        if (!_pictures.containsKey(symbol.id))
          vg
              .loadPicture(SvgAssetLoader(symbol.asset), null)
              .then((info) => _pictures[symbol.id] = info),
    ]);
    _ready = true;
  }

  static PictureInfo? of(String symbolId) => _pictures[symbolId];
}

/// 円編みの幾何（描画とヒットテストで共有——座標系のズレを構造的に防ぐ）。
class RoundChartGeometry {
  RoundChartGeometry(this.chart)
      : assert(chart.mode == ChartMode.round);

  final Chart chart;

  static const double innerRadius = 40;
  static const double ringGap = 46;
  static const double labelPad = 30;

  double get outerRadius => innerRadius + chart.rounds.length * ringGap;

  Size get logicalSize => Size.square((outerRadius + labelPad) * 2);

  Offset get center => logicalSize.center(Offset.zero);

  double ringInner(int round) => innerRadius + round * ringGap;

  double ringMid(int round) => innerRadius + (round + 0.5) * ringGap;

  /// 目スロット中心角。index 0 = 真上から時計回り、スロット中央に置く。
  double cellAngle(int round, int index) {
    final count = chart.rounds[round].stitchCount;
    return -math.pi / 2 + 2 * math.pi * (index + 0.5) / count;
  }

  Offset cellCenter(int round, int index) {
    final angle = cellAngle(round, index);
    final r = ringMid(round);
    return center + Offset(math.cos(angle) * r, math.sin(angle) * r);
  }

  /// 記号の描画サイズ（スロット弧長とリング幅の小さい方に収める）。
  double cellSize(int round) {
    final count = chart.rounds[round].stitchCount;
    final arc = 2 * math.pi * ringMid(round) / count;
    return math.min(ringGap * 0.86, arc * 0.92);
  }

  /// 論理座標 → (段, 目)。グリッド外は null。吸着は常に成立する
  /// （最寄りスロットへ丸める——手動微調整は存在しない）。
  (int round, int index)? hitTest(Offset point) {
    final d = point - center;
    final r = d.distance;
    final round = ((r - innerRadius) / ringGap).floor();
    if (round < 0 || round >= chart.rounds.length) return null;
    final count = chart.rounds[round].stitchCount;
    var angle = math.atan2(d.dy, d.dx) + math.pi / 2; // 真上=0
    if (angle < 0) angle += 2 * math.pi;
    final index = (angle / (2 * math.pi) * count).floor() % count;
    return (round, index);
  }
}

/// 方眼の幾何。row 0 = 最下段（filet 流儀: 下から編み上がる）。
class GridChartGeometry {
  GridChartGeometry(this.chart) : assert(chart.mode == ChartMode.grid);

  final Chart chart;

  static const double cell = 46;
  static const double margin = 14;
  static const double labelPad = 28;

  Size get logicalSize => Size(
        margin + chart.gridCols * cell + labelPad,
        margin + chart.gridRows * cell + labelPad,
      );

  Rect cellRect(int row, int col) => Rect.fromLTWH(
        margin + col * cell,
        margin + (chart.gridRows - 1 - row) * cell,
        cell,
        cell,
      );

  (int row, int col)? hitTest(Offset point) {
    final col = ((point.dx - margin) / cell).floor();
    final rowFromTop = ((point.dy - margin) / cell).floor();
    final row = chart.gridRows - 1 - rowFromTop;
    if (col < 0 || col >= chart.gridCols || row < 0 || row >= chart.gridRows) {
      return null;
    }
    return (row, col);
  }
}

/// 記号 Picture を指定中心・回転・サイズで描く共通処理。
void _drawSymbol(
  Canvas canvas,
  String symbolId, {
  required Offset at,
  required double size,
  double rotation = 0,
}) {
  final info = SymbolPictureCache.of(symbolId);
  canvas.save();
  canvas.translate(at.dx, at.dy);
  if (rotation != 0) canvas.rotate(rotation);
  if (info == null) {
    // キャッシュ未到達時の目印（テスト環境・ウォームアップ前の保険）
    final paint = Paint()
      ..color = _gridLineStrong
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset.zero, size / 3, paint);
  } else {
    final scale = size / math.max(info.size.width, info.size.height);
    canvas.scale(scale);
    canvas.translate(-info.size.width / 2, -info.size.height / 2);
    canvas.drawPicture(info.picture);
  }
  canvas.restore();
}

void _paintScaledToFit(
  Canvas canvas,
  Size size,
  Size logical,
  void Function(Canvas) body, {
  required bool paintPaper,
}) {
  if (paintPaper) {
    canvas.drawRect(Offset.zero & size, Paint()..color = chartPaperColor);
  }
  final scale =
      math.min(size.width / logical.width, size.height / logical.height);
  canvas.save();
  canvas.translate(
    (size.width - logical.width * scale) / 2,
    (size.height - logical.height * scale) / 2,
  );
  canvas.scale(scale);
  body(canvas);
  canvas.restore();
}

class RoundChartPainter extends CustomPainter {
  RoundChartPainter(this.chart, {super.repaint, this.paintPaper = true});

  final Chart chart;
  final bool paintPaper;

  /// 構築時点のキャッシュ就緒状態。shouldRepaint で比較しないと、
  /// warmUp 完了前に描いた占位円が完了後も残り続ける（真機で実測）。
  final bool cacheReady = SymbolPictureCache.isReady;

  @override
  void paint(Canvas canvas, Size size) {
    final geometry = RoundChartGeometry(chart);
    _paintScaledToFit(canvas, size, geometry.logicalSize, (canvas) {
      _paintChart(canvas, geometry);
    }, paintPaper: paintPaper);
  }

  void _paintChart(Canvas canvas, RoundChartGeometry geometry) {
    final center = geometry.center;
    final ringPaint = Paint()
      ..color = _gridLineStrong
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final tickPaint = Paint()
      ..color = _gridLineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final dotPaint = Paint()..color = _emptyDotColor;

    // 輪の作り目（中心の小円）
    canvas.drawCircle(
      center,
      14,
      Paint()
        ..color = _inkColor.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // リング円
    for (var i = 0; i <= chart.rounds.length; i++) {
      canvas.drawCircle(center, geometry.ringInner(i), ringPaint);
    }

    for (var round = 0; round < chart.rounds.length; round++) {
      final spec = chart.rounds[round];
      final rIn = geometry.ringInner(round);
      final rOut = geometry.ringInner(round + 1);

      // スロット境界の目盛線
      for (var k = 0; k < spec.stitchCount; k++) {
        final angle = -math.pi / 2 + 2 * math.pi * k / spec.stitchCount;
        final dir = Offset(math.cos(angle), math.sin(angle));
        canvas.drawLine(center + dir * rIn, center + dir * rOut, tickPaint);
      }

      // 空きスロットの中心ドット + 配置済み記号
      final symbolSize = geometry.cellSize(round);
      for (var index = 0; index < spec.stitchCount; index++) {
        final at = geometry.cellCenter(round, index);
        final symbolId = spec.cells[index];
        if (symbolId == null) {
          canvas.drawCircle(at, 1.6, dotPaint);
        } else {
          _drawSymbol(
            canvas,
            symbolId,
            at: at,
            size: symbolSize,
            rotation: geometry.cellAngle(round, index) + math.pi / 2,
          );
        }
      }

      // 段番号: 編み始め位置＝スロット境界線（真上）に紙色チップで重ねる。
      // スロット中心は +0.5 ずれているので、境界線上に記号は来ない。
      _paintLabel(
        canvas,
        '${round + 1}',
        Offset(center.dx, center.dy - geometry.ringMid(round)),
      );
    }
  }

  void _paintLabel(Canvas canvas, String text, Offset at) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 11, color: _labelColor),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final topLeft = at - Offset(painter.width / 2, painter.height / 2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        (topLeft & painter.size).inflate(2.5),
        const Radius.circular(4),
      ),
      Paint()..color = chartPaperColor,
    );
    painter.paint(canvas, topLeft);
  }

  @override
  bool shouldRepaint(RoundChartPainter oldDelegate) =>
      oldDelegate.chart != chart ||
      oldDelegate.paintPaper != paintPaper ||
      oldDelegate.cacheReady != cacheReady;
}

class GridChartPainter extends CustomPainter {
  GridChartPainter(this.chart, {super.repaint, this.paintPaper = true});

  final Chart chart;
  final bool paintPaper;

  /// RoundChartPainter.cacheReady と同旨。
  final bool cacheReady = SymbolPictureCache.isReady;

  @override
  void paint(Canvas canvas, Size size) {
    final geometry = GridChartGeometry(chart);
    _paintScaledToFit(canvas, size, geometry.logicalSize, (canvas) {
      _paintChart(canvas, geometry);
    }, paintPaper: paintPaper);
  }

  void _paintChart(Canvas canvas, GridChartGeometry geometry) {
    const cell = GridChartGeometry.cell;
    const margin = GridChartGeometry.margin;
    final rows = chart.gridRows;
    final cols = chart.gridCols;
    final width = cols * cell;
    final height = rows * cell;

    final linePaint = Paint()
      ..color = _gridLineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final strongPaint = Paint()
      ..color = _gridLineStrong
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    for (var c = 0; c <= cols; c++) {
      final x = margin + c * cell;
      canvas.drawLine(
        Offset(x, margin),
        Offset(x, margin + height),
        c % 5 == 0 ? strongPaint : linePaint,
      );
    }
    for (var r = 0; r <= rows; r++) {
      final y = margin + r * cell;
      canvas.drawLine(
        Offset(margin, y),
        Offset(margin + width, y),
        (rows - r) % 5 == 0 ? strongPaint : linePaint,
      );
    }

    for (final entry in chart.gridCells.entries) {
      final parts = entry.key.split(':');
      final row = int.tryParse(parts[0]) ?? 0;
      final col = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
      if (row >= rows || col >= cols) continue;
      final rect = geometry.cellRect(row, col);
      _drawSymbol(canvas, entry.value, at: rect.center, size: cell * 0.8);
    }

    // 行番号（右・下から1始まり）と列番号（下・右から1始まり、filet 流儀）
    final labelEvery = rows > 20 || cols > 20 ? 5 : 1;
    for (var row = 0; row < rows; row++) {
      final n = row + 1;
      if (n != 1 && n % labelEvery != 0) continue;
      final rect = geometry.cellRect(row, cols - 1);
      _paintLabel(canvas, '$n', Offset(margin + width + 12, rect.center.dy));
    }
    for (var col = 0; col < cols; col++) {
      final n = cols - col;
      if (n != 1 && n % labelEvery != 0) continue;
      final rect = geometry.cellRect(0, col);
      _paintLabel(canvas, '$n', Offset(rect.center.dx, margin + height + 12));
    }
  }

  void _paintLabel(Canvas canvas, String text, Offset at) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 11, color: _labelColor),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, at - Offset(painter.width / 2, painter.height / 2));
  }

  @override
  bool shouldRepaint(GridChartPainter oldDelegate) =>
      oldDelegate.chart != chart ||
      oldDelegate.paintPaper != paintPaper ||
      oldDelegate.cacheReady != cacheReady;
}

/// モードに応じた painter を返す（サムネイル・書き出しで共用）。
CustomPainter painterFor(Chart chart, {Listenable? repaint, bool paintPaper = true}) =>
    chart.mode == ChartMode.round
        ? RoundChartPainter(chart, repaint: repaint, paintPaper: paintPaper)
        : GridChartPainter(chart, repaint: repaint, paintPaper: paintPaper);

/// 一覧カード用サムネイル。
class ChartThumbnail extends StatelessWidget {
  const ChartThumbnail(this.chart, {super.key});

  final Chart chart;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: painterFor(chart), child: const SizedBox.expand());
  }
}

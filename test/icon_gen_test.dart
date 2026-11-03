/// ランチャーアイコン生成（領域母題=放射網格の微型編み図、全自作描画）。
/// assets/icon/ に PNG を吐き、flutter_launcher_icons がそれを各密度へ展開する。
///
/// v2（2026-11-01 矩阵対照目検の結論）: 初版の「深緑底×クリーム同心円」は
/// schiessbuch（射撃の的紋）と母題・配色が衝突 → 明暗反転で再設計。
/// 紙色底 × teal 墨線網格 × 陶土橙の増し目V（direction.md の accent）。
library;

import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _teal = Color(0xFF00695C);
const _tealDeep = Color(0xFF004A40);
const _paper = Color(0xFFFDFAF4);
const _paperEdge = Color(0xFFF1E8D8);
const _accent = Color(0xFFC96F4A);

/// 放射網格モチーフ（中心輪+2リング+目盛+細編み×印+増し目V印）。
/// [radius] = モチーフ外接半径。[vColor] = 増し目Vの色（既定=terracotta accent）。
void _paintMotif(Canvas canvas, Offset center, double radius, Color ink,
    {Color vColor = _accent}) {
  final ringPaint = Paint()
    ..color = ink
    ..style = PaintingStyle.stroke
    ..strokeWidth = radius * 0.085
    ..strokeCap = StrokeCap.round;
  final tickPaint = Paint()
    ..color = ink
    ..style = PaintingStyle.stroke
    ..strokeWidth = radius * 0.06
    ..strokeCap = StrokeCap.round;

  final r0 = radius * 0.16;
  final r1 = radius * 0.56;
  final r2 = radius * 1.0 - ringPaint.strokeWidth / 2;

  canvas.drawCircle(center, r0, ringPaint);
  canvas.drawCircle(center, r1, ringPaint);
  canvas.drawCircle(center, r2, ringPaint);

  // リング1-2間の目盛（12本）
  for (var k = 0; k < 12; k++) {
    final angle = -math.pi / 2 + 2 * math.pi * k / 12;
    final dir = Offset(math.cos(angle), math.sin(angle));
    canvas.drawLine(
      center + dir * (r0 + ringPaint.strokeWidth * 0.8),
      center + dir * (r1 - ringPaint.strokeWidth * 0.8),
      tickPaint,
    );
  }

  // リング2-3間: 細編み×印（7個）+ 真上だけ増し目V印（accent 焦点）
  final rm = (r1 + r2) / 2;
  final arm = radius * 0.1;
  for (var k = 0; k < 8; k++) {
    final angle = -math.pi / 2 + 2 * math.pi * k / 8;
    final at = center + Offset(math.cos(angle), math.sin(angle)) * rm;
    canvas.save();
    canvas.translate(at.dx, at.dy);
    canvas.rotate(angle + math.pi / 2);
    if (k == 0) {
      // 増し目V（あみぐるみの象徴）: accent 色・やや太く
      final vPaint = Paint()
        ..color = vColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.095
        ..strokeCap = StrokeCap.round;
      final v = arm * 1.15;
      canvas.drawLine(Offset(-v, -v), Offset.zero, vPaint);
      canvas.drawLine(Offset(v, -v), Offset.zero, vPaint);
    } else {
      final crossPaint = Paint()
        ..color = ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.075
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(-arm, -arm), Offset(arm, arm), crossPaint);
      canvas.drawLine(Offset(arm, -arm), Offset(-arm, arm), crossPaint);
    }
    canvas.restore();
  }
}

Future<void> _savePng(String path, Size size, void Function(Canvas) body) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  body(canvas);
  final image = await recorder
      .endRecording()
      .toImage(size.width.round(), size.height.round());
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  File(path).writeAsBytesSync(bytes!.buffer.asUint8List());
  image.dispose();
}

void main() {
  testWidgets('ランチャーアイコン PNG を生成する', (tester) async {
    await tester.runAsync(() async {
      Directory('assets/icon').createSync(recursive: true);
      const size = Size(1024, 1024);
      const center = Offset(512, 512);

      // フル版（レガシー/iOS）: 紙色地 + teal モチーフ（明底深線——矩阵の
      // 深底明線系（schiessbuch等）と明暗反転で区別）
      await _savePng('assets/icon/icon_full.png', size, (canvas) {
        final rect = Offset.zero & size;
        canvas.drawRect(
          rect,
          Paint()
            ..shader = const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_paper, _paperEdge],
            ).createShader(rect),
        );
        // 细い紙縁取り（白アイコン化の防止）
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect.deflate(14), const Radius.circular(180)),
          Paint()
            ..color = _tealDeep.withValues(alpha: 0.12)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 28,
        );
        _paintMotif(canvas, center, 360, _teal);
      });

      // adaptive foreground: 透過地・セーフゾーン（中央61%）内に収める
      await _savePng('assets/icon/icon_foreground.png', size, (canvas) {
        _paintMotif(canvas, center, 290, _teal);
      });

      // IAP Pro 視覚（paywall 頂部・促販素材）: launcher v1 の「深 teal 底 ×
      // cream 放射網格」構図を転用（目検済みの良構図。launcher 対照表で
      // schiessbuch と衝突したため本体では不採用になったが、アプリ内視覚は
      // 対照の対象外）。現 launcher（紙底）と明暗反転＝premium の記号性。
      // モチーフ頂部の増し目Vは terracotta（_paintMotif 内蔵の accent 焦点）。
      // 金線×深青 = premium の古典色。網格=落ち着いた金、V=明るい金で焦点。
      const gold = Color(0xFFD9A94E);
      const goldBright = Color(0xFFF2D488);
      await _savePng('assets/icon/iap_pro.png', size, (canvas) {
        final rect = Offset.zero & size;
        canvas.drawRect(
          rect,
          Paint()
            ..shader = const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF00564B), Color(0xFF02322B)],
            ).createShader(rect),
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect.deflate(14), const Radius.circular(180)),
          Paint()
            ..color = gold.withValues(alpha: 0.35)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 28,
        );
        _paintMotif(canvas, center, 360, gold, vColor: goldBright);
      });
      File('assets/icon/iap_pro.png')
          .copySync('store/assets/iap_pro_1024.png');

      expect(File('assets/icon/icon_full.png').lengthSync(), greaterThan(5000));
      expect(
        File('assets/icon/icon_foreground.png').lengthSync(),
        greaterThan(5000),
      );
      expect(File('assets/icon/iap_pro.png').lengthSync(), greaterThan(5000));
    });
  });
}

/// ランチャーアイコン生成（領域母題=放射網格の微型編み図、全自作描画）。
/// assets/icon/ に PNG を吐き、flutter_launcher_icons がそれを各密度へ展開する。
/// テストランナー上で dart:ui を使うための test 形式（CI でも再生成可能）。
library;

import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _teal = Color(0xFF00695C);
const _tealDark = Color(0xFF004A40);
const _cream = Color(0xFFFDFAF4);

/// 放射網格モチーフ（中心円+2リング+目盛+細編み×印）を描く。
/// [radius] = モチーフ外接半径。
void _paintMotif(Canvas canvas, Offset center, double radius, Color ink) {
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
  // リング2-3間: 細編みの×印（8個、スロット中央）
  final crossPaint = Paint()
    ..color = ink
    ..style = PaintingStyle.stroke
    ..strokeWidth = radius * 0.075
    ..strokeCap = StrokeCap.round;
  final rm = (r1 + r2) / 2;
  final arm = radius * 0.1;
  for (var k = 0; k < 8; k++) {
    final angle = -math.pi / 2 + 2 * math.pi * (k + 0.5) / 8;
    final at = center + Offset(math.cos(angle), math.sin(angle)) * rm;
    canvas.save();
    canvas.translate(at.dx, at.dy);
    canvas.rotate(angle + math.pi / 2);
    canvas.drawLine(Offset(-arm, -arm), Offset(arm, arm), crossPaint);
    canvas.drawLine(Offset(arm, -arm), Offset(-arm, arm), crossPaint);
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

      // フル版（レガシー/iOS）: ティール地 + クリームのモチーフ
      await _savePng('assets/icon/icon_full.png', size, (canvas) {
        final rect = Offset.zero & size;
        canvas.drawRect(
          rect,
          Paint()
            ..shader = const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_teal, _tealDark],
            ).createShader(rect),
        );
        _paintMotif(canvas, center, 360, _cream);
      });

      // adaptive foreground: 透過地・セーフゾーン（中央61%）内に収める
      await _savePng('assets/icon/icon_foreground.png', size, (canvas) {
        _paintMotif(canvas, center, 290, _cream);
      });

      expect(File('assets/icon/icon_full.png').lengthSync(), greaterThan(5000));
      expect(
        File('assets/icon/icon_foreground.png').lengthSync(),
        greaterThan(5000),
      );
    });
  });
}

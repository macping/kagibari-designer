/// 編み図の書き出し: PNG（解像度選択・無料層は透かし）/ PDF / 共有。
/// 描画はキャンバスと同じ painter を使う——画面と書き出しが必ず一致する。
library;

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../features/charts/domain/chart.dart';
import '../../features/charts/presentation/chart_canvas.dart';

abstract final class ChartExporter {
  static const freeResolution = 1024;
  static const proResolutions = [1024, 2048, 4096];

  /// 透かし文言はブランド固定（和文）——共有カードとしての導線も兼ねる。
  static const _watermarkText = '編み図デザイナー';

  static Future<Uint8List> renderPng(
    Chart chart, {
    required int pixelWidth,
    required bool watermark,
  }) async {
    final logical = chart.mode == ChartMode.round
        ? RoundChartGeometry(chart).logicalSize
        : GridChartGeometry(chart).logicalSize;
    final aspect = logical.height / logical.width;
    final width = pixelWidth.toDouble();
    final height = (width * aspect).clamp(64.0, 16384.0);
    final size = Size(width, height);

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    painterFor(chart).paint(canvas, size);

    if (watermark) {
      final painter = TextPainter(
        text: TextSpan(
          text: _watermarkText,
          style: TextStyle(
            fontSize: width * 0.028,
            color: const Color(0x66807463),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(
        canvas,
        Offset(
          size.width - painter.width - width * 0.02,
          size.height - painter.height - width * 0.015,
        ),
      );
    }

    final image = await recorder
        .endRecording()
        .toImage(width.round(), height.round());
    try {
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      return bytes!.buffer.asUint8List();
    } finally {
      image.dispose();
    }
  }

  static String _safeFileName(String title) {
    final cleaned = title.replaceAll(RegExp(r'[\\/:*?"<>|\s]+'), '_');
    return cleaned.isEmpty ? 'chart' : cleaned;
  }

  /// PNG を一時ファイル化して OS 共有シートへ（保存・SNS・他アプリ送付を兼ねる）。
  static Future<void> sharePng(
    Chart chart, {
    required int pixelWidth,
    required bool watermark,
  }) async {
    final bytes =
        await renderPng(chart, pixelWidth: pixelWidth, watermark: watermark);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${_safeFileName(chart.title)}.png');
    await file.writeAsBytes(bytes, flush: true);
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'image/png')],
      text: chart.title,
    );
  }

  /// PDF（A4・図面のみ）。和文タイトルは PDF 標準フォントに無いため
  /// 画像のみを配置し、タイトルはファイル名で持たせる。
  static Future<void> sharePdf(
    Chart chart, {
    required bool watermark,
  }) async {
    final png = await renderPng(chart, pixelWidth: 2048, watermark: watermark);
    final image = pw.MemoryImage(png);
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => pw.Center(
          child: pw.Image(image, fit: pw.BoxFit.contain),
        ),
      ),
    );
    await Printing.sharePdf(
      bytes: await doc.save(),
      filename: '${_safeFileName(chart.title)}.pdf',
    );
  }
}

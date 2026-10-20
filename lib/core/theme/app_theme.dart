/// MicroCalc Shell: アプリ共通テーマ（noyaku-dilution 由来、シードカラーのみ差替え）。
library;

import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  /// アプリのブランド色（brick 変数 seed_color）
  static const Color seedColor = Color(0xFF00695C);

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        isDense: true,
      ),
      // 現場・手袋でも押せるよう、タップ領域は詰めない
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }
}

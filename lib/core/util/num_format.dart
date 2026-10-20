/// 入力値の表示用フォーマット。
library;

/// 整数値なら小数点を付けずに返す（100.0 → "100"、12.5 → "12.5"）。
/// 履歴サマリーやCSVで「100.0V」のような機械的表記を避ける。
String fmtNum(double v) =>
    v == v.roundToDouble() ? v.round().toString() : v.toString();

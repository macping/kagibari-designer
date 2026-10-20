/// 計算結果の健全性ガード。
///
/// 入力が個々には有限でも、乗算で Infinity/NaN に溢れることがある
/// （例: こう長1e300 × 電流1e300）。溢れた値を UI にそのまま
/// 「Infinity V」と表示しないための最終防波堤。
/// 各画面は ArgumentError を捕捉して「入力値を確認してください」を出す。
library;

/// 全計算機能の正当な結果は大きくても 1e5 オーダー。1e12 超は
/// 「有限だが荒謬」な入力（例: 外径1e300）とみなして弾く。
const double _absurdThreshold = 1e12;

void requireFiniteResult(double value, String name) {
  if (!value.isFinite || value.abs() > _absurdThreshold) {
    throw ArgumentError.value(value, name, 'calculation overflowed');
  }
}

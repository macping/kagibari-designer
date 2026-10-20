import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 計算結果のヒーロー表示（結果数値=画面の主役）。
///
/// デフォルト M3 のテキスト行で結果を出すと「Flutter 默认样」になる——
/// 計算アプリの主役は結果数値なので、専用の英雄区で見せる:
/// - 大号数字 + tabular figures（等幅数字。カウント中も桁が踊らない）
/// - accent（primary）色、単位は小さく添える
/// - 値が変わった瞬間に短いカウントアニメ + 軽い触覚フィードバック
/// - FittedBox 兜底（320 幅でも溢れない）
///
/// 使い方（結果カードの主行を置き換える）:
/// ```dart
/// ResultHero(
///   label: l10n.smResultArea,
///   value: result.areaSqM,
///   unit: 'm²',
///   decimals: 2,
/// )
/// ```
class ResultHero extends StatefulWidget {
  const ResultHero({
    super.key,
    required this.value,
    this.unit,
    this.label,
    this.decimals = 2,
    this.format,
    this.animate = true,
  });

  /// 表示する結果値（必ず引擎実測の有限値を渡す。guards 通過後の値）。
  final double value;

  /// 単位（'m²' '円' など）。数値の右に小さく表示。
  final String? unit;

  /// 結果の名目（数値の上に小さく表示）。
  final String? label;

  /// 小数桁数（[format] 指定時は無視）。
  final int decimals;

  /// 独自整形（桁区切り等）。null なら toStringAsFixed(decimals)。
  final String Function(double value)? format;

  /// カウントアニメの有無（リスト内など多数並べる場面は false 推奨）。
  final bool animate;

  @override
  State<ResultHero> createState() => _ResultHeroState();
}

class _ResultHeroState extends State<ResultHero> {
  double _from = 0;

  @override
  void initState() {
    super.initState();
    _from = widget.value;
  }

  @override
  void didUpdateWidget(ResultHero oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _from = oldWidget.value;
      HapticFeedback.lightImpact();
    }
  }

  String _fmt(double v) =>
      widget.format?.call(v) ?? v.toStringAsFixed(widget.decimals);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberStyle = theme.textTheme.displaySmall?.copyWith(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.w700,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    final unitStyle = theme.textTheme.titleMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    Widget number(double shown) => Text.rich(
          TextSpan(
            text: _fmt(shown),
            style: numberStyle,
            children: [
              if (widget.unit != null)
                TextSpan(text: ' ${widget.unit}', style: unitStyle),
            ],
          ),
          maxLines: 1,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        // 狭小画面兜底: 数字がどれだけ長くても1行に収める
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: widget.animate
              ? TweenAnimationBuilder<double>(
                  tween: Tween(begin: _from, end: widget.value),
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                  builder: (context, shown, _) => number(shown),
                )
              : number(widget.value),
        ),
      ],
    );
  }
}

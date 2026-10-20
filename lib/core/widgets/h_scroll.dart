import 'package:flutter/material.dart';

/// 狭い画面で SegmentedButton 等が横に溢れないための横スクロール枠。
/// 収まる幅ではスクロールせず見た目も変わらない（溢れ縞の兜底）。
class HScroll extends StatelessWidget {
  const HScroll({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: child,
  );
}

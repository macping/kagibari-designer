/// 首次启动引导（红线: ≤3页 PageView・スキップ常駐・seen 持久化・設定再入口）。
/// 視覚は領域母題（編み図サムネイル・記号そのもの）のみで構成——矩阵通用轮播禁止。
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/app_localizations.dart';
import '../charts/domain/chart.dart';
import '../charts/presentation/chart_canvas.dart';

const onboardingSeenKey = 'onboarding_seen';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
    required this.onFinished,
    this.review = false,
  });

  /// 完了/スキップ時（seen 永続化後）に呼ばれる。
  final VoidCallback onFinished;

  /// true = 設定からの再視聴（seen 書き込みは冪等なのでそのまま）。
  final bool review;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _page = 0;

  /// 1ページ目のサンプル編み図（静的・円編み4段）。
  static final Chart _sample = () {
    final chart = Chart.newRound(id: 'onboarding-sample', title: '');
    final symbols = ['koma', 'koma2in', 'naga', 'naga2in'];
    for (var round = 0; round < chart.rounds.length; round++) {
      final spec = chart.rounds[round];
      for (var i = 0; i < spec.stitchCount; i++) {
        spec.cells[i] = symbols[round % 2 == 0
            ? (i % 3 == 2 ? 1 : 0)
            : (i % 3 == 2 ? 3 : 2)];
      }
    }
    return chart;
  }();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(onboardingSeenKey, true);
    } on Exception {
      // 保存失敗でもアプリ利用は妨げない（次回また表示されるだけ）
    }
    if (mounted) widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final pages = [
      _OnboardingPage(
        title: l10n.onboarding1Title,
        body: l10n.onboarding1Body,
        visual: _SampleChartVisual(chart: _sample),
      ),
      _OnboardingPage(
        title: l10n.onboarding2Title,
        body: l10n.onboarding2Body,
        visual: const _PaletteDemoVisual(),
      ),
      _OnboardingPage(
        title: l10n.onboarding3Title,
        body: l10n.onboarding3Body,
        visual: const _ProVisual(),
      ),
    ];
    final isLast = _page == pages.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8, top: 4),
                child: TextButton(
                  onPressed: _finish,
                  child: Text(l10n.onboardingSkip),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _page = page),
                children: pages,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < pages.length; i++)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: i == _page ? 18 : 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: i == _page
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: isLast
                          ? _finish
                          : () => _pageController.nextPage(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOut,
                              ),
                      child: Text(
                        isLast ? l10n.onboardingStart : l10n.onboardingNext,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.title,
    required this.body,
    required this.visual,
  });

  final String title;
  final String body;
  final Widget visual;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          Expanded(child: Center(child: visual)),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Text(
            body,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SampleChartVisual extends StatelessWidget {
  const _SampleChartVisual({required this.chart});

  final Chart chart;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: SymbolPictureCache.warmUp(),
      builder: (context, _) => Container(
        constraints: const BoxConstraints(maxWidth: 300, maxHeight: 300),
        decoration: BoxDecoration(
          color: chartPaperColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0x335D4A3C)),
        ),
        padding: const EdgeInsets.all(10),
        child: AspectRatio(aspectRatio: 1, child: ChartThumbnail(chart)),
      ),
    );
  }
}

class _PaletteDemoVisual extends StatelessWidget {
  const _PaletteDemoVisual();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const demoSymbols = ['kusari', 'koma', 'naga', 'koma2in', 'tama'];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 8,
          children: [
            for (final (i, id) in demoSymbols.indexed)
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: chartPaperColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: i == 1
                        ? theme.colorScheme.primary
                        : const Color(0x335D4A3C),
                    width: i == 1 ? 2.4 : 1,
                  ),
                ),
                padding: const EdgeInsets.all(9),
                child: SvgPicture.asset('assets/symbols/$id.svg'),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Icon(
            Icons.arrow_downward,
            size: 32,
            color: theme.colorScheme.primary,
          ),
        ),
        Container(
          width: 190,
          height: 190,
          decoration: BoxDecoration(
            color: chartPaperColor,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0x335D4A3C)),
          ),
          padding: const EdgeInsets.all(8),
          child: ChartThumbnail(_miniChart),
        ),
      ],
    );
  }

  static final Chart _miniChart = () {
    final chart = Chart(
      id: 'onboarding-mini',
      title: '',
      mode: ChartMode.round,
      rounds: [
        RoundSpec(stitchCount: 6, cells: {0: 'koma', 1: 'koma', 2: 'koma'}),
        RoundSpec(stitchCount: 12, cells: {0: 'koma2in'}),
      ],
    );
    return chart;
  }();
}

class _ProVisual extends StatelessWidget {
  const _ProVisual();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final items = [
      (Icons.all_inclusive, l10n.paywallBenefit1),
      (Icons.category_outlined, l10n.paywallBenefit2),
      (Icons.high_quality_outlined, l10n.paywallBenefit3),
      (Icons.block, l10n.paywallBenefit4),
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (icon, text) in items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Flexible(child: Text(text)),
              ],
            ),
          ),
      ],
    );
  }
}

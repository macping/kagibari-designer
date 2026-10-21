/// 作品一覧（ホーム）: 新規作成2択 + サムネイル画廊。
/// 反模板红线: 主页布局=「画布预览卡」画廊，领域组件=編み図サムネイル。
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/purchase/pro_entitlement.dart';
import '../../../core/purchase/purchase_service.dart';
import '../../../l10n/app_localizations.dart';
import '../data/chart_repository.dart';
import '../domain/chart.dart';
import 'chart_canvas.dart';
import 'editor_screen.dart';

class ChartListScreen extends StatefulWidget {
  const ChartListScreen({
    super.key,
    required this.repository,
    required this.entitlement,
    this.purchaseService,
  });

  final ChartRepository repository;
  final ProEntitlement entitlement;
  final PurchaseService? purchaseService;

  @override
  State<ChartListScreen> createState() => _ChartListScreenState();
}

class _ChartListScreenState extends State<ChartListScreen>
    with AutomaticKeepAliveClientMixin {
  List<Chart>? _charts;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    widget.repository.revision.addListener(_reload);
    _reload();
  }

  @override
  void dispose() {
    widget.repository.revision.removeListener(_reload);
    super.dispose();
  }

  Future<void> _reload() async {
    final charts = await widget.repository.loadAll();
    if (mounted) setState(() => _charts = charts);
  }

  String _newId() {
    final random = math.Random();
    return '${DateTime.now().millisecondsSinceEpoch.toRadixString(36)}'
        '${random.nextInt(0xFFFF).toRadixString(36)}';
  }

  Future<void> _create(ChartMode mode) async {
    final l10n = AppLocalizations.of(context)!;
    final id = _newId();
    final chart = mode == ChartMode.round
        ? Chart.newRound(id: id, title: l10n.chartDefaultTitle)
        : Chart.newGrid(id: id, title: l10n.chartDefaultTitle);
    await widget.repository.save(chart);
    await _openEditor(chart);
  }

  Future<void> _openEditor(Chart chart) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => EditorScreen(
          chart: chart,
          repository: widget.repository,
          entitlement: widget.entitlement,
          purchaseService: widget.purchaseService,
        ),
      ),
    );
    await _reload();
  }

  Future<void> _rename(Chart chart) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: chart.title);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.renameTitle),
        content:
            TextField(controller: controller, autofocus: true, maxLength: 60),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
    if (result == null || result.isEmpty) return;
    chart.title = result;
    await widget.repository.save(chart);
    await _reload();
  }

  Future<void> _duplicate(Chart chart) async {
    final copy = chart.copy();
    final duplicated = Chart(
      id: _newId(),
      title: '${chart.title} (2)',
      mode: copy.mode,
      rounds: copy.rounds,
      gridRows: copy.gridRows,
      gridCols: copy.gridCols,
      gridCells: copy.gridCells,
    );
    await widget.repository.save(duplicated);
    await _reload();
  }

  Future<void> _delete(Chart chart) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteChart),
        content: Text(l10n.deleteConfirm(chart.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.deleteOk),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await widget.repository.delete(chart.id);
    await _reload();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final charts = _charts;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: charts == null
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Expanded(
                          child: _CreateCard(
                            icon: Icons.donut_large,
                            label: l10n.newRoundChart,
                            onTap: () => _create(ChartMode.round),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _CreateCard(
                            icon: Icons.grid_4x4,
                            label: l10n.newGridChart,
                            onTap: () => _create(ChartMode.grid),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (charts.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          l10n.emptyGallery,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 220,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.78,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => _ChartCard(
                          chart: charts[i],
                          subtitle: charts[i].mode == ChartMode.round
                              ? l10n.roundsCount(charts[i].rounds.length)
                              : l10n.gridSize(
                                  charts[i].gridCols,
                                  charts[i].gridRows,
                                ),
                          onTap: () => _openEditor(charts[i]),
                          onRename: () => _rename(charts[i]),
                          onDuplicate: () => _duplicate(charts[i]),
                          onDelete: () => _delete(charts[i]),
                        ),
                        childCount: charts.length,
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _CreateCard extends StatelessWidget {
  const _CreateCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.secondaryContainer,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          child: Column(
            children: [
              Icon(icon, color: theme.colorScheme.onSecondaryContainer),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.chart,
    required this.subtitle,
    required this.onTap,
    required this.onRename,
    required this.onDuplicate,
    required this.onDelete,
  });

  final Chart chart;
  final String subtitle;
  final VoidCallback onTap;
  final VoidCallback onRename;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Material(
      borderRadius: BorderRadius.circular(14),
      color: theme.colorScheme.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: DecoratedBox(
                decoration: const BoxDecoration(color: chartPaperColor),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: ChartThumbnail(chart),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 4, 0, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chart.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall,
                        ),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) => switch (value) {
                      'rename' => onRename(),
                      'duplicate' => onDuplicate(),
                      _ => onDelete(),
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'rename',
                        child: Text(l10n.renameTitle),
                      ),
                      PopupMenuItem(
                        value: 'duplicate',
                        child: Text(l10n.duplicateChart),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(l10n.deleteChart),
                      ),
                    ],
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

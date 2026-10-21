/// 編み図エディタ（単画面フルスクリーン——横手势红线はキャンバス自身が優先）。
///
/// 操作系:
/// - パレットで記号選択 → マス目タップで配置（常に吸着・置換可）
/// - パレットからドラッグ＆ドロップでも配置
/// - 長押しで削除／消しゴムモードでタップ削除
/// - 2本指でズーム・パン（InteractiveViewer）
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/export/chart_exporter.dart';
import '../../../core/purchase/paywall_sheet.dart';
import '../../../core/purchase/pro_entitlement.dart';
import '../../../core/purchase/purchase_service.dart';
import '../../../l10n/app_localizations.dart';
import '../data/chart_repository.dart';
import '../domain/chart.dart';
import '../domain/chart_commands.dart';
import '../domain/symbol_registry.dart';
import 'chart_canvas.dart';
import 'editor_controller.dart';

/// 無料層の円編み段数上限（Pro=無制限）。
const kFreeMaxRounds = 6;

class EditorScreen extends StatefulWidget {
  const EditorScreen({
    super.key,
    required this.chart,
    required this.repository,
    required this.entitlement,
    this.purchaseService,
  });

  final Chart chart;
  final ChartRepository repository;
  final ProEntitlement entitlement;
  final PurchaseService? purchaseService;

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late final ChartEditorController _controller = ChartEditorController(
    chart: widget.chart,
    repository: widget.repository,
  );
  final TransformationController _transform = TransformationController();
  final GlobalKey _viewportKey = GlobalKey();
  late final Future<void> _warmUp = SymbolPictureCache.warmUp();
  bool _fitted = false;

  Chart get _chart => widget.chart;

  @override
  void dispose() {
    _controller.flush();
    _controller.dispose();
    _transform.dispose();
    super.dispose();
  }

  Size get _logicalSize => _chart.mode == ChartMode.round
      ? RoundChartGeometry(_chart).logicalSize
      : GridChartGeometry(_chart).logicalSize;

  void _fitToViewport(Size viewport) {
    final logical = _logicalSize;
    final scale = math.min(
          viewport.width / logical.width,
          viewport.height / logical.height,
        ) *
        0.94;
    final dx = (viewport.width - logical.width * scale) / 2;
    final dy = (viewport.height - logical.height * scale) / 2;
    _transform.value = Matrix4.identity()
      ..translateByDouble(dx, dy, 0, 1)
      ..scaleByDouble(scale, scale, 1, 1);
  }

  void _handleTap(Offset scenePoint) {
    if (_chart.mode == ChartMode.round) {
      final hit = RoundChartGeometry(_chart).hitTest(scenePoint);
      if (hit == null) return;
      _controller.actOnRoundCell(hit.$1, hit.$2);
    } else {
      final hit = GridChartGeometry(_chart).hitTest(scenePoint);
      if (hit == null) return;
      _controller.actOnGridCell(hit.$1, hit.$2);
    }
  }

  void _handleLongPress(Offset scenePoint) {
    if (_chart.mode == ChartMode.round) {
      final hit = RoundChartGeometry(_chart).hitTest(scenePoint);
      if (hit == null) return;
      _controller.removeRoundCell(hit.$1, hit.$2);
    } else {
      final hit = GridChartGeometry(_chart).hitTest(scenePoint);
      if (hit == null) return;
      _controller.removeGridCell(hit.$1, hit.$2);
    }
  }

  void _handleDrop(String symbolId, Offset globalOffset) {
    final box =
        _viewportKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    // details.offset はフィードバック左上——指先中心へ補正（56px タイル）
    final local = box.globalToLocal(globalOffset + const Offset(28, 28));
    final scene = _transform.toScene(local);
    if (_chart.mode == ChartMode.round) {
      final hit = RoundChartGeometry(_chart).hitTest(scene);
      if (hit != null) {
        _controller.actOnRoundCell(hit.$1, hit.$2, symbolId: symbolId);
      }
    } else {
      final hit = GridChartGeometry(_chart).hitTest(scene);
      if (hit != null) {
        _controller.actOnGridCell(hit.$1, hit.$2, symbolId: symbolId);
      }
    }
  }

  Future<void> _rename() async {
    final l10n = AppLocalizations.of(context)!;
    final textController = TextEditingController(text: _chart.title);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.renameTitle),
        content: TextField(
          controller: textController,
          autofocus: true,
          maxLength: 60,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, textController.text.trim()),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      _controller.rename(result);
    }
  }

  void _showPaywall() =>
      showPaywallSheet(context, purchaseService: widget.purchaseService);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          // 字号を一段落として実容量を稼ぐ（デフォルト22spだと英語題が「…」になる）
          title: InkWell(
            onTap: _rename,
            child: Text(
              _chart.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.undo),
              tooltip: l10n.undoTooltip,
              onPressed:
                  _controller.undoStack.canUndo ? _controller.undo : null,
            ),
            IconButton(
              icon: const Icon(Icons.redo),
              tooltip: l10n.redoTooltip,
              onPressed:
                  _controller.undoStack.canRedo ? _controller.redo : null,
            ),
            IconButton(
              icon: Icon(_chart.mode == ChartMode.round
                  ? Icons.donut_large
                  : Icons.grid_4x4),
              tooltip: _chart.mode == ChartMode.round
                  ? l10n.roundSettingsTooltip
                  : l10n.gridSizeTitle,
              onPressed: _chart.mode == ChartMode.round
                  ? _showRoundsSheet
                  : _showGridSheet,
            ),
            IconButton(
              icon: const Icon(Icons.ios_share),
              tooltip: l10n.exportTooltip,
              onPressed: _showExportSheet,
            ),
          ],
        ),
        body: FutureBuilder<void>(
          future: _warmUp,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                Expanded(child: _buildCanvas()),
                _PaletteBar(
                  controller: _controller,
                  entitlement: widget.entitlement,
                  onLockedSymbol: _showPaywall,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCanvas() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!_fitted) {
          _fitted = true;
          _fitToViewport(constraints.biggest);
        }
        return DragTarget<String>(
          onAcceptWithDetails: (details) =>
              _handleDrop(details.data, details.offset),
          builder: (context, _, _) => Container(
            key: _viewportKey,
            color: chartPaperColor,
            child: InteractiveViewer(
              transformationController: _transform,
              constrained: false,
              minScale: 0.2,
              maxScale: 8,
              boundaryMargin: const EdgeInsets.all(600),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapUp: (details) => _handleTap(details.localPosition),
                onLongPressStart: (details) =>
                    _handleLongPress(details.localPosition),
                child: RepaintBoundary(
                  child: CustomPaint(
                    size: _logicalSize,
                    painter: painterFor(_chart, repaint: _controller),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ---- 段ごとの目数（円編み） ----

  void _showRoundsSheet() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => ListenableBuilder(
        listenable: _controller,
        builder: (sheetContext, _) {
          final rounds = _chart.rounds;
          return SafeArea(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.7,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.roundSettingsTooltip,
                            style: Theme.of(sheetContext).textTheme.titleMedium,
                          ),
                        ),
                        IconButton(
                          tooltip: l10n.removeRound,
                          onPressed: rounds.length > 1
                              ? () => _controller
                                  .execute(RemoveLastRoundCommand())
                              : null,
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        FilledButton.tonalIcon(
                          onPressed: () {
                            if (!widget.entitlement.isPro &&
                                rounds.length >= kFreeMaxRounds) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.freeRoundLimit)),
                              );
                              Navigator.pop(sheetContext);
                              _showPaywall();
                              return;
                            }
                            _controller.execute(
                              AddRoundCommand(rounds.last.stitchCount + 6),
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: Text(l10n.addRound),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: rounds.length,
                      itemBuilder: (context, i) {
                        final round = rounds.length - 1 - i; // 外周を上に
                        final spec = rounds[round];
                        return ListTile(
                          dense: true,
                          title: Text(l10n.roundLabel(round + 1)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: spec.stitchCount > 1
                                    ? () => _controller.execute(
                                          SetStitchCountCommand(
                                            round,
                                            spec.stitchCount - 1,
                                          ),
                                        )
                                    : null,
                              ),
                              SizedBox(
                                width: 44,
                                child: Text(
                                  '${spec.stitchCount}',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontFeatures: const [
                                          FontFeature.tabularFigures(),
                                        ],
                                      ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: spec.stitchCount < 120
                                    ? () => _controller.execute(
                                          SetStitchCountCommand(
                                            round,
                                            spec.stitchCount + 1,
                                          ),
                                        )
                                    : null,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ---- 方眼サイズ ----

  void _showGridSheet() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => ListenableBuilder(
        listenable: _controller,
        builder: (sheetContext, _) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.gridSizeTitle,
                  style: Theme.of(sheetContext).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                _GridDimensionRow(
                  label: l10n.colsLabel,
                  value: _chart.gridCols,
                  onChanged: (v) => _controller.execute(
                    ResizeGridCommand(_chart.gridRows, v),
                  ),
                ),
                _GridDimensionRow(
                  label: l10n.rowsLabel,
                  value: _chart.gridRows,
                  onChanged: (v) => _controller.execute(
                    ResizeGridCommand(v, _chart.gridCols),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---- 書き出し ----

  void _showExportSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => _ExportSheet(
        chart: _chart,
        entitlement: widget.entitlement,
        onLocked: () {
          Navigator.pop(sheetContext);
          _showPaywall();
        },
      ),
    );
  }
}

class _GridDimensionRow extends StatelessWidget {
  const _GridDimensionRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: value > 2 ? () => onChanged(value - 1) : null,
        ),
        SizedBox(
          width: 44,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: value < 60 ? () => onChanged(value + 1) : null,
        ),
      ],
    );
  }
}

// ---- 記号パレット ----

class _PaletteBar extends StatefulWidget {
  const _PaletteBar({
    required this.controller,
    required this.entitlement,
    required this.onLockedSymbol,
  });

  final ChartEditorController controller;
  final ProEntitlement entitlement;
  final VoidCallback onLockedSymbol;

  @override
  State<_PaletteBar> createState() => _PaletteBarState();
}

class _PaletteBarState extends State<_PaletteBar> {
  SymbolCategory _category = SymbolCategory.basic;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final symbols = SymbolRegistry.byCategory(_category);
    final categoryLabels = {
      SymbolCategory.basic: l10n.catBasic,
      SymbolCategory.incDec: l10n.catIncDec,
      SymbolCategory.fancy: l10n.catFancy,
    };
    return Material(
      color: theme.colorScheme.surfaceContainerHigh,
      child: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable:
              Listenable.merge([widget.controller, widget.entitlement]),
          builder: (context, _) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 6,
                      ),
                      child: FilterChip(
                        avatar: Icon(
                          Icons.auto_fix_normal,
                          size: 18,
                          color: widget.controller.eraser
                              ? theme.colorScheme.onSecondaryContainer
                              : null,
                        ),
                        label: Text(l10n.eraserTooltip),
                        selected: widget.controller.eraser,
                        onSelected: (_) => widget.controller.toggleEraser(),
                      ),
                    ),
                    for (final category in SymbolCategory.values)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 6,
                        ),
                        child: ChoiceChip(
                          label: Text(categoryLabels[category]!),
                          selected: _category == category,
                          onSelected: (_) =>
                              setState(() => _category = category),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 86,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: symbols.length,
                  itemBuilder: (context, i) => _SymbolTile(
                    symbol: symbols[i],
                    selected: !widget.controller.eraser &&
                        widget.controller.selectedSymbolId == symbols[i].id,
                    locked:
                        !widget.entitlement.isPro && !symbols[i].isFree,
                    onTap: () {
                      if (!widget.entitlement.isPro && !symbols[i].isFree) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.proLockedSymbol)),
                        );
                        widget.onLockedSymbol();
                        return;
                      }
                      widget.controller.selectSymbol(symbols[i].id);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SymbolTile extends StatelessWidget {
  const _SymbolTile({
    required this.symbol,
    required this.selected,
    required this.locked,
    required this.onTap,
  });

  final ChartSymbol symbol;
  final bool selected;
  final bool locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final tile = Container(
      width: 64,
      margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
      decoration: BoxDecoration(
        color: chartPaperColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant,
          width: selected ? 2.4 : 1,
        ),
      ),
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: Opacity(
                    opacity: locked ? 0.35 : 1,
                    child: SvgPicture.asset(symbol.asset, width: 34, height: 34),
                  ),
                ),
                if (locked)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Icon(
                      Icons.lock,
                      size: 14,
                      color: theme.colorScheme.outline,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            symbol.shortFor(languageCode),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, color: Color(0xFF5D4A3C)),
          ),
        ],
      ),
    );
    final interactive = GestureDetector(onTap: onTap, child: tile);
    if (locked) return interactive;
    return Draggable<String>(
      data: symbol.id,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: chartPaperColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(blurRadius: 8, color: Color(0x40000000)),
            ],
          ),
          padding: const EdgeInsets.all(8),
          child: SvgPicture.asset(symbol.asset),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.4, child: tile),
      child: interactive,
    );
  }
}

// ---- 書き出しシート ----

class _ExportSheet extends StatefulWidget {
  const _ExportSheet({
    required this.chart,
    required this.entitlement,
    required this.onLocked,
  });

  final Chart chart;
  final ProEntitlement entitlement;
  final VoidCallback onLocked;

  @override
  State<_ExportSheet> createState() => _ExportSheetState();
}

class _ExportSheetState extends State<_ExportSheet> {
  int _resolution = ChartExporter.freeResolution;
  bool _busy = false;
  String? _error;

  Future<void> _run(Future<void> Function() action) async {
    final l10n = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
      if (mounted) navigator.pop();
    } on Exception {
      if (mounted) setState(() => _error = l10n.exportFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isPro = widget.entitlement.isPro;
    final watermark = !isPro;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.exportTitle,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(l10n.resolutionLabel, style: theme.textTheme.labelLarge),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              children: [
                for (final resolution in ChartExporter.proResolutions)
                  ChoiceChip(
                    avatar: !isPro &&
                            resolution != ChartExporter.freeResolution
                        ? const Icon(Icons.lock, size: 14)
                        : null,
                    label: Text('${resolution}px'),
                    selected: _resolution == resolution,
                    onSelected: (_) {
                      if (!isPro &&
                          resolution != ChartExporter.freeResolution) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.proResolution)),
                        );
                        widget.onLocked();
                        return;
                      }
                      setState(() => _resolution = resolution);
                    },
                  ),
              ],
            ),
            if (watermark)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  l10n.watermarkNotice,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.outline),
                ),
              ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _busy
                  ? null
                  : () => _run(
                        () => ChartExporter.sharePng(
                          widget.chart,
                          pixelWidth: _resolution,
                          watermark: watermark,
                        ),
                      ),
              icon: const Icon(Icons.image_outlined),
              label: Text(l10n.exportPng),
            ),
            const SizedBox(height: 8),
            FilledButton.tonalIcon(
              onPressed: _busy
                  ? null
                  : () => _run(
                        () => ChartExporter.sharePdf(
                          widget.chart,
                          watermark: watermark,
                        ),
                      ),
              icon: const Icon(Icons.picture_as_pdf_outlined),
              label: Text(l10n.exportPdf),
            ),
            if (_busy)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.error),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

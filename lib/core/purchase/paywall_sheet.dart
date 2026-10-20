/// MicroCalc Shell: Pro解錠の共通ペイウォール（BottomSheet）。
library;

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'purchase_service.dart';

/// ペイウォールを表示。購入完了は entitlement 経由で反映されるので
/// 呼び出し側は entitlement を listen していれば自動で解錠される。
Future<void> showPaywallSheet(
  BuildContext context, {
  required PurchaseService? purchaseService,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => _PaywallContent(purchaseService: purchaseService),
  );
}

class _PaywallContent extends StatefulWidget {
  const _PaywallContent({required this.purchaseService});

  final PurchaseService? purchaseService;

  @override
  State<_PaywallContent> createState() => _PaywallContentState();
}

class _PaywallContentState extends State<_PaywallContent> {
  String _price = kProFallbackPrice;
  bool _busy = false;

  /// 失敗時のフィードバック。SnackBar はモーダルシートの背後の Scaffold に
  /// 出て見えない（2026-09-07 schiessbuch 実機確認）ため、
  /// シート内にインライン表示する。
  String? _feedback;

  @override
  void initState() {
    super.initState();
    widget.purchaseService?.queryProduct().then((p) {
      if (mounted && p != null) setState(() => _price = p.price);
    });
  }

  Future<void> _run(Future<PurchaseUiResult> Function() action) async {
    final navigator = Navigator.of(context);
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _busy = true;
      _feedback = null;
    });
    final result = await action();
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case PurchaseUiResult.pending:
      case PurchaseUiResult.success:
        navigator.pop(); // 反映は entitlement のリスナー側で
      case PurchaseUiResult.cancelled:
        break;
      case PurchaseUiResult.unavailable:
        setState(() => _feedback = l10n.storeUnavailable);
      case PurchaseUiResult.error:
        setState(() => _feedback = l10n.purchaseError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final service = widget.purchaseService;
    final benefits = <(IconData, String)>[
      (Icons.star, l10n.paywallBenefit1),
      (Icons.history, l10n.paywallBenefit2),
      (Icons.table_view, l10n.paywallBenefit3),
      (Icons.block, l10n.paywallBenefit4),
    ];
    return SafeArea(
      // 狭小画面（320×568等）では内容がシート高を超えるためスクロール可に
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.paywallTitle,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.paywallSubtitle(_price),
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            for (final (icon, text) in benefits)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Icon(icon, color: theme.colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(child: Text(text)),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: service == null || _busy
                  ? null
                  : () => _run(service.buy),
              child: _busy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.buyButton(_price)),
            ),
            TextButton(
              onPressed: service == null || _busy
                  ? null
                  : () => _run(service.restore),
              child: Text(l10n.restorePurchase),
            ),
            if (_feedback != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _feedback!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

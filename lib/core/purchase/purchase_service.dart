/// MicroCalc Shell: in_app_purchase ラッパー。非消耗型1商品（買切）専用。
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'pro_entitlement.dart';

/// App Store Connect / Play Console に登録する商品ID（両ストア共通）。
/// 一度公開したら変更不可。
const String kProProductId = 'pro_unlock';

/// 表示用の既定価格。ストアから取得できたら実価格で上書きする。
const String kProFallbackPrice = '¥800';

enum PurchaseUiResult { success, pending, cancelled, error, unavailable }

class PurchaseService {
  PurchaseService({required this.entitlement, InAppPurchase? iap})
    : _iap = iap ?? InAppPurchase.instance;

  final ProEntitlement entitlement;
  final InAppPurchase _iap;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  /// 非消耗型1商品は不変なので、初回取得後はキャッシュを返す
  /// （ペイウォールを開くたびのストア照会と価格チラつきを防ぐ）。
  ProductDetails? _cachedProduct;

  /// アプリ起動時に一度呼ぶ。未処理の購入（Android再起動後等）もここで拾う。
  ///
  /// Android はプラグインが過去の購入を自動配信しないため、起動時に静かに
  /// 復元し、再インストール後も自動で解錠する（2026-09-18 denki-setsubi
  /// Redmi実機: 復元せず購入を押すと ITEM_ALREADY_OWNED で詰まる）。
  /// iOS の復元はサインイン要求を出しうるので手動ボタンのみ。
  void init() {
    if (_subscription != null) return;
    _subscription = _iap.purchaseStream.listen(_onPurchases);
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      unawaited(_silentRestore());
    }
  }

  /// 失敗しても静かに諦める復元（手動の復元ボタンは別途残る）。
  Future<void> _silentRestore() async {
    try {
      if (!await _iap.isAvailable()) return;
      await _iap.restorePurchases();
    } catch (_) {}
  }

  /// ITEM_ALREADY_OWNED（すでに所有しています）か。
  /// Play の応答は 'BillingResponse.itemAlreadyOwned' や
  /// 'Item is already owned' 等の表記ゆれがある。
  static bool _isAlreadyOwned(IAPError? error) {
    final text = '${error?.code} ${error?.message} ${error?.details}'
        .toLowerCase();
    return text.contains('already') && text.contains('own');
  }

  Future<void> _onPurchases(List<PurchaseDetails> purchases) async {
    for (final p in purchases) {
      // 購入失敗イベントは productID が空で届くことがあるため、
      // 商品IDフィルタの前に処理する（本アプリは1商品のみ）。
      if (p.status == PurchaseStatus.error) {
        // 所有済みなのに購入を試みた＝解錠が失われた状態。所有情報から復元。
        if (_isAlreadyOwned(p.error)) unawaited(_silentRestore());
        if (p.pendingCompletePurchase) await _iap.completePurchase(p);
        continue;
      }
      if (p.productID != kProProductId) continue;
      switch (p.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await entitlement.setPro(true);
        case PurchaseStatus.error:
        case PurchaseStatus.canceled:
        case PurchaseStatus.pending:
          break;
      }
      if (p.pendingCompletePurchase) {
        await _iap.completePurchase(p);
      }
    }
  }

  /// ストア価格を取得。取得不能なら null（UIはフォールバック価格を表示）。
  Future<ProductDetails?> queryProduct() async {
    final cached = _cachedProduct;
    if (cached != null) return cached;
    try {
      if (!await _iap.isAvailable()) return null;
      final response = await _iap.queryProductDetails({kProProductId});
      if (response.productDetails.isEmpty) return null;
      return _cachedProduct = response.productDetails.first;
    } catch (_) {
      return null;
    }
  }

  /// 購入フローを開始。結果自体は purchaseStream 経由で entitlement に反映。
  Future<PurchaseUiResult> buy() async {
    try {
      final product = await queryProduct();
      if (product == null) return PurchaseUiResult.unavailable;
      final started = await _iap.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: product),
      );
      return started ? PurchaseUiResult.pending : PurchaseUiResult.error;
    } catch (_) {
      return PurchaseUiResult.error;
    }
  }

  /// 機種変更・再インストール時の復元。
  Future<PurchaseUiResult> restore() async {
    try {
      if (!await _iap.isAvailable()) return PurchaseUiResult.unavailable;
      await _iap.restorePurchases();
      return PurchaseUiResult.pending;
    } catch (_) {
      return PurchaseUiResult.error;
    }
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}

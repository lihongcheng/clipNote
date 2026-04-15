import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../settings/providers/settings_provider.dart';

const String kProProductId = 'clipnote_pro_unlock';

@immutable
class MonetizationState {
  const MonetizationState({
    this.isLoading = false,
    this.isStoreAvailable = false,
    this.product,
    this.error,
    this.purchasePending = false,
    this.debugMessage,
  });

  final bool isLoading;
  final bool isStoreAvailable;
  final ProductDetails? product;
  final String? error;
  final bool purchasePending;
  final String? debugMessage;

  MonetizationState copyWith({
    bool? isLoading,
    bool? isStoreAvailable,
    ProductDetails? product,
    bool clearProduct = false,
    String? error,
    bool clearError = false,
    bool? purchasePending,
    String? debugMessage,
    bool clearDebugMessage = false,
  }) {
    return MonetizationState(
      isLoading: isLoading ?? this.isLoading,
      isStoreAvailable: isStoreAvailable ?? this.isStoreAvailable,
      product: clearProduct ? null : (product ?? this.product),
      error: clearError ? null : (error ?? this.error),
      purchasePending: purchasePending ?? this.purchasePending,
      debugMessage: clearDebugMessage ? null : (debugMessage ?? this.debugMessage),
    );
  }
}

class MonetizationNotifier extends Notifier<MonetizationState> {
  late final InAppPurchase _iap;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  @override
  MonetizationState build() {
    _iap = InAppPurchase.instance;
    _subscription = _iap.purchaseStream.listen(_onPurchaseUpdate);
    ref.onDispose(() {
      _subscription?.cancel();
    });
    unawaited(loadProducts());
    return const MonetizationState(
      isLoading: true,
      debugMessage: 'start',
    );
  }

  Future<void> loadProducts() async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      debugMessage: 'start',
    );
    try {
      final available = await _iap.isAvailable();
      if (!available) {
        state = state.copyWith(
          isLoading: false,
          isStoreAvailable: false,
          error: 'Google Play is not available on this device.',
          debugMessage: 'isAvailable=false',
        );
          return;
      }

      state = state.copyWith(
        debugMessage: 'isAvailable=true | querying product',
      );

      final response = await _iap
          .queryProductDetails({kProProductId})
          .timeout(const Duration(seconds: 10));
      final debugMessage = [
        'isAvailable=true',
        'productDetails=${response.productDetails.length}',
        if (response.notFoundIDs.isNotEmpty)
          'notFoundIDs=${response.notFoundIDs.join(",")}',
        if (response.error != null)
          'responseError=${response.error!.code}:${response.error!.message}',
      ].join(' | ');

      if (response.error != null) {
        state = state.copyWith(
          isLoading: false,
          isStoreAvailable: true,
          error: response.error!.message,
          debugMessage: debugMessage,
        );
        return;
      }

      final product = response.productDetails
          .where((p) => p.id == kProProductId)
          .firstOrNull;
      state = state.copyWith(
        isLoading: false,
        isStoreAvailable: true,
        product: product,
        clearError: true,
        debugMessage: debugMessage,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: error.toString(),
        debugMessage: error is TimeoutException
            ? 'isAvailable=true | query timeout after 10s'
            : 'exception=${error.runtimeType}:$error',
      );
    }
  }

  Future<void> buyPro() async {
    final product = state.product;
    if (product == null) {
      state = state.copyWith(error: 'Pro product is not configured yet.');
      return;
    }
    state = state.copyWith(purchasePending: true, clearError: true);
    final purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restorePurchases() async {
    state = state.copyWith(purchasePending: true, clearError: true);
    await _iap.restorePurchases();
  }

  Future<void> simulateUnlock() async {
    await ref.read(settingsProvider.notifier).setPro(true);
  }

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.productID != kProProductId) continue;

      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        await ref.read(settingsProvider.notifier).setPro(true);
      }

      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }

      if (purchase.status == PurchaseStatus.error) {
        state = state.copyWith(error: purchase.error?.message);
      }
    }
    state = state.copyWith(purchasePending: false);
  }
}

final monetizationProvider =
    NotifierProvider<MonetizationNotifier, MonetizationState>(
  MonetizationNotifier.new,
);

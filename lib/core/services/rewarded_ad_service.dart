import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdService {
  RewardedAdService._();

  static final RewardedAdService instance = RewardedAdService._();

  static const String _androidDebugAdUnitId =
      'ca-app-pub-3940256099942544/5224354917';
  static const String _androidReleaseAdUnitId =
      'ca-app-pub-6243890571514259/3059288114';

  RewardedAd? _rewardedAd;
  bool _isLoading = false;
  bool _initialized = false;

  String get _rewardedAdUnitId =>
      kDebugMode ? _androidDebugAdUnitId : _androidReleaseAdUnitId;

  Future<void> init() async {
    if (_initialized) return;
    await MobileAds.instance.initialize();
    _initialized = true;
    unawaited(preload());
  }

  Future<void> preload() async {
    if (!_initialized || _rewardedAd != null || _isLoading) return;
    _isLoading = true;

    await RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isLoading = false;
        },
        onAdFailedToLoad: (_) {
          _rewardedAd = null;
          _isLoading = false;
        },
      ),
    );
  }

  Future<bool> showRewardedUnlockAd() async {
    if (!_initialized) return false;

    if (_rewardedAd == null) {
      await preload();
      if (_rewardedAd == null) {
        return false;
      }
    }

    final completer = Completer<bool>();
    final ad = _rewardedAd!;
    _rewardedAd = null;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        if (!completer.isCompleted) {
          completer.complete(false);
        }
        unawaited(preload());
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        if (!completer.isCompleted) {
          completer.complete(false);
        }
        unawaited(preload());
      },
    );

    await ad.show(
      onUserEarnedReward: (_, __) {
        if (!completer.isCompleted) {
          completer.complete(true);
        }
      },
    );

    return completer.future;
  }
}

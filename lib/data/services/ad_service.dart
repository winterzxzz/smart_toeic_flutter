import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Manages App Open Ads and app lifecycle to present ads when appropriate.
class AdService with WidgetsBindingObserver {
  AppOpenAd? _appOpenAd;
  DateTime? _lastLoadTime;
  bool _isShowingAd = false;
  Timer? _preloadTimer;

  /// Android test unit. Replace with production unit when ready.
  static const String appOpenAdUnitId =
      'ca-app-pub-3940256099942544/9257395921';

  void initialize() {
    WidgetsBinding.instance.addObserver(this);
    _preloadIfNeeded();
    // Periodically ensure an ad is ready.
    _preloadTimer?.cancel();
    _preloadTimer = Timer.periodic(const Duration(minutes: 10), (_) {
      _preloadIfNeeded(force: false);
    });
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _preloadTimer?.cancel();
    _appOpenAd?.dispose();
    _appOpenAd = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      showAppOpenAdIfAvailable();
    }
  }

  bool get _isAdFresh {
    if (_lastLoadTime == null) return false;
    return DateTime.now().difference(_lastLoadTime!).inMinutes < 4;
  }

  void _preloadIfNeeded({bool force = false}) {
    if (!force && (_appOpenAd != null && _isAdFresh)) return;
    _loadAppOpenAd();
  }

  void _loadAppOpenAd() {
    AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _lastLoadTime = DateTime.now();
          _appOpenAd?.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              _isShowingAd = true;
            },
            onAdDismissedFullScreenContent: (ad) {
              _isShowingAd = false;
              ad.dispose();
              _appOpenAd = null;
              _preloadIfNeeded(force: true);
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              _isShowingAd = false;
              ad.dispose();
              _appOpenAd = null;
              _preloadIfNeeded(force: true);
            },
          );
        },
        onAdFailedToLoad: (error) {
          _appOpenAd = null;
          // Retry after a short delay to avoid tight loops.
          Future.delayed(const Duration(seconds: 30), () => _preloadIfNeeded());
        },
      ),
    );
  }

  /// Shows the app open ad if ready; otherwise triggers preload.
  void showAppOpenAdIfAvailable() {
    if (_isShowingAd) return;
    if (_appOpenAd == null) {
      _preloadIfNeeded(force: true);
      return;
    }
    if (!_isAdFresh) {
      _appOpenAd?.dispose();
      _appOpenAd = null;
      _preloadIfNeeded(force: true);
      return;
    }

    _appOpenAd?.show();
  }
}

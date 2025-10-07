import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Manages App Open Ads, Native Ads and app lifecycle to present ads when appropriate.
class AdService with WidgetsBindingObserver {
  AppOpenAd? _appOpenAd;
  DateTime? _lastLoadTime;
  bool _isShowingAd = false;
  Timer? _preloadTimer;
  DateTime? _lastPausedAt;
  bool _wasInBackground = false;
  
  // Native Ad properties
  NativeAd? _nativeAd;
  bool _isNativeAdReady = false;
  int _nativeAdRetryAttempt = 0;
  int _appOpenAdRetryAttempt = 0;
  static const int maxRetryAttempts = 3;

  /// Platform-specific ad unit IDs
  /// 
  /// ⚠️ CURRENTLY USING GOOGLE'S OFFICIAL TEST AD UNIT IDs ⚠️
  /// These will ONLY show test ads, never real ads.
  /// Safe to use for development and testing without any configuration.
  /// 
  /// To use production ads:
  /// 1. Create ad units in AdMob console (https://admob.google.com)
  /// 2. Replace the IDs below with your production ad unit IDs
  /// 3. Test thoroughly before releasing
  static String get appOpenAdUnitId {
    if (Platform.isAndroid) {
      // Android Test ID - shows test ads only
      return 'ca-app-pub-3940256099942544/9257395921';
    } else if (Platform.isIOS) {
      // iOS Test ID - shows test ads only
      return 'ca-app-pub-3940256099942544/5575463023';
    }
    throw UnsupportedError('Unsupported platform');
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      // Android Test ID - shows test ads only
      return 'ca-app-pub-3940256099942544/2247696110';
    } else if (Platform.isIOS) {
      // iOS Test ID - shows test ads only
      return 'ca-app-pub-3940256099942544/3986624511';
    }
    throw UnsupportedError('Unsupported platform');
  }

  Future<void> initialize() async {
    log('AdService: Initializing...');
    WidgetsBinding.instance.addObserver(this);
    
    // Wait a moment to ensure MobileAds SDK is fully initialized
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Preload ads
    _preloadIfNeeded(force: true);
    _loadNativeAd();
    
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
    _nativeAd?.dispose();
    _nativeAd = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Mark when the app goes to background
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _wasInBackground = true;
      _lastPausedAt = DateTime.now();
      return;
    }

    // Only show when truly returning from background after a minimum duration
    if (state == AppLifecycleState.resumed) {
      final pausedAgo = _lastPausedAt == null
          ? Duration.zero
          : DateTime.now().difference(_lastPausedAt!);
      const minBackgroundDuration = Duration(seconds: 2);

      if (_wasInBackground && pausedAgo >= minBackgroundDuration) {
        showAppOpenAdIfAvailable();
      }

      // Reset flags regardless
      _wasInBackground = false;
      _lastPausedAt = null;
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
    log('AdService: Loading AppOpenAd with ID: $appOpenAdUnitId (attempt ${_appOpenAdRetryAttempt + 1}/$maxRetryAttempts)');
    AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          log('AdService: AppOpenAd loaded successfully');
          _appOpenAd = ad;
          _lastLoadTime = DateTime.now();
          _appOpenAdRetryAttempt = 0; // Reset retry counter on success
          _appOpenAd?.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              log('AdService: AppOpenAd shown');
              _isShowingAd = true;
            },
            onAdDismissedFullScreenContent: (ad) {
              log('AdService: AppOpenAd dismissed');
              _isShowingAd = false;
              ad.dispose();
              _appOpenAd = null;
              _appOpenAdRetryAttempt = 0; // Reset retry counter
              _preloadIfNeeded(force: true);
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              log('AdService: AppOpenAd failed to show: $error');
              _isShowingAd = false;
              ad.dispose();
              _appOpenAd = null;
              _preloadIfNeeded(force: true);
            },
          );
        },
        onAdFailedToLoad: (error) {
          log('AdService: AppOpenAd failed to load: $error');
          _appOpenAd = null;
          
          // Retry with exponential backoff
          if (_appOpenAdRetryAttempt < maxRetryAttempts) {
            _appOpenAdRetryAttempt++;
            final retryDelay = Duration(
              seconds: (30 * _appOpenAdRetryAttempt).clamp(30, 300),
            );
            log('AdService: Retrying AppOpenAd in ${retryDelay.inSeconds}s...');
            Future.delayed(retryDelay, () => _preloadIfNeeded(force: true));
          } else {
            log('AdService: Max retry attempts reached for AppOpenAd');
          }
        },
      ),
    );
  }

  /// Shows the app open ad if ready; otherwise triggers preload.
  void showAppOpenAdIfAvailable() {
    log('AdService: showAppOpenAdIfAvailable called, hasAd: ${_appOpenAd != null}, isShowing: $_isShowingAd, isFresh: $_isAdFresh');
    if (_isShowingAd) return;
    if (_appOpenAd == null) {
      log('AdService: No ad available, preloading...');
      _preloadIfNeeded(force: true);
      return;
    }
    if (!_isAdFresh) {
      log('AdService: Ad not fresh, disposing and preloading...');
      _appOpenAd?.dispose();
      _appOpenAd = null;
      _preloadIfNeeded(force: true);
      return;
    }

    log('AdService: Showing AppOpenAd');
    _appOpenAd?.show();
  }

  void _loadNativeAd() {
    log('AdService: Loading Native Ad with ID: $nativeAdUnitId (attempt ${_nativeAdRetryAttempt + 1}/$maxRetryAttempts)');
    
    // Dispose existing ad if any
    _nativeAd?.dispose();
    _nativeAd = null;
    _isNativeAdReady = false;
    
    final nativeAd = NativeAd(
      adUnitId: nativeAdUnitId,
      factoryId: Platform.isIOS ? 'listTile_ios' : 'listTile',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          log('AdService: Native Ad loaded successfully');
          _nativeAd = ad as NativeAd;
          _isNativeAdReady = true;
          _nativeAdRetryAttempt = 0; // Reset retry counter on success
        },
        onAdFailedToLoad: (ad, error) {
          log('AdService: Native Ad failed to load: $error');
          ad.dispose();
          _isNativeAdReady = false;
          
          // Retry with exponential backoff
          if (_nativeAdRetryAttempt < maxRetryAttempts) {
            _nativeAdRetryAttempt++;
            final retryDelay = Duration(
              seconds: (30 * _nativeAdRetryAttempt).clamp(30, 300),
            );
            log('AdService: Retrying Native Ad in ${retryDelay.inSeconds}s...');
            Future.delayed(retryDelay, _loadNativeAd);
          } else {
            log('AdService: Max retry attempts reached for Native Ad');
          }
        },
        onAdImpression: (ad) {
          log('AdService: Native Ad impression recorded');
        },
        onAdClicked: (ad) {
          log('AdService: Native Ad clicked');
        },
      ),
    );
    nativeAd.load();
  }

  /// Get the loaded native ad
  NativeAd? get nativeAd => _nativeAd;

  /// Check if native ad is ready
  bool get isNativeAdReady => _isNativeAdReady;

  /// Manually reload native ad (useful for testing)
  void reloadNativeAd() {
    log('AdService: Manual native ad reload requested');
    _nativeAdRetryAttempt = 0;
    _loadNativeAd();
  }

  /// Manually reload app open ad (useful for testing)
  void reloadAppOpenAd() {
    log('AdService: Manual app open ad reload requested');
    _appOpenAdRetryAttempt = 0;
    _appOpenAd?.dispose();
    _appOpenAd = null;
    _preloadIfNeeded(force: true);
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/ui/page/entrypoint/entrypoint_cubit.dart';

class WidgetNavigationService {
  static const MethodChannel _channel =
      MethodChannel('com.example.toeic_desktop/widget_navigation');

  static Future<void> initialize() async {
    // Set up method call handler for when app is already running
    _channel.setMethodCallHandler(_handleMethodCall);

    // Check for initial route when app is launched from widget
    await _checkInitialRoute();
  }

  static Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'navigateFromWidget':
        final data = Map<String, dynamic>.from(call.arguments);
        await _navigateToRoute(data);
        break;
    }
  }

  static Future<void> _checkInitialRoute() async {
    try {
      final result = await _channel.invokeMethod('getInitialRoute');
      if (result != null) {
        final data = Map<String, dynamic>.from(result);
        await _navigateToRoute(data);
      }
    } catch (e) {
      debugPrint('Error getting initial route: $e');
    }
  }

  static Future<void> _navigateToRoute(Map<String, dynamic> data) async {
    final route = data['route'] as String?;
    final tabIndex = data['tab_index'] as int?;

    if (route == null) return;

    // Wait a bit to ensure Flutter is ready
    await Future.delayed(const Duration(milliseconds: 100));

    final context = AppRouter.navigationKey.currentContext;
    if (context == null) return;

    try {
      // Navigate to the specified route
      switch (route) {
        case '/bottom-tab':
          // Navigate to bottom tab page
          GoRouter.of(context).goNamed(AppRouter.bottomTab);

          // If tab index is specified, switch to that tab
          if (tabIndex != null && tabIndex >= 0) {
            // Wait for the page to load then switch tab
            await Future.delayed(const Duration(milliseconds: 200));
            final entrypointCubit = injector<EntrypointCubit>();
            entrypointCubit.changeCurrentIndex(tabIndex);
          }
          break;

        case '/flash-card-detail':
          // Navigate to flash card detail page
          GoRouter.of(context).goNamed(AppRouter.bottomTab);
          await Future.delayed(const Duration(milliseconds: 200));
          final entrypointCubit = injector<EntrypointCubit>();
          entrypointCubit.changeCurrentIndex(2); // Flash cards tab (index 2)
          break;

        case '/practice-test':
          // Navigate to practice test
          GoRouter.of(context).goNamed(AppRouter.bottomTab);
          await Future.delayed(const Duration(milliseconds: 200));
          final entrypointCubit = injector<EntrypointCubit>();
          entrypointCubit.changeCurrentIndex(1); // Tests tab (index 1)
          break;

        default:
          // Default to bottom tab
          GoRouter.of(context).goNamed(AppRouter.bottomTab);
      }
    } catch (e) {
      debugPrint('Error navigating to route: $e');
      // Fallback to bottom tab
      GoRouter.of(context).goNamed(AppRouter.bottomTab);
    }
  }
}

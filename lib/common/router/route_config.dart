import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iscanner_app/ui/page/bottom_tab/bottom_tab.dart';
import 'package:iscanner_app/ui/page/reigster/register_page.dart';
import 'package:iscanner_app/ui/page/reset_password/reset_password_page.dart';

import '../../ui/page/splash/splash.dart';

class AppRouter {
  AppRouter._();

  static final navigationKey = GlobalKey<NavigatorState>();
  static final shellNavigationKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  static final GoRouter router = GoRouter(
    routes: _routes,
    debugLogDiagnostics: true,
    navigatorKey: navigationKey,
  );

  ///main page
  static const String splash = "/";
  static const String bottomTab = "/bottom-tab";
  static const String login = "/login";
  static const String register = "/register";
  static const String resetPassword = "/reset-password";

  // GoRouter configuration
  static final _routes = <RouteBase>[
    GoRoute(
      name: splash,
      path: splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      name: bottomTab,
      path: bottomTab,
      builder: (context, state) => const BottomTabPage(),
    ),
    GoRoute(
      name: register,
      path: register,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      name: resetPassword,
      path: resetPassword,
      builder: (context, state) => const ResetPasswordPage(),
    ),
  ];
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/ui/page/bottom_tab/bottom_tab.dart';
import 'package:toeic_desktop/ui/page/home/home_page.dart';
import 'package:toeic_desktop/ui/page/login/login_page.dart';
import 'package:toeic_desktop/ui/page/reigster/register_page.dart';
import 'package:toeic_desktop/ui/page/reset_password/reset_password_page.dart';

import '../../ui/page/splash/splash.dart';

class AppRouter {
  AppRouter._();

  static final navigationKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
      routes: _routes,
      debugLogDiagnostics: true,
      navigatorKey: navigationKey,
      initialLocation: splash);

  ///main page
  static const String splash = "/";
  // Auth routes
  static const String login = "/login";
  static const String register = "/register";
  static const String resetPassword = "/reset-password";
  // App routes
  static const String home = "/home";
  static const String practiceTest = "/practice-test";
  static const String toeicFullExam = "/toeic-full-exam";
  static const String resources = "/resources";
  static const String contact = "/contact";
  static const String about = "/about";

  // GoRouter configuration
  static final _routes = <RouteBase>[
    GoRoute(
      name: splash,
      path: splash,
      builder: (context, state) => const SplashPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => BottomTabPage(
        navigationShell: navigationShell,
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: home,
              path: home,
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: about,
              path: about,
              builder: (context, state) => const Center(
                child: Text('About'),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: resources,
              path: resources,
              builder: (context, state) => const Center(
                child: Text('Resources'),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: practiceTest,
              path: practiceTest,
              builder: (context, state) => const Center(
                child: Text('Practice Test'),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: contact,
              path: contact,
              builder: (context, state) => const Center(
                child: Text('Contact'),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: toeicFullExam,
              path: toeicFullExam,
              builder: (context, state) => const Center(
                child: Text('Toeic Full Exam'),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: login,
              path: login,
              builder: (context, state) => const LoginPage(),
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
          ],
        ),
        // StatefulShellBranch(
        //   routes: [
        //     GoRoute(
        //       name: register,
        //       path: register,
        //       builder: (context, state) => const RegisterPage(),
        //     ),
        //   ],
        // ),
        // StatefulShellBranch(
        //   routes: [
        //     GoRoute(
        //       name: resetPassword,
        //       path: resetPassword,
        //       builder: (context, state) => const ResetPasswordPage(),
        //     ),
        //   ],
        // ),
      ],
    ),
  ];
}

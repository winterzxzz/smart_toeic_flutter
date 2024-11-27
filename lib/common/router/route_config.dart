import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/data/models/ui_models/result_model.dart';
import 'package:toeic_desktop/ui/page/blog/blog.dart';
import 'package:toeic_desktop/ui/page/bottom_tab/bottom_tab.dart';
import 'package:toeic_desktop/ui/page/de_thi_online/de_thi_online_page.dart';
import 'package:toeic_desktop/ui/page/flash_card_detail/flash_card_detail.dart';
import 'package:toeic_desktop/ui/page/flash_card_practice/flash_card_practice.dart';
import 'package:toeic_desktop/ui/page/flashcard/flash_card.dart';
import 'package:toeic_desktop/ui/page/home/home_page.dart';
import 'package:toeic_desktop/ui/page/kich_hoat_tai_khoan/kich_hoat_tai_khoan.dart';
import 'package:toeic_desktop/ui/page/login/login_page.dart';
import 'package:toeic_desktop/ui/page/practice_test/practice_test.dart';
import 'package:toeic_desktop/ui/page/quizz/quizz_page.dart';
import 'package:toeic_desktop/ui/page/reigster/register_page.dart';
import 'package:toeic_desktop/ui/page/reset_password/reset_password_page.dart';
import 'package:toeic_desktop/ui/page/mode_test/mode_test_page.dart';
import 'package:toeic_desktop/ui/page/result_test/result_test_page.dart';

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
  static const String gioiThieu = "/gioi-thieu";
  static const String deThiOnline = "/de-thi-online";
  static const String flashCards = "/flash-cards";
  static const String blog = "/blog";
  static const String kichHoatTaiKhoan = "/kich-hoat-tai-khoan";
  static const String flashCardDetail = "/flash-card-detail";
  static const String flashCardPractive = "/flash-card-practive";
  static const String modeTest = "/mode-test";
  static const String practiceTest = "/practice-test";
  static const String quizz = "/quizz";
  static const String resultTest = "/result-test";

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
              name: gioiThieu,
              path: gioiThieu,
              builder: (context, state) => const Center(
                child: Text('Giới thiệu'),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: deThiOnline,
              path: deThiOnline,
              builder: (context, state) => const SimulationTestScreen(),
            ),
            GoRoute(
              name: modeTest,
              path: modeTest,
              builder: (context, state) => const ModeTestpage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: flashCards,
              path: flashCards,
              builder: (context, state) => const FlashCardPage(),
            ),
            GoRoute(
              name: flashCardDetail,
              path: flashCardDetail,
              builder: (context, state) => FlashCardDetailPage(),
            ),
            GoRoute(
              name: flashCardPractive,
              path: flashCardPractive,
              builder: (context, state) => const FlashCardPracticePage(),
            ),
            GoRoute(
              name: quizz,
              path: quizz,
              builder: (context, state) => const QuizzPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: blog,
              path: blog,
              builder: (context, state) => const BlogPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: kichHoatTaiKhoan,
              path: kichHoatTaiKhoan,
              builder: (context, state) => const PricingPlanScreen(),
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
      ],
    ),
    GoRoute(
      name: practiceTest,
      path: practiceTest,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        final parts = args['parts'] as List<PartEnum>;
        final duration = args['duration'] as Duration;
        return PracticeTestPage(parts: parts, duration: duration);
      },
    ),
    GoRoute(
      name: resultTest,
      path: resultTest,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        final resultModel = args['resultModel'] as ResultModel;
        return ResultTestPage(resultModel: resultModel);
      },
    ),
  ];
}

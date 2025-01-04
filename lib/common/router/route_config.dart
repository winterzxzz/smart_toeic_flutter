import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/setting/app_setting_cubit.dart';
import 'package:toeic_desktop/data/database/share_preferences_helper.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/set_flash_card/set_flash_card_learning.dart';
import 'package:toeic_desktop/data/models/entities/test/test.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/data/models/enums/test_show.dart';
import 'package:toeic_desktop/data/models/request/flash_card_quizz_score_request.dart';
import 'package:toeic_desktop/data/models/ui_models/payment_return.dart';
import 'package:toeic_desktop/data/models/ui_models/result_model.dart';
import 'package:toeic_desktop/ui/page/analysis/analysis_page.dart';
import 'package:toeic_desktop/ui/page/blog/blog_page.dart';
import 'package:toeic_desktop/ui/page/bottom_tab/bottom_tab.dart';
import 'package:toeic_desktop/ui/page/flash_card_learning_detail/flash_card_detail_learning_page.dart';
import 'package:toeic_desktop/ui/page/history_test/history_test_page.dart';
import 'package:toeic_desktop/ui/page/introduction/introduction_page.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_page.dart';
import 'package:toeic_desktop/ui/page/transcript_test_set/listen_copy_page.dart';
import 'package:toeic_desktop/ui/page/profile/profile_page.dart';
import 'package:toeic_desktop/ui/page/setting/setting_page.dart';
import 'package:toeic_desktop/ui/page/test_online/test_online_page.dart';
import 'package:toeic_desktop/ui/page/flash_card_detail/flash_card_detail_page.dart';
import 'package:toeic_desktop/ui/page/flash_card_learn_flip/flash_card_practice.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/flash_card_quizz_result.dart';
import 'package:toeic_desktop/ui/page/set_flashcard/set_flash_card_page.dart';
import 'package:toeic_desktop/ui/page/home/home_page.dart';
import 'package:toeic_desktop/ui/page/upgrade_account/upgrade_account_page.dart';
import 'package:toeic_desktop/ui/page/login/login_page.dart';
import 'package:toeic_desktop/ui/page/practice_test/practice_test_page.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/flash_card_quizz_page.dart';
import 'package:toeic_desktop/ui/page/reigster/register_page.dart';
import 'package:toeic_desktop/ui/page/reset_password/reset_password_page.dart';
import 'package:toeic_desktop/ui/page/mode_test/mode_test_page.dart';
import 'package:toeic_desktop/ui/page/result_test/result_test_page.dart';
import 'package:toeic_desktop/ui/page/check_payment_status/check_payment_status_page.dart';

import '../../ui/page/splash/splash.dart';

class AppRouter {
  AppRouter._();

  static final navigationKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
      routes: _routes,
      debugLogDiagnostics: true,
      navigatorKey: navigationKey,
      redirect: (context, state) {
        final isLogin = SharedPreferencesHelper().getCookies() != null;
        if (!isLogin) {
          if (state.uri.path == onlineTest ||
              state.uri.path == flashCards ||
              state.uri.path == modeTest ||
              state.uri.path == profile ||
              state.uri.path == upgradeAccount) {
            return login;
          }
          injector<AppSettingCubit>()
              .addNavigationHistory(path: state.uri.path);

          return null;
        }
        injector<AppSettingCubit>().addNavigationHistory(path: state.uri.path);
        return null;
      },
      initialLocation: splash);

  ///main page
  static const String splash = "/";
  // Auth routes
  static const String login = "/login";
  static const String register = "/register";
  static const String resetPassword = "/reset-password";
  // App routes
  static const String home = "/home";
  static const String introduction = "/introduction";
  static const String onlineTest = "/online-test";
  static const String flashCards = "/flash-cards";
  static const String blog = "/blog";
  static const String upgradeAccount = "/upgrade-account";
  static const String flashCardDetail = "/flash-card-detail";
  static const String flashCardLearningDetail = "/flash-card-learning-detail";
  static const String flashCardPractive = "/flash-card-practive";
  static const String modeTest = "/mode-test";
  static const String practiceTest = "/practice-test";
  static const String flashCardQuizz = "/flash-card-quizz";
  static const String flashCardQuizzResult = "/flash-card-quizz-result";
  static const String resultTest = "/result-test";
  static const String profile = "/profile";
  static const String setting = "/setting";
  static const String analysis = "/analysis";
  static const String upgradeAccountSuccess = "/upgrade-account-success";
  static const String transcriptTest = "/transcript-test";
  static const String transcriptTestDetail = "/transcript-test-detail";
  static const String historyTest = "/history-test";

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
              name: introduction,
              path: introduction,
              builder: (context, state) => IntroductionPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: onlineTest,
              path: onlineTest,
              builder: (context, state) => const SimulationTestScreen(),
            ),
            GoRoute(
              name: modeTest,
              path: modeTest,
              builder: (context, state) {
                final args = state.extra as Map<String, dynamic>;
                final test = args['test'] as Test;
                return ModeTestpage(test: test);
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: flashCards,
              path: flashCards,
              builder: (context, state) => const SetFlashCardPage(),
            ),
            GoRoute(
              name: flashCardDetail,
              path: flashCardDetail,
              builder: (context, state) {
                final args = state.extra as Map<String, dynamic>;
                final setId = args['setId'] as String;
                final title = args['title'] as String;
                return FlashCardDetailPage(setId: setId, title: title);
              },
            ),
            GoRoute(
              name: flashCardLearningDetail,
              path: flashCardLearningDetail,
              builder: (context, state) {
                final args = state.extra as Map<String, dynamic>;
                final setFlashCardLearning =
                    args['setFlashCardLearning'] as SetFlashCardLearning;
                return FlashCardDetailLearningPage(
                  setFlashCardLearning: setFlashCardLearning,
                );
              },
            ),
            GoRoute(
              name: flashCardPractive,
              path: flashCardPractive,
              builder: (context, state) {
                final args = state.extra as Map<String, dynamic>;
                final title = args['title'] as String;
                final flashCards = args['flashCards'] as List<FlashCard>;
                return FlashCardPracticePage(
                  title: title,
                  flashCards: flashCards,
                );
              },
            ),
            GoRoute(
              name: flashCardQuizz,
              path: flashCardQuizz,
              builder: (context, state) {
                final args = state.extra as Map<String, dynamic>;
                final id = args['id'] as String;
                return FlashCardQuizPage(
                  id: id,
                );
              },
            ),
            GoRoute(
              name: flashCardQuizzResult,
              path: flashCardQuizzResult,
              builder: (context, state) {
                final args = state.extra as Map<String, dynamic>;
                final flashCardQuizzScoreRequest =
                    args['flashCardQuizzScoreRequest']
                        as List<FlashCardQuizzScoreRequest>;
                return FlashCardQuizResultPage(
                  flashCardQuizzScoreRequest: flashCardQuizzScoreRequest,
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: transcriptTest,
              path: transcriptTest,
              builder: (context, state) => const ListenCopyPage(),
            ),
            GoRoute(
              name: transcriptTestDetail,
              path: transcriptTestDetail,
              builder: (context, state) {
                final args = state.extra as Map<String, dynamic>;
                final transcriptTestId = args['transcriptTestId'] as String;
                return TranscriptTestDetailPage(
                    transcriptTestId: transcriptTestId);
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: blog,
              path: blog,
              builder: (context, state) {
                final args = state.extra as Map<String, dynamic>?;
                final blogId = args?['blogId'] as String?;
                return BlogPage(blogId: blogId);
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: upgradeAccount,
              path: upgradeAccount,
              builder: (context, state) => const PricingPlanScreen(),
            ),
            GoRoute(
              name: upgradeAccountSuccess,
              path: upgradeAccountSuccess,
              builder: (context, state) {
                final args = state.extra as Map<String, dynamic>;
                final paymentReturn = args['paymentReturn'] as PaymentReturn;
                return UpgradeAccountSuccessPage(paymentReturn: paymentReturn);
              },
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
              name: profile,
              path: profile,
              builder: (context, state) => const ProfilePage(),
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
            GoRoute(
              name: analysis,
              path: analysis,
              builder: (context, state) => const AnalysisPage(),
            ),
            GoRoute(
              name: historyTest,
              path: historyTest,
              builder: (context, state) => const HistoryTestPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: setting,
              path: setting,
              builder: (context, state) => const SettingPage(),
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
        final testShow = args['testShow'] as TestShow;
        final parts = args['parts'] as List<PartEnum>;
        final duration = args['duration'] as Duration;
        final testId = args['testId'] as String;
        final resultId = args['resultId'] as String?;
        return PracticeTestPage(
            testShow: testShow,
            parts: parts,
            duration: duration,
            testId: testId,
            resultId: resultId);
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

  static void clearAndNavigate(String path) {
    while (AppRouter.router.canPop() == true) {
      AppRouter.router.pop();
    }
    AppRouter.router.pushReplacement(path);
  }
}

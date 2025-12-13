import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/data/database/share_preferences_helper.dart';
import 'package:toeic_desktop/data/models/entities/blog/blog.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/set_flash_card/set_flash_card_learning.dart';
import 'package:toeic_desktop/data/models/entities/test/test.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/data/models/enums/test_show.dart';
import 'package:toeic_desktop/data/models/request/flash_card_quizz_score_request.dart';
import 'package:toeic_desktop/data/models/ui_models/payment_return.dart';
import 'package:toeic_desktop/data/models/ui_models/result_model.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_learn_flip/flash_card_learn_flip_page.dart';
import 'package:toeic_desktop/ui/page/image_view/image_view_page.dart';
import 'package:toeic_desktop/ui/page/personal_analysis/analysis_page.dart';
import 'package:toeic_desktop/ui/page/blog_detail/blog_detail_page.dart';
import 'package:toeic_desktop/ui/page/entrypoint/entrypoint_page.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_learning_detail/flash_card_detail_learning_page.dart';
import 'package:toeic_desktop/ui/page/test/history_test/history_test_page.dart';
import 'package:toeic_desktop/ui/page/onboarding/onboarding_page.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_page.dart';
import 'package:toeic_desktop/ui/page/transcript_test_set/listen_copy_page.dart';
import 'package:toeic_desktop/ui/page/setting/setting_page.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_detail/flash_card_detail_page.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_quizz/flash_card_quizz_result.dart';
import 'package:toeic_desktop/ui/page/upgrade_account/upgrade_account_page.dart';
import 'package:toeic_desktop/ui/page/login/login_page.dart';
import 'package:toeic_desktop/ui/page/test/practice_test/practice_test_page.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_quizz/flash_card_quizz_page.dart';
import 'package:toeic_desktop/ui/page/reigster/register_page.dart';
import 'package:toeic_desktop/ui/page/reset_password/reset_password_page.dart';
import 'package:toeic_desktop/ui/page/test/choose_mode_test/mode_test_page.dart';
import 'package:toeic_desktop/ui/page/test/result_test/result_test_page.dart';
import 'package:toeic_desktop/ui/page/check_payment_status/check_payment_status_page.dart';
import 'package:toeic_desktop/ui/page/certificates/certificates_page.dart';
import 'package:toeic_desktop/ui/page/chat_ai/chat_ai_page.dart';

import '../../ui/page/splash/splash_page.dart';

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
          if (state.uri.path != splash &&
              state.uri.path != login &&
              state.uri.path != register &&
              state.uri.path != resetPassword &&
              state.uri.path != onboarding) {
            return login;
          }
          return null;
        }
        return null;
      },
      initialLocation: splash);

  ///main page
  static const String splash = "/";
  // Auth routes
  static const String login = "/login";
  static const String register = "/register";
  static const String resetPassword = "/reset-password";
  static const String onboarding = "/onboarding";
  // App routes
  static const String bottomTab = "/bottom-tab";
  static const String introduction = "/introduction";
  static const String upgradeAccount = "/upgrade-account";
  static const String flashCardDetail = "/flash-card-detail";
  static const String flashCardLearningDetail = "/flash-card-learning-detail";
  static const String flashCardLearnFlip = "/flash-card-learn-flip";
  static const String modeTest = "/mode-test";
  static const String practiceTest = "/practice-test";
  static const String flashCardQuizz = "/flash-card-quizz";
  static const String flashCardQuizzResult = "/flash-card-quizz-result";
  static const String resultTest = "/result-test";
  static const String setting = "/setting";
  static const String analysis = "/analysis";
  static const String upgradeAccountSuccess = "/upgrade-account-success";
  static const String transcriptTest = "/transcript-test";
  static const String transcriptTestDetail = "/transcript-test-detail";
  static const String historyTest = "/history-test";
  static const String blogDetail = "/blog-detail";
  static const String certificates = "/certificates";
  static const String imageView = "/image-view";
  static const String rooms = '/rooms';
  static const String liveStream = '/live-stream';
  static const String prepareLive = '/prepare-live';
  static const String liveObjectDetection = '/live-object-detection';
  static const String chatAi = '/chat-ai';

  // GoRouter configuration
  static final _routes = <RouteBase>[
    GoRoute(
      name: splash,
      path: splash,
      builder: (context, state) => const SplashPage(),
    ),
    // Auth routes
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
    GoRoute(
      name: onboarding,
      path: onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),
    // Nested routes
    GoRoute(
        name: bottomTab,
        path: bottomTab,
        builder: (context, state) => const BottomTabPage(),
        routes: [
          GoRoute(
            name: upgradeAccountSuccess,
            path: upgradeAccountSuccess,
            builder: (context, state) {
              final params = state.uri.queryParameters;
              final payment = PaymentReturn(
                amount: params['amount'] ?? '',
                appid: params['appid'] ?? '',
                apptransid: params['apptransid'] ?? '',
                bankcode: params['bankcode'] ?? '',
                checksum: params['checksum'] ?? '',
                discountamount: params['discountamount'] ?? '',
                pmcid: params['pmcid'] ?? '',
                status: params['status'] ?? '',
              );
              return UpgradeAccountSuccessPage(payment: payment);
            },
          ),
        ]),
    GoRoute(
      name: transcriptTest,
      path: transcriptTest,
      builder: (context, state) => const ListenCopyPage(),
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
      name: flashCardLearnFlip,
      path: flashCardLearnFlip,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        final title = args['title'] as String;
        final flashCards = args['flashCards'] as List<FlashCard>;
        return FlashCardLearnFlipPage(
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
        final flashCardQuizzScoreRequest = args['flashCardQuizzScoreRequest']
            as List<FlashCardQuizzScoreRequest>;
        return FlashCardQuizResultPage(
          flashCardQuizzScoreRequest: flashCardQuizzScoreRequest,
        );
      },
    ),
    GoRoute(
      name: practiceTest,
      path: practiceTest,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        final practiceTestArgs = PracticeTestArgs(
          title: (args?['title'] ?? '') as String,
          testShow: (args?['testShow'] ?? TestShow.test) as TestShow,
          parts: (args?['parts'] ?? <PartEnum>[]) as List<PartEnum>,
          duration: (args?['duration'] ?? Duration.zero) as Duration,
          testId: (args?['testId'] ?? '') as String,
          resultId: (args?['resultId'] ?? '') as String?,
        );
        return PracticeTestPage(args: practiceTestArgs);
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
    GoRoute(
      name: upgradeAccount,
      path: upgradeAccount,
      builder: (context, state) => const PricingPlanScreen(),
    ),
    GoRoute(
      name: transcriptTestDetail,
      path: transcriptTestDetail,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        final transcriptTestId = args['transcriptTestId'] as String;
        final title = args['title'] as String;
        return TranscriptTestDetailPage(
          transcriptTestId: transcriptTestId,
          title: title,
        );
      },
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
    GoRoute(
      name: setting,
      path: setting,
      builder: (context, state) => const SettingPage(),
    ),
    GoRoute(
      name: blogDetail,
      path: blogDetail,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        final blog = args['blog'] as Blog;
        return BlogDetail(blog: blog);
      },
    ),
    GoRoute(
      name: certificates,
      path: certificates,
      builder: (context, state) => const CertificatesPage(),
    ),
    GoRoute(
      name: imageView,
      path: imageView,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        final imageUrl = args['imageUrl'] as String;
        return ImagePreview(imageUrl: imageUrl);
      },
    ),
    GoRoute(
      name: chatAi,
      path: chatAi,
      builder: (context, state) => const ChatAiPage(),
    ),
  ];

  static void clearAndNavigate(String path) {
    while (AppRouter.router.canPop() == true) {
      AppRouter.router.pop();
    }
    AppRouter.router.goNamed(path);
  }
}

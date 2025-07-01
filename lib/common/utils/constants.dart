import 'dart:math';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/data/models/ui_models/bottom_tab.dart';
import 'package:toeic_desktop/data/models/ui_models/home_item_task_model.dart';
import 'package:toeic_desktop/data/models/ui_models/part_model.dart';
import 'package:toeic_desktop/data/models/ui_models/service_item.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_images.dart';
import 'package:toeic_desktop/ui/page/entrypoint/entrypoint_cubit.dart';

class Constants {
  static List<ServiceItem> get services => [
        ServiceItem(
            icon: FontAwesomeIcons.robot,
            title: S.current.ai_render,
            desciption: S.current.ai_render_description),
        ServiceItem(
            icon: FontAwesomeIcons.idCard,
            title: S.current.flashcards,
            desciption: S.current.flashcards_description),
        ServiceItem(
            icon: FontAwesomeIcons.list,
            title: S.current.practice_exams,
            desciption: S.current.practice_exams_description),
        ServiceItem(
            icon: FontAwesomeIcons.chartLine,
            title: S.current.result_analysis,
            desciption: S.current.result_analysis_description),
      ];

  static List<String> timeLimit = [
    '-- Select time --',
    '1 minute',
    '10 minutes',
    '20 minutes',
    '30 minutes',
    '40 minutes',
    '50 minutes',
    '60 minutes',
    '120 minutes',
    'No limit',
  ];

  static List<PartModel> get parts => [
        PartModel(
          partEnum: PartEnum.part1,
          numberOfQuestions: 6,
          tags: [
            S.current.photographs,
            S.current.identify_actions,
            S.current.describe_scenes,
          ],
        ),
        PartModel(
          partEnum: PartEnum.part2,
          numberOfQuestions: 25,
          tags: [
            S.current.question_response,
            S.current.short_answers,
            S.current.yes_no_questions,
            S.current.wh_questions,
          ],
        ),
        PartModel(
          partEnum: PartEnum.part3,
          numberOfQuestions: 39,
          tags: [
            S.current.conversations,
            S.current.multiple_speakers,
            S.current.purpose,
            S.current.details,
            S.current.inference,
            S.current.speaker_attitude,
            S.current.chart_visual_reference,
          ],
        ),
        PartModel(
          partEnum: PartEnum.part4,
          numberOfQuestions: 30,
          tags: [
            S.current.talks,
            S.current.single_speaker,
            S.current.main_idea,
            S.current.details,
            S.current.charts_visuals,
            S.current.inference,
          ],
        ),
        PartModel(
          partEnum: PartEnum.part5,
          numberOfQuestions: 30,
          tags: [
            S.current.incomplete_sentences,
            S.current.grammar,
            S.current.vocabulary,
          ],
        ),
        PartModel(
          partEnum: PartEnum.part6,
          numberOfQuestions: 16,
          tags: [
            S.current.text_completion,
            S.current.passages,
            S.current.cohesion,
            S.current.grammar,
            S.current.vocabulary,
          ],
        ),
        PartModel(
          partEnum: PartEnum.part7,
          numberOfQuestions: 54,
          tags: [
            S.current.reading_comprehension,
            S.current.single_passage,
            S.current.double_passage,
            S.current.triple_passage,
            S.current.main_idea,
            S.current.details,
            S.current.inference,
          ],
        ),
      ];

  static List<BottomTabModel> get bottomTabs => [
        BottomTabModel(
          title: S.current.home,
          iconFill: AppImages.icHomeFill,
          iconOutline: AppImages.icHomeOutline,
        ),
        BottomTabModel(
          title: S.current.test_practice,
          iconFill: AppImages.icTestFill,
          iconOutline: AppImages.icTestOutline,
        ),
        BottomTabModel(
          title: S.current.flashcards,
          iconFill: AppImages.icFlashCardFill,
          iconOutline: AppImages.icFlashCardOutline,
        ),
        BottomTabModel(
          title: S.current.blog,
          iconFill: AppImages.icBlogFill,
          iconOutline: AppImages.icBlogOutline,
        ),
        BottomTabModel(
          title: S.current.account,
          iconFill: AppImages.icAccountFill,
          iconOutline: AppImages.icAccountOutline,
        ),
      ];

  static List<HomeItemTaskModel> get homePracticeTasks => [
        HomeItemTaskModel(
          title: S.current.listening,
          image: AppImages.icListenCopy,
          progress: Random().nextDouble(),
          onNavigate: (context) =>
              GoRouter.of(context).push(AppRouter.transcriptTest),
        ),
        HomeItemTaskModel(
          title: S.current.test,
          image: AppImages.icTestOutline,
          progress: Random().nextDouble(),
          onTap: () => injector<EntrypointCubit>().changeCurrentIndex(1),
        ),
      ];

  static List<HomeItemTaskModel> get homeExamPreparationTasks => [
        HomeItemTaskModel(
          title: S.current.test_online,
          image: AppImages.icTestOutline,
          onTap: () => injector<EntrypointCubit>().changeCurrentIndex(1),
        ),
        HomeItemTaskModel(
          title: S.current.blogs,
          image: AppImages.icBlog,
          onTap: () => injector<EntrypointCubit>().changeCurrentIndex(3),
        ),
        HomeItemTaskModel(
          title: S.current.flashcards,
          image: AppImages.icFlashCardOutline,
          onTap: () => injector<EntrypointCubit>().changeCurrentIndex(2),
        ),
        HomeItemTaskModel(
          title: S.current.premium,
          image: AppImages.icPremium,
          onNavigate: (context) =>
              GoRouter.of(context).push(AppRouter.upgradeAccount),
        ),
        HomeItemTaskModel(
          title: S.current.settings,
          image: AppImages.icSetting,
          onNavigate: (context) => GoRouter.of(context).push(AppRouter.setting),
        ),
        HomeItemTaskModel(
          title: 'Web3 Test',
          image: AppImages.icSetting,
          onNavigate: (context) =>
              GoRouter.of(context).push(AppRouter.web3Test),
        ),
      ];

  static List<String> get primaryColorsHex => [
        '26A69A',
        'EF5350',
        '3498db',
        'F06292',
        '9575CD',
        '26C6DA',
        'FFF176',
        'FF9800',
      ];

  static List<String> get reminderWordAfterTimes => [
        '15 minutes',
        '30 minutes',
        '45 minutes',
        '60 minutes',
        '2 hours',
        '4 hours',
        '8 hours',
        '12 hours',
        '24 hours',
      ];

  static Map<int, int> listeningScore = {
    0: 5,
    1: 5,
    2: 5,
    3: 5,
    4: 5,
    5: 5,
    6: 5,
    7: 5,
    8: 5,
    9: 5,
    10: 10,
    11: 15,
    12: 20,
    13: 25,
    14: 30,
    15: 35,
    16: 40,
    17: 45,
    18: 50,
    19: 55,
    20: 60,
    21: 65,
    22: 70,
    23: 75,
    24: 80,
    25: 85,
    26: 90,
    27: 95,
    28: 100,
    29: 105,
    30: 110,
    31: 115,
    32: 120,
    33: 125,
    34: 130,
    35: 135,
    36: 140,
    37: 145,
    38: 150,
    39: 155,
    40: 160,
    41: 165,
    42: 170,
    43: 175,
    44: 180,
    45: 185,
    46: 190,
    47: 195,
    48: 200,
    49: 205,
    50: 210,
    51: 215,
    52: 220,
    53: 225,
    54: 230,
    55: 235,
    56: 240,
    57: 245,
    58: 250,
    59: 255,
    60: 260,
    61: 265,
    62: 270,
    63: 275,
    64: 280,
    65: 285,
    66: 290,
    67: 295,
    68: 300,
    69: 305,
    70: 310,
    71: 315,
    72: 320,
    73: 325,
    74: 330,
    75: 335,
    76: 340,
    77: 345,
    78: 350,
    79: 355,
    80: 360,
    81: 365,
    82: 370,
    83: 375,
    84: 380,
    85: 385,
    86: 390,
    87: 395,
    88: 400,
    89: 405,
    90: 410,
    91: 415,
    92: 420,
    93: 425,
    94: 430,
    95: 435,
    96: 440,
    97: 445,
    98: 450,
    99: 455,
    100: 495,
  };

  static Map<int, int> readingScore = {
    0: 5,
    1: 5,
    2: 5,
    3: 5,
    4: 5,
    5: 5,
    6: 5,
    7: 5,
    8: 5,
    9: 5,
    10: 10,
    11: 10,
    12: 15,
    13: 20,
    14: 25,
    15: 30,
    16: 35,
    17: 40,
    18: 45,
    19: 50,
    20: 55,
    21: 60,
    22: 65,
    23: 70,
    24: 75,
    25: 80,
    26: 85,
    27: 90,
    28: 95,
    29: 100,
    30: 105,
    31: 110,
    32: 115,
    33: 120,
    34: 125,
    35: 130,
    36: 135,
    37: 140,
    38: 145,
    39: 150,
    40: 155,
    41: 160,
    42: 165,
    43: 170,
    44: 175,
    45: 180,
    46: 185,
    47: 190,
    48: 195,
    49: 200,
    50: 205,
    51: 210,
    52: 215,
    53: 220,
    54: 225,
    55: 230,
    56: 235,
    57: 240,
    58: 245,
    59: 250,
    60: 255,
    61: 260,
    62: 265,
    63: 270,
    64: 275,
    65: 280,
    66: 285,
    67: 290,
    68: 295,
    69: 300,
    70: 305,
    71: 310,
    72: 315,
    73: 320,
    74: 325,
    75: 330,
    76: 335,
    77: 340,
    78: 345,
    79: 350,
    80: 355,
    81: 360,
    82: 365,
    83: 370,
    84: 375,
    85: 380,
    86: 385,
    87: 390,
    88: 395,
    89: 400,
    90: 405,
    91: 410,
    92: 415,
    93: 420,
    94: 425,
    95: 430,
    96: 435,
    97: 440,
    98: 445,
    99: 450,
    100: 455,
  };
}

extension ConstantsExtension on Constants {
  static Duration getTimeLimit(String time) {
    switch (time) {
      case '1 minute':
        return const Duration(minutes: 1);
      case '10 minutes':
        return const Duration(minutes: 10);
      case '20 minutes':
        return const Duration(minutes: 20);
      case '30 minutes':
        return const Duration(minutes: 30);
      case '40 minutes':
        return const Duration(minutes: 40);
      case '50 minutes':
        return const Duration(minutes: 50);
      case '60 minutes':
        return const Duration(minutes: 60);
      case '120 minutes':
        return const Duration(minutes: 120);
      case 'No limit':
        return const Duration(minutes: 00);
      default:
        return const Duration(minutes: 120);
    }
  }
}

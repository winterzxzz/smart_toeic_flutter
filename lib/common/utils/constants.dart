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
      ];
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

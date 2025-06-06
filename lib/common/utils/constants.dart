import 'dart:math';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/data/models/ui_models/blog_item.dart';
import 'package:toeic_desktop/data/models/ui_models/bottom_tab.dart';
import 'package:toeic_desktop/data/models/ui_models/home_item_task_model.dart';
import 'package:toeic_desktop/data/models/ui_models/part_model.dart';
import 'package:toeic_desktop/data/models/ui_models/service_item.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_images.dart';
import 'package:toeic_desktop/ui/page/entrypoint/entrypoint_cubit.dart';

class Constants {
  static List<BlogItem> blogs = [
    BlogItem(
        imageUrl:
            'https://kenh14cdn.com/203336854389633024/2023/4/30/photo1682772628140-16827726282301463572662-16828396997672050284284.jpeg',
        title: 'Node.js Best Practices',
        description:
            'Create websites that look great on any device with these responsive design techniques.',
        countComments: 12,
        countViews: 1290,
        date: '2024-07-12'),
    BlogItem(
        imageUrl:
            'https://kenh14cdn.com/203336854389633024/2023/4/30/photo1682772628140-16827726282301463572662-16828396997672050284284.jpeg',
        title: 'Node.js Best Practices',
        description:
            'Create websites that look great on any device with these responsive design techniques.',
        countComments: 12,
        countViews: 1290,
        date: '2024-07-12'),
    BlogItem(
        imageUrl:
            'https://kenh14cdn.com/203336854389633024/2023/4/30/photo1682772628140-16827726282301463572662-16828396997672050284284.jpeg',
        title: 'Node.js Best Practices',
        description:
            'Create websites that look great on any device with these responsive design techniques.',
        countComments: 12,
        countViews: 1290,
        date: '2024-07-12'),
    BlogItem(
        imageUrl:
            'https://kenh14cdn.com/203336854389633024/2023/4/30/photo1682772628140-16827726282301463572662-16828396997672050284284.jpeg',
        title: 'Node.js Best Practices',
        description:
            'Create websites that look great on any device with these responsive design techniques.',
        countComments: 12,
        countViews: 1290,
        date: '2024-07-12'),
  ];

  static List<ServiceItem> services = [
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

  static List<PartModel> parts = [
    PartModel(
      partEnum: PartEnum.part1,
      numberOfQuestions: 6,
      tags: [
        "Photographs",
        "Identify actions",
        "Describe scenes",
      ],
    ),
    PartModel(
      partEnum: PartEnum.part2,
      numberOfQuestions: 25,
      tags: [
        "Question-Response",
        "Short answers",
        "Yes/No questions",
        "Wh- questions",
      ],
    ),
    PartModel(
      partEnum: PartEnum.part3,
      numberOfQuestions: 39,
      tags: [
        "Conversations",
        "Multiple speakers",
        "Purpose",
        "Detail",
        "Inference",
        "Speaker's attitude",
        "Chart/Visual reference",
      ],
    ),
    PartModel(
      partEnum: PartEnum.part4,
      numberOfQuestions: 30,
      tags: [
        "Talks",
        "Single speaker",
        "Main idea",
        "Details",
        "Charts/Visuals",
        "Inference",
      ],
    ),
    PartModel(
      partEnum: PartEnum.part5,
      numberOfQuestions: 30,
      tags: [
        "Incomplete Sentences",
        "Grammar",
        "Vocabulary",
      ],
    ),
    PartModel(
      partEnum: PartEnum.part6,
      numberOfQuestions: 16,
      tags: [
        "Text Completion",
        "Passages",
        "Cohesion",
        "Grammar",
        "Vocabulary",
      ],
    ),
    PartModel(
      partEnum: PartEnum.part7,
      numberOfQuestions: 54,
      tags: [
        "Reading Comprehension",
        "Single passage",
        "Double passage",
        "Triple passage",
        "Main idea",
        "Details",
        "Inference",
      ],
    ),
  ];

  static List<BottomTabModel> bottomTabs = [
    BottomTabModel(
      title: 'Home',
      iconFill: AppImages.icHomeFill,
      iconOutline: AppImages.icHomeOutline,
    ),
    BottomTabModel(
      title: 'Test Practice',
      iconFill: AppImages.icTestFill,
      iconOutline: AppImages.icTestOutline,
    ),
    BottomTabModel(
      title: 'Flashcards',
      iconFill: AppImages.icFlashCardFill,
      iconOutline: AppImages.icFlashCardOutline,
    ),
    BottomTabModel(
      title: 'Blog',
      iconFill: AppImages.icBlogFill,
      iconOutline: AppImages.icBlogOutline,
    ),
    BottomTabModel(
      title: 'Account',
      iconFill: AppImages.icAccountFill,
      iconOutline: AppImages.icAccountOutline,
    ),
  ];

  static List<HomeItemTaskModel> homePracticeTasks = [
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

  static List<HomeItemTaskModel> homeExamPreparationTasks = [
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

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/data/models/ui_models/blog_item.dart';
import 'package:toeic_desktop/data/models/ui_models/bottom_tab.dart';
import 'package:toeic_desktop/data/models/ui_models/part_model.dart';
import 'package:toeic_desktop/data/models/ui_models/service_item.dart';
import 'package:toeic_desktop/ui/common/app_images.dart';

class Constants {
  static const hostUrl = 'http://localhost:4000';

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
        title: 'AI Render',
        desciption:
            'Advanced AI-powered tools to enhance your TOEIC preparation experience.'),
    ServiceItem(
        icon: FontAwesomeIcons.idCard,
        title: 'Flashcards',
        desciption:
            'Interactive flashcards to boost your vocabulary and language skills efficiently.'),
    ServiceItem(
        icon: FontAwesomeIcons.list,
        title: 'Practice Exams',
        desciption:
            'Realistic TOEIC practice exams to assess and improve your test-taking abilities.'),
    ServiceItem(
        icon: FontAwesomeIcons.chartLine,
        title: 'Result Analysis',
        desciption:
            'Detailed analysis of your exam performance to identify strengths and areas for improvement.'),
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
        "#[Part 1] Human picture",
        "#[Part 1] Object picture",
      ],
    ),
    PartModel(
      partEnum: PartEnum.part2,
      numberOfQuestions: 25,
      tags: [
        "#[Part 2] WHAT question",
        "#[Part 2] WHO question",
        "#[Part 2] WHERE question",
        "#[Part 2] WHEN question",
        "#[Part 2] HOW question",
        "#[Part 2] YES/NO question",
        "#[Part 2] Tag question",
        "#[Part 2] Choice question",
        "#[Part 2] Request, suggestion",
        "#[Part 2] Statement",
      ],
    ),
    PartModel(
      partEnum: PartEnum.part3,
      numberOfQuestions: 39,
      tags: [
        "#[Part 3] Topic, purpose question",
        "#[Part 3] Speaker identity question",
        "#[Part 3] Conversation detail question",
        "#[Part 3] Combined chart question",
        "#[Part 3] Topic: Company - General Office Work",
        "#[Part 3] Topic: Company - Personnel",
        "#[Part 3] Topic: Company - Event, Project",
        "#[Part 3] Topic: Transportation",
        "#[Part 3] Topic: Shopping, Service",
        "#[Part 3] Topic: Order, delivery",
      ],
    ),
    PartModel(
      partEnum: PartEnum.part4,
      numberOfQuestions: 20,
      tags: [
        "#[Part 4] Topic, purpose question",
        "#[Part 4] Topic, purpose question",
        "#[Part 4] Topic, purpose question",
        "#[Part 4] Topic, purpose question",
        "#[Part 4] Topic, purpose question",
        "#[Part 4] Topic, purpose question",
        "#[Part 4] Topic, purpose question",
        "#[Part 4] Topic, purpose question",
        "#[Part 4] Topic, purpose question",
        "#[Part 4] Topic, purpose question",
        "#[Part 4] Topic, purpose question",
        "#[Part 4] Topic, purpose question",
        "#[Part 4] Topic, purpose question",
        "#[Part 4] Topic, purpose question",
        "#[Part 4] Topic, purpose question",
        "#[Part 4] Topic, purpose question",
        "#[Part 4] Topic, purpose question",
        "#[Part 4] Topic, purpose question",
      ],
    ),
    PartModel(
      partEnum: PartEnum.part5,
      numberOfQuestions: 10,
      tags: [
        "#[Part 5] Topic, purpose question",
        "#[Part 5] Topic, purpose question",
        "#[Part 5] Topic, purpose question",
        "#[Part 5] Topic, purpose question",
        "#[Part 5] Topic, purpose question",
        "#[Part 5] Topic, purpose question",
        "#[Part 5] Topic, purpose question",
        "#[Part 5] Topic, purpose question",
        "#[Part 5] Topic, purpose question",
      ],
    ),
    PartModel(
      partEnum: PartEnum.part6,
      numberOfQuestions: 10,
      tags: [
        "#[Part 6] Topic, purpose question",
        "#[Part 6] Topic, purpose question",
        "#[Part 6] Topic, purpose question",
        "#[Part 6] Topic, purpose question",
        "#[Part 6] Topic, purpose question",
        "#[Part 6] Topic, purpose question",
        "#[Part 6] Topic, purpose question",
        "#[Part 6] Topic, purpose question",
      ],
    ),
    PartModel(
      partEnum: PartEnum.part7,
      numberOfQuestions: 10,
      tags: [
        "#[Part 7] Topic, purpose question",
        "#[Part 7] Topic, purpose question",
        "#[Part 7] Topic, purpose question",
        "#[Part 7] Topic, purpose question",
        "#[Part 7] Topic, purpose question",
        "#[Part 7] Topic, purpose question",
        "#[Part 7] Topic, purpose question",
      ],
    ),
    // Add more parts as needed
  ];

  static List<BottomTabModel> bottomTabs = [
    BottomTabModel(
      title: 'Introduction',
      route: AppRouter.introduction,
      icon: AppImages.icIntro,
    ),
    BottomTabModel(
      title: 'Online Test',
      route: AppRouter.onlineTest,
      icon: AppImages.icTest,
    ),
    BottomTabModel(
      title: 'FlashCards',
      route: AppRouter.flashCards,
      icon: AppImages.icFlashCard,
    ),
    BottomTabModel(
      title: 'Listen && Copy',
      route: AppRouter.transcriptTest,
      icon: AppImages.icListenCopy,
    ),
    BottomTabModel(
      title: 'Blog',
      route: AppRouter.blog,
      icon: AppImages.icBlog,
    ),
  ];
}

extension ConstantsExtension on Constants {
  static Duration getTimeLimit(String time) {
    switch (time) {
      case '1 minute':
        return Duration(minutes: 1);
      case '10 minutes':
        return Duration(minutes: 10);
      case '20 minutes':
        return Duration(minutes: 20);
      case '30 minutes':
        return Duration(minutes: 30);
      case '40 minutes':
        return Duration(minutes: 40);
      case '50 minutes':
        return Duration(minutes: 50);
      case '60 minutes':
        return Duration(minutes: 60);
      case '120 minutes':
        return Duration(minutes: 120);
      case 'No limit':
        return Duration(minutes: 00);
      default:
        return Duration(minutes: 120);
    }
  }
}

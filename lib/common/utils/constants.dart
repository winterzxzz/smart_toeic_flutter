import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/ui_models/blog_item.dart';
import 'package:toeic_desktop/data/models/ui_models/flash_card.dart';
import 'package:toeic_desktop/data/models/ui_models/service_item.dart';

class Constants {


  static List<Flashcard> flashcards = [
    Flashcard(
        title: 'Cambridge Vocabulary for IELTS (20 units)',
        wordCount: 1716,
        learnerCount: 58182,
        imageUrl:
            'https://i.vietgiaitri.com/2024/4/26/winter-aespa-viral-vi-len-high-note-qua-muot-thai-do-khiem-ton-lai-cang-duoc-khen-ngoi-b74-7149549.webp',
        author: 'John Doe'),
    Flashcard(
        title: 'Từ vựng tiếng Anh văn phòng',
        wordCount: 536,
        learnerCount: 11805,
        imageUrl:
            'https://i.vietgiaitri.com/2024/4/26/winter-aespa-viral-vi-len-high-note-qua-muot-thai-do-khiem-ton-lai-cang-duoc-khen-ngoi-b74-7149549.webp',
        author: 'John Doe'),
    Flashcard(
        title: 'Từ vựng tiếng Anh giao tiếp nâng cao',
        wordCount: 599,
        learnerCount: 6438,
        imageUrl:
            'https://i.vietgiaitri.com/2024/4/26/winter-aespa-viral-vi-len-high-note-qua-muot-thai-do-khiem-ton-lai-cang-duoc-khen-ngoi-b74-7149549.webp',
        author: 'John Doe'),
    Flashcard(
        title: 'Từ vựng tiếng Anh giao tiếp trung cấp',
        wordCount: 798,
        learnerCount: 8040,
        imageUrl:
            'https://i.vietgiaitri.com/2024/4/26/winter-aespa-viral-vi-len-high-note-qua-muot-thai-do-khiem-ton-lai-cang-duoc-khen-ngoi-b74-7149549.webp',
        author: 'John Doe'),
    Flashcard(
        title: 'Từ vựng Tiếng Anh giao tiếp cơ bản',
        wordCount: 993,
        learnerCount: 21753,
        imageUrl:
            'https://i.vietgiaitri.com/2024/4/26/winter-aespa-viral-vi-len-high-note-qua-muot-thai-do-khiem-ton-lai-cang-duoc-khen-ngoi-b74-7149549.webp',
        author: 'John Doe'),
    Flashcard(
        title: '900 từ TOEFL (có ảnh)',
        wordCount: 899,
        learnerCount: 3933,
        imageUrl:
            'https://i.vietgiaitri.com/2024/4/26/winter-aespa-viral-vi-len-high-note-qua-muot-thai-do-khiem-ton-lai-cang-duoc-khen-ngoi-b74-7149549.webp',
        author: 'John Doe'),
    Flashcard(
        title: '900 từ IELTS (có ảnh)',
        wordCount: 899,
        learnerCount: 17292,
        imageUrl:
            'https://i.vietgiaitri.com/2024/4/26/winter-aespa-viral-vi-len-high-note-qua-muot-thai-do-khiem-ton-lai-cang-duoc-khen-ngoi-b74-7149549.webp',
        author: 'John Doe'),
    Flashcard(
        title: '900 từ SAT (có ảnh)',
        wordCount: 860,
        learnerCount: 1614,
        imageUrl:
            'https://i.vietgiaitri.com/2024/4/26/winter-aespa-viral-vi-len-high-note-qua-muot-thai-do-khiem-ton-lai-cang-duoc-khen-ngoi-b74-7149549.webp',
        author: 'John Doe'),
    Flashcard(
        title: 'GRE-GMAT Vocabulary List',
        wordCount: 868,
        learnerCount: 411,
        imageUrl:
            'https://i.vietgiaitri.com/2024/4/26/winter-aespa-viral-vi-len-high-note-qua-muot-thai-do-khiem-ton-lai-cang-duoc-khen-ngoi-b74-7149549.webp',
        author: 'John Doe'),
    Flashcard(
        title: 'Academic word list',
        wordCount: 570,
        learnerCount: 2019,
        imageUrl:
            'https://i.vietgiaitri.com/2024/4/26/winter-aespa-viral-vi-len-high-note-qua-muot-thai-do-khiem-ton-lai-cang-duoc-khen-ngoi-b74-7149549.webp',
        author: 'John Doe'),
    Flashcard(
        title: 'New Academic Word List',
        wordCount: 924,
        learnerCount: 888,
        imageUrl:
            'https://i.vietgiaitri.com/2024/4/26/winter-aespa-viral-vi-len-high-note-qua-muot-thai-do-khiem-ton-lai-cang-duoc-khen-ngoi-b74-7149549.webp',
        author: 'John Doe'),
    Flashcard(
        title: 'Business Word List',
        wordCount: 1665,
        learnerCount: 1584,
        imageUrl:
            'https://i.vietgiaitri.com/2024/4/26/winter-aespa-viral-vi-len-high-note-qua-muot-thai-do-khiem-ton-lai-cang-duoc-khen-ngoi-b74-7149549.webp',
        author: 'John Doe'),
    Flashcard(
        title: 'TOEFL Word List',
        wordCount: 3193,
        learnerCount: 3027,
        imageUrl:
            'https://i.vietgiaitri.com/2024/4/26/winter-aespa-viral-vi-len-high-note-qua-muot-thai-do-khiem-ton-lai-cang-duoc-khen-ngoi-b74-7149549.webp',
        author: 'John Doe'),
    Flashcard(
        title: 'TOEIC Word List',
        wordCount: 1194,
        learnerCount: 28614,
        imageUrl:
            'https://i.vietgiaitri.com/2024/4/26/winter-aespa-viral-vi-len-high-note-qua-muot-thai-do-khiem-ton-lai-cang-duoc-khen-ngoi-b74-7149549.webp',
        author: 'John Doe'),
    Flashcard(
        title: 'Powerscore GRE 700 Repeat Offenders',
        wordCount: 699,
        learnerCount: 141,
        imageUrl:
            'https://i.vietgiaitri.com/2024/4/26/winter-aespa-viral-vi-len-high-note-qua-muot-thai-do-khiem-ton-lai-cang-duoc-khen-ngoi-b74-7149549.webp',
        author: 'John Doe'),
    Flashcard(
        title: 'Most common IELTS Listening words',
        wordCount: 1124,
        learnerCount: 8595,
        imageUrl:
            'https://i.vietgiaitri.com/2024/4/26/winter-aespa-viral-vi-len-high-note-qua-muot-thai-do-khiem-ton-lai-cang-duoc-khen-ngoi-b74-7149549.webp',
        author: 'John Doe'),
  ];

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
        icon: Icons.smart_toy_outlined,
        title: 'AI Render',
        desciption:
            'Advanced AI-powered tools to enhance your TOEIC preparation experience.'),
    ServiceItem(
        icon: Icons.library_books_outlined,
        title: 'Flashcards',
        desciption:
            'Interactive flashcards to boost your vocabulary and language skills efficiently.'),
    ServiceItem(
        icon: Icons.list_alt_outlined,
        title: 'Practice Exams',
        desciption:
            'Realistic TOEIC practice exams to assess and improve your test-taking abilities.'),
    ServiceItem(
        icon: Icons.analytics_outlined,
        title: 'Result Analysis',
        desciption:
            'Detailed analysis of your exam performance to identify strengths and areas for improvement.'),
  ];
}

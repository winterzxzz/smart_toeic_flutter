import 'package:toeic_desktop/data/models/ui_models/flash_card.dart';
import 'package:toeic_desktop/data/models/ui_models/home_item.dart';

class Constants {
  static List<BottomTabItem> bottomTabItems = [
    BottomTabItem(title: 'About'),
    BottomTabItem(title: 'Resources'),
    BottomTabItem(title: 'Practice tests'),
    BottomTabItem(title: 'Flashcard'),
    BottomTabItem(title: 'Toeic full exam'),
  ];

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
}

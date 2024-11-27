import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/ui/page/flash_card_detail/widgets/flash_card_tile.dart';

final List<Map<String, dynamic>> flashcards = [
  {
    'word': 'abandon',
    'pronunciation': {'uk': '/əˈbændən/', 'us': '/əˈbændən/'},
    'definition': 'to stop doing an activity before you have finished it',
    'examples': [
      'The game was abandoned at half-time because of the poor weather conditions.',
      'They had to abandon their attempt to climb the mountain.'
    ],
    'image':
        'https://image.tienphong.vn/600x315/Uploaded/2024/cf-vsxrmrs/2024_04_12/winter-8423.jpg'
  },
  {
    'word': 'abdomen',
    'pronunciation': {'uk': '/ˈæbdəmən/', 'us': '/ˈæbdəmən/'},
    'definition':
        'the part of the body below the chest that contains the stomach, bowels, etc',
    'examples': [],
    'image':
        'https://image.tienphong.vn/600x315/Uploaded/2024/cf-vsxrmrs/2024_04_12/winter-8423.jpg'
  },
  {
    'word': 'abdominal',
    'pronunciation': {'uk': '/æbˈdɒmɪnl/', 'us': '/æbˈdɑːmɪnl/'},
    'definition': 'connected with the part of the body below the chest',
    'examples': ['abdominal pains'],
    'image':
        'https://image.tienphong.vn/600x315/Uploaded/2024/cf-vsxrmrs/2024_04_12/winter-8423.jpg'
  },
  {
    'word': 'abide',
    'pronunciation': {'uk': '/əˈbaɪd/', 'us': '/əˈbaɪd/'},
    'definition': 'to accept and act according to a law, an agreement, etc',
    'examples': ['to abide by the rules'],
    'image':
        'https://image.tienphong.vn/600x315/Uploaded/2024/cf-vsxrmrs/2024_04_12/winter-8423.jpg'
  },
  {
    'word': 'ability',
    'pronunciation': {'uk': '/əˈbɪləti/', 'us': '/əˈbɪləti/'},
    'definition': 'the fact that somebody is able to do something',
    'examples': ['She has the ability to learn quickly.'],
    'image':
        'https://image.tienphong.vn/600x315/Uploaded/2024/cf-vsxrmrs/2024_04_12/winter-8423.jpg'
  },
  {
    'word': 'able',
    'pronunciation': {'uk': '/ˈeɪbl/', 'us': '/ˈeɪbl/'},
    'definition': 'having the power or skill to do something',
    'examples': ['She is able to speak three languages.'],
    'image':
        'https://image.tienphong.vn/600x315/Uploaded/2024/cf-vsxrmrs/2024_04_12/winter-8423.jpg'
  },
  {
    'word': 'abnormal',
    'pronunciation': {'uk': '/æbˈnɔːml/', 'us': '/æbˈnɔːrml/'},
    'definition':
        'not normal according to a standard, rule or model; not usual or typical',
    'examples': ['abnormal behaviour'],
    'image':
        'https://image.tienphong.vn/600x315/Uploaded/2024/cf-vsxrmrs/2024_04_12/winter-8423.jpg'
  },
  {
    'word': 'aboard',
    'pronunciation': {'uk': '/əˈbɔːd/', 'us': '/əˈbɔːrd/'},
    'definition': 'on or into a ship, an aircraft, a bus, etc',
    'examples': ['Welcome aboard!'],
    'image':
        'https://image.tienphong.vn/600x315/Uploaded/2024/cf-vsxrmrs/2024_04_12/winter-8423.jpg'
  },
];

class FlashCardDetailPage extends StatelessWidget {
  const FlashCardDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcards: IELTS Vocabulary'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.sizeOf(context).width * 0.2),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  GoRouter.of(context)
                      .pushReplacementNamed(AppRouter.flashCardPractive);
                },
                child: Text('Luyện tập flashcards'),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.sizeOf(context).width * 0.2),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).pushReplacementNamed(AppRouter.quizz);
                },
                child: Text('Làm quizz'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      GoRouter.of(context)
                          .pushReplacementNamed(AppRouter.flashCardPractive);
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        children: const [
                          Icon(Icons.shuffle, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Xem ngẫu nhiên',
                              style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                    ),
                  ),
                  Text('List này có 100 từ', style: TextStyle()),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...flashcards
                .map((flashcard) => FlashcardTile(flashcard: flashcard))
          ],
        ),
      ),
    );
  }
}

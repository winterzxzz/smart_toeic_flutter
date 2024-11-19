import 'package:flutter/material.dart';

import 'package:flutter_flip_card/flutter_flip_card.dart';

class FlashCardPracticePage extends StatefulWidget {
  const FlashCardPracticePage({super.key});

  @override
  State<FlashCardPracticePage> createState() => _FlashCardPracticePageState();
}

class _FlashCardPracticePageState extends State<FlashCardPracticePage> {
  final List<Map<String, dynamic>> flashcards = [
    {
      'word': 'abandon',
      'definition': 'to stop doing an activity before you have finished it',
      'examples': [
        'The game was abandoned at half-time because of the poor weather conditions.',
        'They had to abandon their attempt to climb the mountain.'
      ],
    },
    {
      'word': 'abdomen',
      'definition':
          'the part of the body below the chest that contains the stomach, bowels, etc.',
      'examples': [
        'The abdomen is the part of the body between the chest and the hips.',
      ],
    },
    {
      'word': 'abdominal',
      'definition': 'connected with the part of the body below the chest',
      'examples': ['abdominal pains'],
    },
  ];

  int currentIndex = 0;
  bool isFlipped = false;
  late FlipCardController con1;

  @override
  void initState() {
    super.initState();
    con1 = FlipCardController();
  }

  void nextCard() async {
    if (isFlipped) {
      await con1.flipcard().then((_) {
        setState(() {
          if (currentIndex < flashcards.length - 1) {
            currentIndex++;
            isFlipped = false;
          }
        });
      });
    } else {
      setState(() {
        if (currentIndex < flashcards.length - 1) {
          currentIndex++;
          isFlipped = false;
        }
      });
    }
  }

  void previousCard() async {
    if (isFlipped) {
      await con1.flipcard().then((_) {
        setState(() {
          if (currentIndex > 0) {
            currentIndex--;
            isFlipped = false;
          }
        });
      });
    } else {
      setState(() {
        if (currentIndex > 0) {
          currentIndex--;
          isFlipped = false;
        }
      });
    }
  }

  void flipCard() async {
    await con1.flipcard().then((_) {
      setState(() {
        isFlipped = !isFlipped;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final flashcard = flashcards[currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcards: IELTS Vocabulary'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: flipCard,
                child: FlipCard(
                  animationDuration: Duration(milliseconds: 300),
                  rotateSide: isFlipped ? RotateSide.right : RotateSide.left,
                  onTapFlipping:
                      false, //When enabled, the card will flip automatically when touched.
                  axis: FlipAxis.vertical,
                  controller: con1,
                  frontWidget: FlashcardFront(
                    key: ValueKey('front'),
                    word: flashcard['word'],
                  ),
                  backWidget: FlashcardBack(
                    key: ValueKey('back'),
                    definition: flashcard['definition'],
                    examples: flashcard['examples'],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: previousCard,
                  child: Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: flipCard,
                  child: Text('Show Answer'),
                ),
                ElevatedButton(
                  onPressed: nextCard,
                  child: Text('Next'),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.05,
          )
        ],
      ),
    );
  }
}

class FlashcardFront extends StatelessWidget {
  final String word;

  const FlashcardFront({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.4,
      height: MediaQuery.sizeOf(context).height * 0.5,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Text(
        word,
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class FlashcardBack extends StatelessWidget {
  final String definition;
  final List<String> examples;

  const FlashcardBack(
      {super.key, required this.definition, required this.examples});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.4,
      height: MediaQuery.sizeOf(context).height * 0.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue, width: 2),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Definition:',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 8),
          Text(
            definition,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          if (examples.isNotEmpty) ...[
            SizedBox(height: 16),
            Text(
              'Examples:',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 8),
            ...examples.map((example) => Text(
                  '- $example',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                )),
          ],
        ],
      ),
    );
  }
}

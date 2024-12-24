import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_learning.dart';

class MatchingWord extends StatefulWidget {
  const MatchingWord({super.key, required this.list});

  final List<FlashCardLearning> list;

  @override
  State<MatchingWord> createState() => _MatchingWordState();
}

class _MatchingWordState extends State<MatchingWord> {
  String? selectedWord;
  bool? isWord;
  Map<String, String> map = {};
  List<FlashCardLearning> shuffledWords = [];
  List<FlashCardLearning> shuffledTranslations = [];

  @override
  void initState() {
    super.initState();
    for (var item in widget.list) {
      map[item.flashcardId!.word] = item.flashcardId!.translation;
    }
    shuffledWords = [...widget.list]..shuffle();
    shuffledTranslations = [...widget.list]..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Ghép nghĩa', style: TextStyle(fontSize: 18)),
        SizedBox(height: 32),
        Expanded(
          child: Row(
            children: [
              // English
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: shuffledWords.length,
                  separatorBuilder: (_, __) => SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final fc = shuffledWords[index];
                    return InkWell(
                      onTap: () {
                        if (isWord == null) {
                          setState(() {
                            selectedWord = fc.flashcardId!.word;
                            isWord = true;
                          });
                        } else {
                          if (map[selectedWord!] ==
                              fc.flashcardId!.translation) {
                            setState(() {
                              shuffledWords.removeAt(index);
                              shuffledTranslations.removeWhere((e) =>
                                  e.flashcardId!.translation == selectedWord);
                              isWord = null;
                              selectedWord = null;
                            });
                          } else {
                            setState(() {
                              isWord = null;
                              selectedWord = null;
                            });
                          }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selectedWord == fc.flashcardId!.word
                              ? Colors.blue
                              : Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(16),
                        child: Text(fc.flashcardId!.word),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 32),
              // Vietnamese
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: shuffledTranslations.length,
                  separatorBuilder: (_, __) => SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final fc = shuffledTranslations[index];
                    return InkWell(
                      onTap: () {
                        if (isWord == false) {
                          setState(() {
                            selectedWord = fc.flashcardId!.translation;
                            isWord = false;
                          });
                        } else {
                          if (map[selectedWord!] == fc.flashcardId!.word) {
                            setState(() {
                              shuffledTranslations.removeAt(index);
                              shuffledWords.removeWhere(
                                  (e) => e.flashcardId!.word == selectedWord);
                              isWord = null;
                              selectedWord = null;
                            });
                          } else {
                            setState(() {
                              isWord = null;
                              selectedWord = null;
                            });
                          }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selectedWord == fc.flashcardId!.translation
                              ? Colors.blue
                              : Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(16),
                        child: Text(fc.flashcardId!.translation),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_learning.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:confetti/confetti.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/flash_card_quizz_cubit.dart';

class MatchingWord extends StatefulWidget {
  const MatchingWord({
    super.key,
    required this.list,
  });

  final List<FlashCardLearning> list;

  @override
  State<MatchingWord> createState() => _MatchingWordState();
}

class _MatchingWordState extends State<MatchingWord>
    with TickerProviderStateMixin {
  String? selectedWord;
  bool? isSelectingWord;
  List<FlashCardLearning> availableWords = [];
  List<FlashCardLearning> availableTranslations = [];
  Set<String> matchedPairs = {};

  // Add these new controllers
  late AnimationController _shakeController;
  final Map<String, AnimationController> _fadeControllers = {};
  late ConfettiController _confettiController;
  final Map<String, List<Offset>> _pieces = {};
  late AnimationController _timerController;

  @override
  void initState() {
    super.initState();
    availableWords = List.from(widget.list)..shuffle();
    availableTranslations = List.from(widget.list)..shuffle();

    // Initialize shake animation controller
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));

    // Initialize timer controller
    _timerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    for (var controller in _fadeControllers.values) {
      controller.dispose();
    }
    _confettiController.dispose();
    _timerController.dispose();
    super.dispose();
  }

  // Add this method for shake animation
  Animation<double> get _shakeAnimation => Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _shakeController,
        curve: ShakeCurve(),
      ));

  void _createPieces(String text) {
    final random = Random();
    _pieces[text] = List.generate(8, (index) {
      return Offset(
        random.nextDouble() * 40 - 20,
        random.nextDouble() * 40 - 20,
      );
    });
  }

  void handleWordSelection(FlashCardLearning card, bool isWord) {
    if (selectedWord == null) {
      setState(() {
        selectedWord =
            isWord ? card.flashcardId!.word : card.flashcardId!.translation;
        isSelectingWord = isWord;
      });
      return;
    }

    bool isCorrectMatch = isWord
        ? card.flashcardId!.translation == selectedWord
        : card.flashcardId!.word == selectedWord;

    if (isCorrectMatch) {
      final word = isWord ? card.flashcardId!.word : selectedWord!;
      final translation =
          isWord ? selectedWord! : card.flashcardId!.translation;

      _createPieces(word);
      _createPieces(translation);

      _fadeControllers[word] = AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      )..forward().then((_) {
          setState(() {
            if (isWord) {
              availableWords.remove(card);
              availableTranslations.removeWhere(
                  (e) => e.flashcardId!.translation == selectedWord);
            } else {
              availableTranslations.remove(card);
              availableWords
                  .removeWhere((e) => e.flashcardId!.word == selectedWord);
            }
            matchedPairs.add(selectedWord!);
            selectedWord = null;
            isSelectingWord = null;

            // Check if all pairs are matched
            if (availableWords.isEmpty && availableTranslations.isEmpty) {
              _confettiController.play();
              _timerController.forward();
              Future.delayed(const Duration(seconds: 3), () {
                context.read<FlashCardQuizzCubit>().next();
              });
            }
          });
        });
    } else {
      _shakeController.forward().then((_) {
        _shakeController.reset();
        setState(() {
          selectedWord = null;
          isSelectingWord = null;
        });
      });
    }
  }

  Widget buildWordContainer({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        if (_pieces.containsKey(text)) {
          return Stack(
            children: [
              ..._pieces[text]!.map((offset) {
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 1000),
                  left: offset.dx,
                  top: offset.dy,
                  child: FadeTransition(
                    opacity: _fadeControllers[text]
                            ?.drive(CurveTween(curve: Curves.easeOut)) ??
                        const AlwaysStoppedAnimation(1.0),
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                );
              }),
              Transform.translate(
                offset:
                    Offset(_shakeAnimation.value * (isSelected ? 10 : 0), 0),
                child: FadeTransition(
                  opacity: _fadeControllers[text]
                          ?.drive(CurveTween(curve: Curves.easeOut)) ??
                      const AlwaysStoppedAnimation(1.0),
                  child: _buildWordContent(text, isSelected, onTap),
                ),
              ),
            ],
          );
        }
        return Transform.translate(
          offset: Offset(_shakeAnimation.value * (isSelected ? 10 : 0), 0),
          child: _buildWordContent(text, isSelected, onTap),
        );
      },
    );
  }

  Widget _buildWordContent(String text, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Ghép nghĩa', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                // Replace the text timer with a linear progress indicator
              ],
            ),
            SizedBox(height: 32),
            if (availableWords.isNotEmpty && availableTranslations.isNotEmpty)
              Expanded(
                child: Row(
                  children: [
                    // English
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: availableWords.length,
                        separatorBuilder: (_, __) => SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final card = availableWords[index];
                          return buildWordContainer(
                            text: card.flashcardId!.word,
                            isSelected: selectedWord == card.flashcardId!.word,
                            onTap: () => handleWordSelection(card, true),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 32),
                    // Vietnamese
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: availableTranslations.length,
                        separatorBuilder: (_, __) => SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final card = availableTranslations[index];
                          return buildWordContainer(
                            text: card.flashcardId!.translation,
                            isSelected:
                                selectedWord == card.flashcardId!.translation,
                            onTap: () => handleWordSelection(card, false),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: [
                  Text(
                      'Bạn đã ghép đúng tất cả các từ, tiếp tục với những dạng khác nhé!'),
                  SizedBox(height: 16),
                  AnimatedBuilder(
                    animation: _timerController,
                    builder: (context, child) {
                      return _timerController.value > 0
                          ? SizedBox(
                              width: 100,
                              child: LinearProgressIndicator(
                                value: 1 - _timerController.value,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary),
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                ],
              ),
          ],
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: pi / 2,
            maxBlastForce: 5,
            minBlastForce: 2,
            emissionFrequency: 0.05,
            numberOfParticles: 50,
            gravity: 0.1,
          ),
        ),
      ],
    );
  }
}

// Add this custom Curve class at the bottom of the file
class ShakeCurve extends Curve {
  @override
  double transform(double t) {
    return sin(t * pi * 8);
  }
}

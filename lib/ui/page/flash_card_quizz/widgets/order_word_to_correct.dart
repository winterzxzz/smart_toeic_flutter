import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_learning.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/flash_card_quizz_cubit.dart';

class OrderWordToCorrect extends StatefulWidget {
  const OrderWordToCorrect({super.key, required this.fcLearning});

  final FlashCardLearning fcLearning;

  @override
  State<OrderWordToCorrect> createState() => _OrderWordToCorrectState();
}

class _OrderWordToCorrectState extends State<OrderWordToCorrect> {
  List<String> shuffledWords = [];
  List<String> selectedWords = [];
  bool isCheck = false;
  bool isShowAnswer = false;

  @override
  void initState() {
    super.initState();
    shuffledWords = [
      ...widget.fcLearning.flashcardId!.exampleSentence.first.split(' ')
    ];
    shuffledWords.shuffle();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      key: widget.key,
      children: [
        const Center(
          child: Text('Sắp xếp các từ để tạo thành câu đúng',
              style: TextStyle(fontSize: 18)),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          direction: Axis.horizontal,
          children: shuffledWords.map((word) {
            return InkWell(
              onTap: () {
                if (isCheck) {
                  isCheck = false;
                }
                if (isShowAnswer) {
                  isShowAnswer = false;
                }

                setState(() {
                  selectedWords.add(word);
                  shuffledWords.remove(word);
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.textGray,
                  border: Border.all(color: AppColors.textGray),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  word,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textWhite,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.1),
          decoration: BoxDecoration(
            color: AppColors.gray1,
            border: Border.all(color: AppColors.gray1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Wrap(
            spacing: 4,
            runSpacing: 4,
            children: selectedWords.map((word) {
              return InkWell(
                onTap: () {
                  if (isCheck) {
                    isCheck = false;
                  }
                  if (isShowAnswer) {
                    isShowAnswer = false;
                  }

                  setState(() {
                    shuffledWords.add(word);
                    selectedWords.remove(word);
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.textWhite,
                    border: Border.all(color: AppColors.textWhite),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    word,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isCheck = true;
                    });
                    context.read<FlashCardQuizzCubit>().answer(
                        widget.fcLearning.flashcardId!.word,
                        selectedWords.join(' ').toLowerCase() ==
                            widget.fcLearning.flashcardId!.exampleSentence.first
                                .toLowerCase());
                  },
                  child: const Text('KIỂM TRA'),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Visibility(
          visible: isCheck,
          child: Column(
            children: [
              const SizedBox(height: 8),
              Text(
                'Đáp án: ${widget.fcLearning.flashcardId!.exampleSentence.first}',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        )
      ],
    );
  }
}

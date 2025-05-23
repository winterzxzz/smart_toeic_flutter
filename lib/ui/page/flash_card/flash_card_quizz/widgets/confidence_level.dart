import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_learning.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_quizz/flash_card_quizz_cubit.dart';

Map<double, String> diffLevels = {
  0: 'Khó nhớ',
  0.3: 'Tương đối khó',
  0.6: 'Dễ nhớ',
  1: 'Rất dễ nhớ',
};

class ConfidenceLevel extends StatefulWidget {
  const ConfidenceLevel({super.key, required this.fcLearning});

  final FlashCardLearning fcLearning;

  @override
  State<ConfidenceLevel> createState() => _ConfidenceLevelState();
}

class _ConfidenceLevelState extends State<ConfidenceLevel> {
  double? confidenceLevel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (widget.fcLearning.flashcardId == null) {
      return const SizedBox.shrink();
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      key: widget.key,
      children: [
        Text(
          widget.fcLearning.flashcardId?.word ?? '',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Bạn đã thuộc từ này ở mức nào?',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 32),
        ...diffLevels.entries.map((level) {
          return Column(
            children: [
              const SizedBox(height: 32),
              InkWell(
                onTap: () {
                  setState(() {
                    confidenceLevel = level.key;
                  });
                  context
                      .read<FlashCardQuizzCubit>()
                      .updateConfidenceLevel(level.key, widget.fcLearning.id!);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 70,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Radio<double>(
                        value: level.key,
                        groupValue: confidenceLevel,
                        onChanged: (value) {
                          setState(() {
                            confidenceLevel = value;
                          });
                          context
                              .read<FlashCardQuizzCubit>()
                              .updateConfidenceLevel(
                                  value!, widget.fcLearning.id!);
                        },
                      ),
                      const SizedBox(width: 8),
                      Text(level.value),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}

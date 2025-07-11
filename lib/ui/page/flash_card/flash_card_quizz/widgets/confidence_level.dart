import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_learning.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_quizz/flash_card_quizz_cubit.dart';

Map<double, String> diffLevels = {
  0: S.current.hard_to_remember,
  0.3: S.current.relatively_hard,
  0.6: S.current.easy_to_remember,
  1: S.current.very_easy_to_remember,
};

class ConfidenceLevel extends StatefulWidget {
  const ConfidenceLevel({super.key, required this.fcLearning});

  final FlashCardLearning fcLearning;

  @override
  State<ConfidenceLevel> createState() => _ConfidenceLevelState();
}

class _ConfidenceLevelState extends State<ConfidenceLevel> {
  late final FlashCardQuizzCubit _cubit;
  double? confidenceLevel;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<FlashCardQuizzCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    if (widget.fcLearning.flashcardId == null) {
      return const SizedBox.shrink();
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      key: widget.key,
      children: [
        Text(
          widget.fcLearning.flashcardId?.word ?? '',
          style: textTheme.headlineMedium?.copyWith(
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          S.current.what_is_your_confidence_level,
          style: textTheme.bodyMedium,
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
                  _cubit.updateConfidenceLevel(
                      level.key, widget.fcLearning.id!);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 70,
                  decoration: BoxDecoration(
                    border: Border.all(color: colorScheme.outline),
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
                          _cubit.updateConfidenceLevel(
                              value!, widget.fcLearning.id!);
                        },
                      ),
                      const SizedBox(width: 8),
                      Text(level.value, style: textTheme.bodyMedium),
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

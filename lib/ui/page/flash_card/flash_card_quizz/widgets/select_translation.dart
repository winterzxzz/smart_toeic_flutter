import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_learning.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_quizz/cubit/get_random_word_cubit.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_quizz/cubit/get_random_word_state.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_quizz/flash_card_quizz_cubit.dart';

class SelectTranslation extends StatelessWidget {
  const SelectTranslation({super.key, required this.fcLearning});

  final FlashCardLearning fcLearning;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<GetRandomWordCubit>()..getRandom4Words(),
      child: Page(fcLearning: fcLearning, widgetKey: key),
    );
  }
}

class Page extends StatelessWidget {
  const Page({
    super.key,
    required this.fcLearning,
    this.widgetKey,
  });
  final Key? widgetKey;
  final FlashCardLearning fcLearning;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetRandomWordCubit, GetRandomWordState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.failure) {
          showToast(title: state.message, type: ToastificationType.error);
        }
      },
      builder: (context, state) {
        if (state.loadStatus == LoadStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.loadStatus == LoadStatus.success) {
          final list = [
            fcLearning.flashcardId!.translation,
            ...state.random4Words.take(3).map((e) => e.translation!)
          ];
          return SectionQuestion(
              widgetKey: widgetKey, fcLearning: fcLearning, list: list);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class SectionQuestion extends StatefulWidget {
  const SectionQuestion({
    super.key,
    required this.widgetKey,
    required this.list,
    required this.fcLearning,
  });

  final List<String> list;
  final Key? widgetKey;
  final FlashCardLearning fcLearning;

  @override
  State<SectionQuestion> createState() => _SectionQuestionState();
}

class _SectionQuestionState extends State<SectionQuestion> {
  String? selectedAnswer;
  bool isCheck = false;
  late List<String> shuffledList;
  late final FlashCardQuizzCubit _cubit;

  @override
  void initState() {
    super.initState();
    shuffledList = List.from(widget.list)..shuffle();
    _cubit = context.read<FlashCardQuizzCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      key: widget.widgetKey,
      children: [
        Text.rich(
          style: textTheme.titleMedium,
          TextSpan(
            children: [
              TextSpan(
                text: S.current.select_meaning,
                style: textTheme.bodyLarge,
              ),
              TextSpan(
                text: " '${widget.fcLearning.flashcardId!.word}'",
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.error,
                ),
              ),
              TextSpan(
                text: ' ?',
                style: textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        ...shuffledList.map((level) {
          return Column(
            children: [
              const SizedBox(height: 32),
              InkWell(
                onTap: () {
                  setState(() {
                    isCheck = true;
                    selectedAnswer = level;
                  });
                  _cubit.answer(
                      widget.fcLearning.flashcardId!.word,
                      level.toLowerCase() ==
                          widget.fcLearning.flashcardId!.translation
                              .toLowerCase());
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
                      Radio(
                        value: level,
                        groupValue: selectedAnswer,
                        onChanged: (value) {
                          setState(() {
                            isCheck = true;
                            selectedAnswer = level;
                          });
                          _cubit.answer(
                              widget.fcLearning.flashcardId!.word,
                              level.toLowerCase() ==
                                  widget.fcLearning.flashcardId!.translation
                                      .toLowerCase());
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(
                        level.isNotEmpty
                            ? level[0].toUpperCase() + level.substring(1)
                            : '',
                        style: textTheme.bodyMedium,
                      )),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
        const SizedBox(height: 32),
        Visibility(
            visible: isCheck,
            child: Builder(builder: (context) {
              return Column(
                children: [
                  const SizedBox(height: 8),
                  Text(
                    '${S.current.answer}: ${widget.fcLearning.flashcardId!.translation}',
                    style: textTheme.bodyLarge,
                  ),
                ],
              );
            }))
      ],
    );
  }
}

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

class SelectDescription extends StatelessWidget {
  const SelectDescription({super.key, required this.fcLearning});

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
    // Guard against null flashcardId
    if (fcLearning.flashcardId == null) {
      return const SizedBox.shrink();
    }

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
          final List<String> list = [
            fcLearning.flashcardId!.definition,
            ...state.random4Words.take(3).map((e) => e.description!)
          ];
          return SectionQuestion(
              widgetKey: widgetKey, fcLearning: fcLearning, list: list);
        }
        return Center(child: Text(S.current.loading));
      },
    );
  }
}

class SectionQuestion extends StatefulWidget {
  const SectionQuestion({
    super.key,
    required this.widgetKey,
    required this.fcLearning,
    required this.list,
  });

  final Key? widgetKey;
  final FlashCardLearning fcLearning;
  final List<String> list;

  @override
  State<SectionQuestion> createState() => _SectionQuestionState();
}

class _SectionQuestionState extends State<SectionQuestion>
    with TickerProviderStateMixin {
  String? selectedAnswer;
  bool isCheck = false;
  late List<String> shuffledList;
  late final FlashCardQuizzCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<FlashCardQuizzCubit>();
    shuffledList = List.from(widget.list)..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return RadioGroup<String>(
      groupValue: selectedAnswer,
      onChanged: (value) {
        if (value == null) return;
        setState(() {
          selectedAnswer = value;
          isCheck = true;
        });
        _cubit.answer(
            widget.fcLearning.flashcardId!.word,
            value.toLowerCase() ==
                widget.fcLearning.flashcardId!.definition.toLowerCase());
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        key: widget.widgetKey,
        children: [
          Text.rich(
            style: textTheme.titleMedium,
            TextSpan(
              children: [
                TextSpan(
                  text: S.current.select_description,
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
                      selectedAnswer = level;
                      isCheck = true;
                    });
                    _cubit.answer(
                        widget.fcLearning.flashcardId!.word,
                        level.toLowerCase() ==
                            widget.fcLearning.flashcardId!.definition
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
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(level)),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 32),
          if (isCheck)
            Builder(builder: (context) {
              return Column(
                children: [
                  const SizedBox(height: 8),
                  Text(
                    '${S.current.answer}: ${widget.fcLearning.flashcardId!.definition}',
                    style: textTheme.bodyLarge,
                  ),
                ],
              );
            })
        ],
      ),
    );
  }
}

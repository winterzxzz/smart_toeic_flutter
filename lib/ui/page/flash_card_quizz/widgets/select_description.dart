import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_learning.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/cubit/get_random_word_cubit.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/cubit/get_random_word_state.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/flash_card_quizz_cubit.dart';

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
    return BlocConsumer<GetRandomWordCubit, GetRandomWordState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.failure) {
          showToast(title: state.message, type: ToastificationType.error);
        }
      },
      builder: (context, state) {
        if (state.loadStatus == LoadStatus.loading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state.loadStatus == LoadStatus.success) {
          final List<String> list = [
            fcLearning.flashcardId!.definition,
            ...state.random4Words.take(3).map((e) => e.description!)
          ];
          list.shuffle();
          return SectionQuestion(
              widgetKey: widgetKey, fcLearning: fcLearning, list: list);
        }
        return Center(child: Text('Loading...'));
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
  late AnimationController _timerController;

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      key: widget.widgetKey,
      children: [
        Text.rich(
          style: TextStyle(fontSize: 18),
          TextSpan(
            children: [
              TextSpan(text: 'Chọn mô tả đúng cho từ '),
              TextSpan(
                text: "'${widget.fcLearning.flashcardId!.word}'",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ' ?'),
            ],
          ),
        ),
        SizedBox(height: 32),
        ...widget.list.map((level) {
          return Column(
            children: [
              const SizedBox(height: 32),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedAnswer = level;
                    isCheck = true;
                  });
                  context.read<FlashCardQuizzCubit>().answer(
                      widget.fcLearning.flashcardId!.word,
                      level.toLowerCase() ==
                          widget.fcLearning.flashcardId!.definition
                              .toLowerCase());
                  _timerController.forward();
                  Future.delayed(const Duration(seconds: 3), () {
                    if (context.mounted) {
                      context.read<FlashCardQuizzCubit>().next();
                    }
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 70,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Radio(
                        value: level,
                        groupValue: selectedAnswer,
                        onChanged: (value) {
                          setState(() {
                            selectedAnswer = level;
                            isCheck = true;
                          });
                          context.read<FlashCardQuizzCubit>().answer(
                              widget.fcLearning.flashcardId!.word,
                              level.toLowerCase() ==
                                  widget.fcLearning.flashcardId!.definition
                                      .toLowerCase());
                          _timerController.forward();
                          Future.delayed(const Duration(seconds: 3), () {
                            if (context.mounted) {
                              context.read<FlashCardQuizzCubit>().next();
                            }
                          });
                        },
                      ),
                      SizedBox(width: 8),
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
            final isCorrect = selectedAnswer!.toLowerCase() ==
                widget.fcLearning.flashcardId!.definition.toLowerCase();
            return Column(
              children: [
                Text(
                  isCorrect ? 'Bạn đã trả lời đúng!' : 'Bạn đã trả lời sai!',
                  style: TextStyle(
                    fontSize: 18,
                    color: isCorrect ? AppColors.success : AppColors.error,
                  ),
                ),
                if (!isCorrect) ...[
                  SizedBox(height: 8),
                  Text(
                    'Đáp án: ${widget.fcLearning.flashcardId!.word}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
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
            );
          })
      ],
    );
  }
}

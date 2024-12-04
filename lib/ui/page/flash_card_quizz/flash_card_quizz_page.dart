
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/entities/flash_card.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/flash_card_quizz_cubit.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/flash_card_quizz_state.dart';

class FlashCardQuizPage extends StatelessWidget {
  const FlashCardQuizPage(
      {super.key, required this.title, required this.flashCards});

  final String title;
  final List<FlashCard> flashCards;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FlashCardQuizzCubit(injector())..fetchFlashCardQuizzs(flashCards),
      child: Page(title: title),
    );
  }
}

class Page extends StatefulWidget {
  const Page({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Flash Card Quiz: ${widget.title}'),
        ),
        body: Center(
          child: BlocConsumer<FlashCardQuizzCubit, FlashCardQuizzState>(
            listener: (context, state) {
              if (state.loadStatus == LoadStatus.failure) {
                AppNavigator(context: context).error(state.message);
              }
            },
            builder: (context, state) {
              if (state.loadStatus == LoadStatus.loading) {
                return Center(child: CircularProgressIndicator());
              } else if (state.loadStatus == LoadStatus.success) {
                if (state.flashCardQuizzs.isEmpty) {
                  return Center(child: Text('No data'));
                }
                final flashCardQuizz = state.flashCardQuizzs[state.currentIndex];
                return Container(
                  width: MediaQuery.sizeOf(context).width * 0.6,
                  height: MediaQuery.sizeOf(context).height * 0.7,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () {
                                context
                                    .read<FlashCardQuizzCubit>()
                                    .finishQuizz(context);
                              },
                              child: Text('Finish'),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        flashCardQuizz.word,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        flashCardQuizz.quiz.question,
                        style: TextStyle(fontSize: 18),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: flashCardQuizz.quiz.options
                              .map((e) => _buildRadioOption(flashCardQuizz.flashcardId, e))
                              .toList(),
                        ),
                      ),
                      SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: state.currentIndex == 0
                                  ? null
                                  : () {
                                      context
                                          .read<FlashCardQuizzCubit>()
                                    .previousQuestion();
                              },
                              child: Text('Previous'),
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: state.currentIndex ==
                                      state.flashCardQuizzs.length - 1
                                  ? () {
                                    
                                  }
                                  : () {
                                      context
                                          .read<FlashCardQuizzCubit>()
                                    .nextQuestion();
                              },
                              child: state.currentIndex ==
                                      state.flashCardQuizzs.length - 1
                                  ? Text('Finish')
                                  : Text('Next'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRadioOption(String flashcardId, String text) {
    final selectedOption =
        context.read<FlashCardQuizzCubit>().state.selectedOption[flashcardId];
    return InkWell(
      highlightColor: Colors.red,
      hoverColor: Colors.red,
      splashColor: Colors.red,
      onTap: () {
        context
            .read<FlashCardQuizzCubit>()
            .selectOption(flashcardId, text);
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.gray1, width: 1),
        ),
        child: Row(
          children: [
            Radio(
              value: selectedOption,
              groupValue: text,
              onChanged: (value) {},
            ),
            Text(
              text,
            )
          ],
        ),
      ),
    );
  }
}

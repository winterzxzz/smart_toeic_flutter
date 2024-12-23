import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/flash_card_quizz_cubit.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/flash_card_quizz_state.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/widgets/confidence_level.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/widgets/enter_translation.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/widgets/enter_word.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/widgets/matching_word.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/widgets/order_word_to_correct.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/widgets/select_description.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/widgets/select_translation.dart';

class FlashCardQuizPage extends StatelessWidget {
  final String id;

  const FlashCardQuizPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<FlashCardQuizzCubit>()..init(id),
      child: Page(),
    );
  }
}

class Page extends StatefulWidget {
  const Page({
    super.key,
  });

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  bool isTestCompleted = false; // Track whether the test is complete

  Future<bool> _onWillPop() async {
    if (!isTestCompleted) {
      // Show a confirmation dialog
      bool? exitTest = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Exit Test'),
          content: Text(
              'Are you sure you want to leave the test? Your progress will be lost.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Exit'),
            ),
          ],
        ),
      );
      return exitTest ?? false; // Return true if the user confirms exit
    }
    return true; // Allow navigation if test is complete
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FlashCardQuizzCubit, FlashCardQuizzState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.failure) {
          showToast(title: state.message, type: ToastificationType.error);
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (didPop) {
              isTestCompleted = true;
            }
          },
          child: Scaffold(
            body: Builder(builder: (context) {
              if (state.loadStatus == LoadStatus.loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SafeArea(
                child: Center(
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(32),
                      width: MediaQuery.sizeOf(context).width * 0.8,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.0, 0.1),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: Builder(
                              key: ValueKey(
                                  '${state.typeQuizzIndex}-${state.currentIndex}'),
                              builder: (context) {
                                switch (state.typeQuizzIndex) {
                                  case 0:
                                    return ConfidenceLevel(
                                      fcLearning: state.flashCardLearning[
                                          state.currentIndex],
                                      key: ValueKey(
                                          'confidence-${state.currentIndex}'),
                                    );
                                  case 1:
                                    return MatchingWord(
                                      list: state.flashCardLearning,
                                      key: ValueKey(
                                          'matching-${state.currentIndex}'),
                                    );
                                  case 2:
                                    return EnterTranslation(
                                      fcLearning: state.flashCardLearning[
                                          state.currentIndex],
                                      key: ValueKey(
                                          'enter-translation-${state.currentIndex}'),
                                    );
                                  case 3:
                                    return OrderWordToCorrect(
                                      fcLearning: state.flashCardLearning[
                                          state.currentIndex],
                                      key: ValueKey(
                                          'order-word-to-correct-${state.currentIndex}'),
                                    );
                                  case 4:
                                    return SelectDescription(
                                      fcLearning: state.flashCardLearning[
                                          state.currentIndex],
                                      key: ValueKey(
                                          'select-description-${state.currentIndex}'),
                                    );
                                  case 5:
                                    return SelectTranslation(
                                      fcLearning: state.flashCardLearning[
                                          state.currentIndex],
                                      key: ValueKey(
                                          'select-translation-${state.currentIndex}'),
                                    );
                                  case 6:
                                    return EnterWord(
                                      fcLearning: state.flashCardLearning[
                                          state.currentIndex],
                                      key: ValueKey(
                                          'enter-word-${state.currentIndex}'),
                                    );
                                  default:
                                    return const SizedBox.shrink();
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 48),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: state.currentIndex > 0
                                      ? () {
                                          context
                                              .read<FlashCardQuizzCubit>()
                                              .previousTypeQuizz();
                                        }
                                      : null,
                                  child: Row(
                                    children: [
                                      Icon(Icons.chevron_left),
                                      SizedBox(width: 8),
                                      Text('Trước'),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<FlashCardQuizzCubit>()
                                        .nextTypeQuizz();
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                          // ? 'Kết thúc'
                                          'Tiếp theo'),
                                      SizedBox(width: 8),
                                      Icon(Icons.chevron_right),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(FontAwesomeIcons.circleCheck),
                                  SizedBox(width: 8),
                                  Text('Kết thúc'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

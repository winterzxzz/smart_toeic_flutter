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
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FlashCardQuizzCubit, FlashCardQuizzState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.failure) {
          showToast(title: state.message, type: ToastificationType.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: AnimatedSwitcher(
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
                                    return EnterWord(
                                      fcLearning: state.flashCardLearning[
                                          state.currentIndex],
                                      key: ValueKey(
                                          'enter-word-${state.currentIndex}'),
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
                                    return EnterTranslation(
                                      fcLearning: state.flashCardLearning[
                                          state.currentIndex],
                                      key: ValueKey(
                                          'enter-translation-${state.currentIndex}'),
                                    );
                                  default:
                                    return const SizedBox.shrink();
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 40,
                              child: ElevatedButton(
                                onPressed: state.currentIndex == 0 &&
                                        state.typeQuizzIndex == 0
                                    ? null
                                    : () {
                                        context
                                            .read<FlashCardQuizzCubit>()
                                            .previous();
                                      },
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
                                onPressed: state.currentIndex ==
                                            state.flashCardLearning.length -
                                                1 &&
                                        state.typeQuizzIndex == 6
                                    ? null
                                    : () {
                                        context
                                            .read<FlashCardQuizzCubit>()
                                            .next();
                                      },
                                child: Row(
                                  children: [
                                    Text(state.typeQuizzIndex == 6 &&
                                            state.currentIndex ==
                                                state.flashCardLearning.length -
                                                    1
                                        ? 'Kết thúc'
                                        : 'Tiếp theo'),
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
        );
      },
    );
  }
}

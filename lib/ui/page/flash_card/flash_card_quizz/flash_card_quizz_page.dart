import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/common/widgets/confirm_dia_log.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_quizz/flash_card_quizz_cubit.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_quizz/flash_card_quizz_state.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_quizz/widgets/confidence_level.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_quizz/widgets/enter_translation.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_quizz/widgets/enter_word.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_quizz/widgets/matching_word.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_quizz/widgets/order_word_to_correct.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_quizz/widgets/select_description.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_quizz/widgets/select_translation.dart';

class FlashCardQuizPage extends StatelessWidget {
  final String id;

  const FlashCardQuizPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<FlashCardQuizzCubit>()..init(id),
      child: const Page(),
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

class _PageState extends State<Page> with TickerProviderStateMixin {
  late AnimationController _timerController;
  late final FlashCardQuizzCubit _cubit;

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _cubit = context.read<FlashCardQuizzCubit>();
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navigator = AppNavigator(context: context);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        actions: [
          LeadingBackButton(
            isClose: true,
            onPressed: () {
              showConfirmDialog(
                  context, S.current.exit, S.current.are_you_sure_exit, () {
                GoRouter.of(context).pop();
              });
            },
          )
        ],
      ),
      body: BlocConsumer<FlashCardQuizzCubit, FlashCardQuizzState>(
        listener: (context, state) {
          if (state.isAnimating) {
            _timerController.reset();
            _timerController.forward();
          } else {
            _timerController.stop();
          }
          if (state.isFinish) {
            navigator
                .pushReplacementNamed(AppRouter.flashCardQuizzResult, extra: {
              'flashCardQuizzScoreRequest': state.flashCardQuizzScoreRequest,
            });
          }
          if (state.loadStatus == LoadStatus.failure) {
            showToast(title: state.message, type: ToastificationType.error);
          } else if (state.loadStatus == LoadStatus.success) {
            if (state.message.isNotEmpty) {
              showToast(title: state.message, type: ToastificationType.success);
            }
          }
        },
        builder: (context, state) {
          if (state.loadStatus == LoadStatus.loading) {
            return const LoadingCircle();
          }
          return Center(
            child: Stack(children: [
              IgnorePointer(
                ignoring: state.isAnimating,
                child: Opacity(
                  opacity: state.isAnimating ? 0.5 : 1,
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 16 : 32,
                        vertical: isSmallScreen ? 8 : 16,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder: (child, animation) {
                          final inAnimation = Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(animation);

                          return SlideTransition(
                            position: inAnimation,
                            child: FadeTransition(
                              opacity: animation,
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
                                  fcLearning: state
                                      .flashCardLearning[state.currentIndex],
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
                                  fcLearning: state
                                      .flashCardLearning[state.currentIndex],
                                  key: ValueKey(
                                      'enter-translation-${state.currentIndex}'),
                                );
                              case 3:
                                return OrderWordToCorrect(
                                  fcLearning: state
                                      .flashCardLearning[state.currentIndex],
                                  key: ValueKey(
                                      'order-word-to-correct-${state.currentIndex}'),
                                );
                              case 4:
                                return SelectDescription(
                                  fcLearning: state
                                      .flashCardLearning[state.currentIndex],
                                  key: ValueKey(
                                      'select-description-${state.currentIndex}'),
                                );
                              case 5:
                                return SelectTranslation(
                                  fcLearning: state
                                      .flashCardLearning[state.currentIndex],
                                  key: ValueKey(
                                      'select-translation-${state.currentIndex}'),
                                );
                              case 6:
                                return EnterWord(
                                  fcLearning: state
                                      .flashCardLearning[state.currentIndex],
                                  key: ValueKey(
                                      'enter-word-${state.currentIndex}'),
                                );
                              default:
                                return const SizedBox.shrink();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (state.isAnimating) ...[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          state.isCorrect ? Colors.green[200] : Colors.red[200],
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedBuilder(
                          animation: _timerController,
                          builder: (context, child) {
                            return LinearProgressIndicator(
                              value: _timerController.value,
                              backgroundColor: Colors.transparent,
                              color:
                                  state.isCorrect ? Colors.green : Colors.red,
                              minHeight: 3,
                            );
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: FaIcon(
                                  state.isCorrect
                                      ? FontAwesomeIcons.check
                                      : FontAwesomeIcons.xmark,
                                  size: isSmallScreen ? 32 : 40,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                state.isCorrect
                                    ? S.current.great
                                    : S.current.try_harder,
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 18 : 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                state.isCorrect
                                    ? S.current.you_answered_correctly
                                    : S.current.you_answered_incorrectly,
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                height: isSmallScreen ? 48 : 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: state.isCorrect
                                        ? Colors.green
                                        : Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    _cubit.next();
                                  },
                                  child: Text(
                                    S.current.next_question,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ]),
          );
        },
      ),
    );
  }
}

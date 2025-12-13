import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/common/widgets/confirm_dia_log.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_quizz/flash_card_quizz_cubit.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_quizz/flash_card_quizz_state.dart';
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
    final theme = context.theme;
    final textTheme = context.textTheme;
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
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: state.isCorrect
                            ? [
                                const Color(0xFF4CAF50),
                                const Color(0xFF2E7D32),
                              ]
                            : [
                                const Color(0xFFE91E63),
                                const Color(0xFFC2185B),
                              ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (state.isCorrect
                                  ? const Color(0xFF4CAF50)
                                  : const Color(0xFFE91E63))
                              .withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedBuilder(
                          animation: _timerController,
                          builder: (context, child) {
                            return LinearProgressIndicator(
                              value: _timerController.value,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              color: Colors.white,
                              minHeight: 4,
                            );
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: FaIcon(
                                    state.isCorrect
                                        ? FontAwesomeIcons.check
                                        : FontAwesomeIcons.xmark,
                                    size: isSmallScreen ? 28 : 36,
                                    color: state.isCorrect
                                        ? const Color(0xFF4CAF50)
                                        : const Color(0xFFE91E63),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                state.isCorrect
                                    ? S.current.great
                                    : S.current.try_harder,
                                style: textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                state.isCorrect
                                    ? S.current.you_answered_correctly
                                    : S.current.you_answered_incorrectly,
                                style: textTheme.bodyLarge?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: state.isCorrect
                                        ? const Color(0xFF4CAF50)
                                        : const Color(0xFFE91E63),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  onPressed: () {
                                    _cubit.next();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        S.current.next_question,
                                        style: textTheme.titleMedium?.copyWith(
                                          color: state.isCorrect
                                              ? const Color(0xFF4CAF50)
                                              : const Color(0xFFE91E63),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      FaIcon(
                                        FontAwesomeIcons.arrowRight,
                                        size: 16,
                                        color: state.isCorrect
                                            ? const Color(0xFF4CAF50)
                                            : const Color(0xFFE91E63),
                                      ),
                                    ],
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_learn_flip/flash_card_learn_flip_cubit.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_learn_flip/flash_card_learn_flip_state.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_learn_flip/widgets/flash_card_item_back.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_learn_flip/widgets/flash_card_item_front.dart';

class FlashCardPracticePage extends StatelessWidget {
  const FlashCardPracticePage({
    super.key,
    required this.title,
    required this.flashCards,
  });

  final String title;
  final List<FlashCard> flashCards;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          injector<FlashCardLearnFlipCubit>()..init(flashCards, title),
      child: const Page(),
    );
  }
}

class Page extends StatelessWidget {
  const Page({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: const LeadingBackButton(),
        title: BlocSelector<FlashCardLearnFlipCubit, FlashCardLearnFlipState,
            String>(
          selector: (state) => state.title,
          builder: (context, title) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16),
                ),
                BlocSelector<FlashCardLearnFlipCubit, FlashCardLearnFlipState,
                    (int, int)>(
                  selector: (state) =>
                      (state.currentIndex + 1, state.flashCards.length),
                  builder: (context, counts) {
                    return Text(
                      '${counts.$1}/${counts.$2} words',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textGray,
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(5),
          child: BlocBuilder<FlashCardLearnFlipCubit, FlashCardLearnFlipState>(
            buildWhen: (previous, current) =>
                previous.currentIndex != current.currentIndex ||
                previous.flashCards.length != current.flashCards.length,
            builder: (context, state) {
              return LinearProgressIndicator(
                minHeight: 5,
                value: (state.currentIndex + 1) / state.flashCards.length,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
              );
            },
          ),
        ),
      ),
      body: BlocBuilder<FlashCardLearnFlipCubit, FlashCardLearnFlipState>(
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: () =>
                          context.read<FlashCardLearnFlipCubit>().flipCard(),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        child: FlipCard(
                          animationDuration: const Duration(milliseconds: 300),
                          rotateSide: state.isFlipped
                              ? RotateSide.right
                              : RotateSide.left,
                          onTapFlipping: false,
                          axis: FlipAxis.vertical,
                          controller: context
                              .read<FlashCardLearnFlipCubit>()
                              .controller,
                          frontWidget: FlashcardFront(
                            key: const ValueKey('front'),
                            word: state.flashCards[state.currentIndex].word,
                          ),
                          backWidget: FlashcardBack(
                            key: const ValueKey('back'),
                            flashcard: state.flashCards[state.currentIndex],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Navigation buttons
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Show Answer button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: () => context
                              .read<FlashCardLearnFlipCubit>()
                              .flipCard(),
                          icon: Icon(
                            state.isFlipped
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          label: Text(
                            state.isFlipped ? 'Hide Answer' : 'Show Answer',
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Navigation buttons
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton.icon(
                                onPressed: state.currentIndex > 0
                                    ? () => context
                                        .read<FlashCardLearnFlipCubit>()
                                        .previousCard()
                                    : null,
                                icon: const Icon(Icons.arrow_back),
                                label: const Text('Previous'),
                                style: ElevatedButton.styleFrom(
                                  disabledBackgroundColor:
                                      AppColors.gray1.withValues(alpha: 0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton.icon(
                                onPressed: state.currentIndex <
                                        state.flashCards.length - 1
                                    ? () => context
                                        .read<FlashCardLearnFlipCubit>()
                                        .nextCard()
                                    : null,
                                icon: const Icon(Icons.arrow_forward),
                                label: const Text('Next'),
                                style: ElevatedButton.styleFrom(
                                  disabledBackgroundColor:
                                      AppColors.gray1.withValues(alpha: 0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

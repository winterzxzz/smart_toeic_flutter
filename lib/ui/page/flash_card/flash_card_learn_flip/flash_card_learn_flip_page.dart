import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_learn_flip/flash_card_learn_flip_cubit.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_learn_flip/flash_card_learn_flip_state.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_learn_flip/widgets/flash_card_item_back.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_learn_flip/widgets/flash_card_item_front.dart';

class FlashCardLearnFlipPage extends StatelessWidget {
  const FlashCardLearnFlipPage({
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

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  late final FlashCardLearnFlipCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<FlashCardLearnFlipCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
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
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
                BlocSelector<FlashCardLearnFlipCubit, FlashCardLearnFlipState,
                    (int, int)>(
                  selector: (state) =>
                      (state.currentIndex + 1, state.flashCards.length),
                  builder: (context, counts) {
                    return Text(
                      '${counts.$1}/${counts.$2} ${S.current.words}',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textGray,
                        fontSize: 12.sp,
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(6.h),
          child: BlocBuilder<FlashCardLearnFlipCubit, FlashCardLearnFlipState>(
            buildWhen: (previous, current) =>
                previous.currentIndex != current.currentIndex ||
                previous.flashCards.length != current.flashCards.length,
            builder: (context, state) {
              return LinearProgressIndicator(
                minHeight: 6.h,
                value: (state.currentIndex + 1) / state.flashCards.length,
                backgroundColor: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4.r),
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
                      onTap: () => _cubit.flipCard(),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        child: FlipCard(
                          animationDuration: const Duration(milliseconds: 300),
                          rotateSide: state.isFlipped
                              ? RotateSide.right
                              : RotateSide.left,
                          onTapFlipping: false,
                          axis: FlipAxis.vertical,
                          controller: _cubit.controller,
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
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      // Show Answer button
                      _buildControlButton(
                        context,
                        onPressed: () => _cubit.flipCard(),
                        icon: state.isFlipped
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        label: state.isFlipped
                            ? S.current.hide_answer
                            : S.current.show_answer,
                        isPrimary: true,
                      ),
                      SizedBox(height: 16.h),
                      // Navigation buttons
                      Row(
                        children: [
                          Expanded(
                            child: _buildControlButton(
                              context,
                              onPressed: state.currentIndex > 0
                                  ? () => _cubit.previousCard()
                                  : null,
                              icon: Icons.arrow_back_ios_new_rounded,
                              label: S.current.previous,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: _buildControlButton(
                              context,
                              onPressed: state.currentIndex <
                                      state.flashCards.length - 1
                                  ? () => _cubit.nextCard()
                                  : null,
                              icon: Icons.arrow_forward_ios_rounded,
                              label: S.current.next,
                              isTrailingIcon: true,
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

  Widget _buildControlButton(
    BuildContext context, {
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
    bool isPrimary = false,
    bool isTrailingIcon = false,
  }) {
    final colorScheme = context.colorScheme;
    final baseColor =
        isPrimary ? colorScheme.primary : colorScheme.surfaceContainerHighest;
    final onBaseColor =
        isPrimary ? colorScheme.onPrimary : colorScheme.onSurface;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        height: 56.h,
        decoration: BoxDecoration(
          color:
              onPressed == null ? baseColor.withValues(alpha: 0.3) : baseColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isTrailingIcon) ...[
              Icon(icon,
                  color: onPressed == null
                      ? onBaseColor.withValues(alpha: 0.5)
                      : onBaseColor,
                  size: 20.spMin),
              SizedBox(width: 8.w),
            ],
            Text(
              label,
              style: context.textTheme.labelLarge?.copyWith(
                color: onPressed == null
                    ? onBaseColor.withValues(alpha: 0.5)
                    : onBaseColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isTrailingIcon) ...[
              SizedBox(width: 8.w),
              Icon(icon,
                  color: onPressed == null
                      ? onBaseColor.withValues(alpha: 0.5)
                      : onBaseColor,
                  size: 20.spMin),
            ],
          ],
        ),
      ),
    );
  }
}

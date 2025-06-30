import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/configs/app_configs.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';
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
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<FlashCardLearnFlipCubit>();
    if (injector<UserCubit>().state.user != null &&
        injector<UserCubit>().state.user!.isPremium() == false) {
      _bannerAd = BannerAd(
        adUnitId: AppConfigs.testAdUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (_) => setState(() => _isBannerAdReady = true),
        ),
      )..load();
    }
  }

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
                      '${counts.$1}/${counts.$2} ${S.current.words}',
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
                      onTap: () => _cubit.flipCard(),
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
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Show Answer button
                      CustomButton(
                        height: 50,
                        onPressed: () => _cubit.flipCard(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              state.isFlipped
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              state.isFlipped
                                  ? S.current.hide_answer
                                  : S.current.show_answer,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Navigation buttons
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              height: 50,
                              onPressed: state.currentIndex > 0
                                  ? () => _cubit.previousCard()
                                  : null,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.arrow_back_ios_new_rounded),
                                  const SizedBox(width: 8),
                                  Text(S.current.previous),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomButton(
                              height: 50,
                              onPressed: state.currentIndex <
                                      state.flashCards.length - 1
                                  ? () => _cubit.nextCard()
                                  : null,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(S.current.next),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward_ios_rounded),
                                ],
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
      bottomNavigationBar: _isBannerAdReady
          ? SizedBox(
              width: _bannerAd.size.width.toDouble(),
              height: _bannerAd.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd),
            )
          : null,
    );
  }
}

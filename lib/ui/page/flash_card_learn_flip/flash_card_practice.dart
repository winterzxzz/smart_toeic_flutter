import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card.dart';
import 'package:toeic_desktop/ui/page/flash_card_learn_flip/flash_card_learn_flip_cubit.dart';
import 'package:toeic_desktop/ui/page/flash_card_learn_flip/flash_card_learn_flip_state.dart';
import 'package:toeic_desktop/ui/page/flash_card_learn_flip/widgets/flash_card_item_back.dart';
import 'package:toeic_desktop/ui/page/flash_card_learn_flip/widgets/flash_card_item_front.dart';

class FlashCardPracticePage extends StatelessWidget {
  const FlashCardPracticePage(
      {super.key, required this.title, required this.flashCards});

  final String title;
  final List<FlashCard> flashCards;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          injector<FlashCardLearnFlipCubit>()..init(flashCards, title),
      child: Page(),
    );
  }
}

class Page extends StatelessWidget {
  const Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: BlocSelector<FlashCardLearnFlipCubit, FlashCardLearnFlipState,
            String>(
          selector: (state) {
            return state.title;
          },
          builder: (context, title) {
            return Text('Flashcards: $title');
          },
        ),
      ),
      body: BlocBuilder<FlashCardLearnFlipCubit, FlashCardLearnFlipState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () =>
                        context.read<FlashCardLearnFlipCubit>().flipCard(),
                    child: FlipCard(
                      animationDuration: Duration(milliseconds: 300),
                      rotateSide:
                          state.isFlipped ? RotateSide.right : RotateSide.left,
                      onTapFlipping:
                          false, //When enabled, the card will flip automatically when touched.
                      axis: FlipAxis.vertical,
                      controller:
                          context.read<FlashCardLearnFlipCubit>().controller,
                      frontWidget: FlashcardFront(
                        key: ValueKey('front'),
                        word: state.flashCards[state.currentIndex].word,
                      ),
                      backWidget: FlashcardBack(
                        key: ValueKey('back'),
                        flashcard: state.flashCards[state.currentIndex],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: state.currentIndex > 0
                            ? () => context
                                .read<FlashCardLearnFlipCubit>()
                                .previousCard()
                            : null,
                        child: Text('Previous'),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () =>
                            context.read<FlashCardLearnFlipCubit>().flipCard(),
                        child: Text('Show Answer'),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed:
                            state.currentIndex < state.flashCards.length - 1
                                ? () => context
                                    .read<FlashCardLearnFlipCubit>()
                                    .nextCard()
                                : null,
                        child: Text('Next'),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.05,
              )
            ],
          );
        },
      ),
    );
  }
}

// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';
import 'package:toeic_desktop/ui/page/flash_card/set_flashcard/set_flash_card_cubit.dart';
import 'package:toeic_desktop/ui/page/flash_card/set_flashcard/set_flash_card_state.dart';
import 'package:toeic_desktop/ui/page/flash_card/set_flashcard/widgets/set_flash_card_learning_item.dart';

class SetFlashCardLearningPage extends StatefulWidget {
  const SetFlashCardLearningPage({super.key});

  @override
  State<SetFlashCardLearningPage> createState() =>
      _SetFlashCardLearningPageState();
}

class _SetFlashCardLearningPageState extends State<SetFlashCardLearningPage> {
  @override
  void initState() {
    super.initState();
    context.read<FlashCardCubit>().fetchFlashCardSetsLearning();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 16,
            ),
          ),
          BlocBuilder<FlashCardCubit, FlashCardState>(
            builder: (context, state) {
              if (state.loadStatusLearning == LoadStatus.loading) {
                return const SliverFillRemaining(
                  child: LoadingCircle(),
                );
              } else if (state.loadStatusLearning == LoadStatus.success) {
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverList.separated(
                    itemBuilder: (context, index) {
                      return SetFlashCardLearningItem(
                        flashcard: state.flashCardsLearning[index],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 16);
                    },
                    itemCount: state.flashCardsLearning.length,
                  ),
                );
              }
              return const SliverToBoxAdapter(child: SizedBox());
            },
          ),
          const SliverPadding(
            padding: EdgeInsets.only(bottom: 16),
            sliver: SliverToBoxAdapter(child: SizedBox()),
          ),
        ],
      ),
    );
  }
}

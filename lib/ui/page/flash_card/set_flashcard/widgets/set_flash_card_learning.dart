// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
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
          BlocConsumer<FlashCardCubit, FlashCardState>(
            listenWhen: (previous, current) =>
                previous.loadStatusLearning != current.loadStatusLearning ||
                previous.flashCardsLearning != current.flashCardsLearning,
            buildWhen: (previous, current) =>
                previous.loadStatusLearning != current.loadStatusLearning ||
                previous.flashCardsLearning != current.flashCardsLearning,
            listener: (context, state) {
              if (state.loadStatus == LoadStatus.failure) {
                AppNavigator(context: context).error(state.message);
              }
            },
            builder: (context, state) {
              if (state.loadStatus == LoadStatus.loading) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
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

class FlashCardMyListItem extends StatelessWidget {
  const FlashCardMyListItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Word learned',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    Icons.check_circle_outline_outlined,
                    color: Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '1,234',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              const Text(
                'You\'ve learned 1,234 words so far',
                style: TextStyle(
                  color: AppColors.textGray,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

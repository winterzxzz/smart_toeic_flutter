// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/page/set_flashcard/set_flash_card_cubit.dart';
import 'package:toeic_desktop/ui/page/set_flashcard/set_flash_card_state.dart';
import 'package:toeic_desktop/ui/page/set_flashcard/widgets/set_flash_card_learning_grid.dart';

class SetFlashCardLearningPage extends StatefulWidget {
  const SetFlashCardLearningPage({super.key});

  @override
  State<SetFlashCardLearningPage> createState() =>
      _SetFlashCardLearningPageState();
}

class _SetFlashCardLearningPageState extends State<SetFlashCardLearningPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Row(
              children: [
                FlashCardMyListItem(),
                const SizedBox(width: 16),
                FlashCardMyListItem(),
                const SizedBox(width: 16),
                FlashCardMyListItem(),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Flashcard Categories ',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
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
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state.loadStatusLearning == LoadStatus.success) {
                  return SetFlashCardLearningGrid(
                    flashcards: state.flashCardsLearning,
                  );
                }
                return const SizedBox();
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
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
    return Expanded(
        child: Card(
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Word learned'),
                  Icon(Icons.check_circle_outline_outlined,
                      color: Colors.green),
                ],
              ),
              Text(
                '1,234',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                'You\'ve learned 1,234 words so far',
                style: TextStyle(color: AppColors.textGray),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/page/flashcard/flash_card_cubit.dart';
import 'package:toeic_desktop/ui/page/flashcard/flash_card_state.dart';
import 'package:toeic_desktop/ui/page/flashcard/widgets/flash_card_my_list.dart';
import 'package:toeic_desktop/ui/page/flashcard/widgets/form_set_flash_card_dia_log.dart';
import 'package:toeic_desktop/ui/page/flashcard/widgets/set_flash_card_grid.dart';

class MyListFlashCardPage extends StatefulWidget {
  const MyListFlashCardPage({super.key});

  @override
  State<MyListFlashCardPage> createState() => _MyListFlashCardPageState();
}

class _MyListFlashCardPageState extends State<MyListFlashCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<FlashCardCubit, FlashCardState>(
        listener: (context, state) {
          if (state.loadStatus == LoadStatus.failure) {
            AppNavigator(context: context).error(state.message);
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => showCreateSetFlashCardDialog(context,
                      onSave: (title, description) {
                    context.read<FlashCardCubit>().createFlashCardSet(
                          title,
                          description,
                        );
                  }),
                  child: Container(
                    width: 150,
                    height: 45,
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.add, color: Colors.white),
                        Text(
                          'Create Flashcard',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Flashcard Categories ',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                BlocBuilder<FlashCardCubit, FlashCardState>(
                  builder: (context, state) {
                    if (state.loadStatus == LoadStatus.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state.loadStatus == LoadStatus.success) {
                      return SetFlashCardGrid(flashcards: state.flashCards);
                    }
                    return const SizedBox();
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

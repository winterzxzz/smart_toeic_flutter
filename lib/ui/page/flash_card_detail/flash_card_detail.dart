import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/page/flash_card_detail/flash_card_detail_cubit.dart';
import 'package:toeic_desktop/ui/page/flash_card_detail/flash_card_detail_state.dart';
import 'package:toeic_desktop/ui/page/flash_card_detail/widgets/flash_card_tile.dart';

class FlashCardDetailPage extends StatelessWidget {
  const FlashCardDetailPage({super.key, required this.setId});

  final String setId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          injector<FlashCardDetailCubit>()..fetchFlashCards(setId),
      child: const Page(),
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
        title: Text('Flashcards: IELTS Vocabulary'),
      ),
      body: BlocConsumer<FlashCardDetailCubit, FlashCardDetailState>(
        listener: (context, state) {
          if (state.loadStatus == LoadStatus.failure) {
            AppNavigator(context: context).error(state.message);
          }
        },
        builder: (context, state) {
          if (state.loadStatus == LoadStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.loadStatus == LoadStatus.success) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.sizeOf(context).width * 0.2),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        GoRouter.of(context)
                            .pushReplacementNamed(AppRouter.flashCardPractive);
                      },
                      child: Text('Luyện tập flashcards'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.sizeOf(context).width * 0.2),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        GoRouter.of(context)
                            .pushReplacementNamed(AppRouter.quizz);
                      },
                      child: Text('Làm quizz'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            GoRouter.of(context).pushReplacementNamed(
                                AppRouter.flashCardPractive);
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: const [
                                Icon(Icons.shuffle, color: Colors.blue),
                                SizedBox(width: 8),
                                Text('Xem ngẫu nhiên',
                                    style: TextStyle(color: Colors.blue)),
                              ],
                            ),
                          ),
                        ),
                        Text('List này có 100 từ', style: TextStyle()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...state.flashCards
                      .map((flashcard) => FlashcardTile(flashcard: flashcard))
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

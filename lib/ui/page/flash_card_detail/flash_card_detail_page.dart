import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/page/flash_card_detail/flash_card_detail_cubit.dart';
import 'package:toeic_desktop/ui/page/flash_card_detail/flash_card_detail_state.dart';
import 'package:toeic_desktop/ui/page/flash_card_detail/widgets/flash_card_tile.dart';
import 'package:toeic_desktop/ui/page/flash_card_detail/widgets/form_flash_card_dia_log.dart';

class FlashCardDetailPage extends StatelessWidget {
  const FlashCardDetailPage(
      {super.key, required this.setId, required this.title});

  final String setId;
  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          injector<FlashCardDetailCubit>()..fetchFlashCards(setId),
      child: Page(title: title, setId: setId),
    );
  }
}

class Page extends StatefulWidget {
  const Page({
    super.key,
    required this.title,
    required this.setId,
  });

  final String title;
  final String setId;

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<FlashCardDetailCubit, FlashCardDetailState>(
        listener: (context, state) {
          if (state.loadStatus == LoadStatus.failure) {
            AppNavigator(context: context).error(state.message);
          }
        },
        builder: (context, state) {
          if (state.loadStatus == LoadStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.loadStatus == LoadStatus.success) {
            if (state.flashCards.isEmpty) {
              return const Center(
                child: Text('Không có từ nào trong bộ flashcard này'),
              );
            }
            return CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  floating: true,
                snap: true,
                  title: BlocSelector<FlashCardDetailCubit, FlashCardDetailState,
                      List<FlashCard>>(
                    selector: (state) => state.flashCards,
                    builder: (context, flashCards) {
                      return Text(
                          'Flashcard: ${widget.title} (${flashCards.length} từ)');
                    },
                  ),
                  actions: [
                    PopupMenuButton<int>(
                      icon: Icon(Icons.more_vert),
                      color: Theme.of(context).cardColor,
                      offset: const Offset(0, 50),
                      onSelected: (value) {
                        if (value == 0) {
                        } else if (value == 1) {
                          showCreateFlashCardDialog(context,
                              onSave: (flashCardRequest) {
                            context.read<FlashCardDetailCubit>().createFlashCard(
                                  flashCardRequest.copyWith(
                                      setFlashcardId: widget.setId),
                                );
                          });
                        } else if (value == 2) {}
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem<int>(
                            value: 0,
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              Icon(Icons.edit),
                              const SizedBox(width: 10),
                              Text('Chỉnh sửa',
                                  style:
                                      const TextStyle(color: AppColors.actionMenuText))
                            ])),
                        PopupMenuItem<int>(
                            value: 1,
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              Icon(Icons.add),
                              const SizedBox(width: 10),
                              Text('Tạo từ mới',
                                  style:
                                      const TextStyle(color: AppColors.actionMenuText))
                            ])),
                        PopupMenuItem<int>(
                            value: 2,
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              Icon(Icons.add_circle_outline_rounded),
                              const SizedBox(width: 10),
                              Text('Tạo hàng loạt',
                                  style:
                                      const TextStyle(color: AppColors.actionMenuText))
                            ])),
                      ],
                    )
                  ],
                ),
                
                // Content
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.sizeOf(context).width * 0.1,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 32),
                      // Practice Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            GoRouter.of(context).pushReplacementNamed(
                              AppRouter.flashCardQuizz,
                              extra: {'id': widget.setId},
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.play_circle_outline_rounded),
                              SizedBox(width: 8),
                              Text('Luyện tập flashcards'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Random and Pause buttons row
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                final flashCards = context
                                    .read<FlashCardDetailCubit>()
                                    .state
                                    .flashCards;
                                GoRouter.of(context).pushNamed(
                                    AppRouter.flashCardPractive,
                                    extra: {
                                      'title': widget.title,
                                      'flashCards': flashCards,
                                    });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.shuffle),
                                  SizedBox(width: 8),
                                  Text(
                                    'Xem ngẫu nhiên',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.pause_circle_outline_rounded),
                                  SizedBox(width: 8),
                                  Text('Dừng học bộ này'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Flashcard tiles
                      ...state.flashCards.map(
                        (flashcard) => FlashcardTile(flashcard: flashcard),
                      ),
                    ]),
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

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
  const FlashCardDetailPage({
    super.key,
    required this.setId,
    required this.title,
  });

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
            return CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  pinned: true,
                  title: BlocSelector<FlashCardDetailCubit,
                      FlashCardDetailState, List<FlashCard>>(
                    selector: (state) => state.flashCards,
                    builder: (context, flashCards) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Flashcard: ${widget.title}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            '${flashCards.length} từ',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textGray,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        showCreateFlashCardDialog(context,
                            onSave: (flashCardRequest) {
                          context.read<FlashCardDetailCubit>().createFlashCard(
                                flashCardRequest.copyWith(
                                    setFlashcardId: widget.setId),
                              );
                        });
                      },
                    ),
                  ],
                ),

                // Content
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: state.flashCards.isEmpty
                      ? const SliverToBoxAdapter(
                          child: Center(
                            child: Column(
                              children: [
                                SizedBox(height: 100),
                                Text('Không có từ nào trong bộ flashcard này'),
                              ],
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildListDelegate([
                            const SizedBox(height: 16),
                            // Action Buttons
                            _buildActionButton(
                              context,
                              icon: Icons.play_circle_outline_rounded,
                              label: 'Luyện tập flashcards',
                              onPressed: () {
                                GoRouter.of(context).pushNamed(
                                  AppRouter.flashCardQuizz,
                                  extra: {'id': widget.setId},
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildActionButton(
                              context,
                              icon: Icons.shuffle,
                              label: 'Xem ngẫu nhiên',
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
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildActionButton(
                              context,
                              icon: Icons.pause_circle_outline_rounded,
                              label: 'Dừng học bộ này',
                              onPressed: () {},
                            ),
                            const SizedBox(height: 16),
                            // Flashcard tiles
                            ...state.flashCards.map(
                              (flashcard) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: FlashcardTile(flashcard: flashcard),
                              ),
                            ),
                            const SizedBox(height: 16),
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

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56, // Increased height for better touch target
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

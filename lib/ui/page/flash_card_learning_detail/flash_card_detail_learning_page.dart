import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_learning.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/set_flash_card/set_flash_card_learning.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/page/flash_card_learning_detail/flash_card_detail_learning_cubit.dart';
import 'package:toeic_desktop/ui/page/flash_card_learning_detail/flash_card_detail_learning_state.dart';
import 'package:toeic_desktop/ui/page/flash_card_learning_detail/widgets/flash_card_learning_tile.dart';

class FlashCardDetailLearningPage extends StatelessWidget {
  const FlashCardDetailLearningPage({
    super.key,
    required this.setFlashCardLearning,
  });

  final SetFlashCardLearning setFlashCardLearning;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<FlashCardDetailLearningCubit>()
        ..fetchFlashCards(setFlashCardLearning.id),
      child: Page(setFlashCardLearning: setFlashCardLearning),
    );
  }
}

class Page extends StatefulWidget {
  const Page({
    super.key,
    required this.setFlashCardLearning,
  });

  final SetFlashCardLearning setFlashCardLearning;

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final horizontalPadding =
        isMobile ? 16.0 : MediaQuery.sizeOf(context).width * 0.1;

    return Scaffold(
      body: BlocConsumer<FlashCardDetailLearningCubit,
          FlashCardDetailLearningState>(
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
                SliverAppBar(
                  floating: true,
                  snap: true,
                  automaticallyImplyLeading: false,
                  title: BlocSelector<FlashCardDetailLearningCubit,
                      FlashCardDetailLearningState, List<FlashCardLearning>>(
                    selector: (state) => state.flashCards,
                    builder: (context, flashCards) {
                      return Text(
                        'Flashcard: ${widget.setFlashCardLearning.setFlashcardId.title} (${flashCards.length} từ)',
                        style: TextStyle(
                          fontSize: isMobile ? 16 : 20,
                        ),
                      );
                    },
                  ),
                  actions: [
                    IconButton(
                      onPressed: _showStatusInfo,
                      icon: FaIcon(FontAwesomeIcons.circleInfo,
                          size: isMobile ? 14 : 16),
                    ),
                  ],
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 24),
                      if (isMobile) ...[
                        _buildActionButton(
                          onPressed: () {
                            GoRouter.of(context).pushNamed(
                              AppRouter.flashCardQuizz,
                              extra: {
                                'id': widget
                                    .setFlashCardLearning.setFlashcardId.id,
                              },
                            );
                          },
                          icon: Icons.play_circle_outline_rounded,
                          label: 'Luyện tập flashcards',
                        ),
                        const SizedBox(height: 12),
                        _buildActionButton(
                          onPressed: () {},
                          icon: Icons.pause_circle_outline_rounded,
                          label: 'Dừng học bộ này',
                        ),
                      ] else ...[
                        Row(
                          children: [
                            Expanded(
                              child: _buildActionButton(
                                onPressed: () {
                                  GoRouter.of(context).pushNamed(
                                    AppRouter.flashCardQuizz,
                                    extra: {
                                      'id': widget.setFlashCardLearning
                                          .setFlashcardId.id,
                                    },
                                  );
                                },
                                icon: Icons.play_circle_outline_rounded,
                                label: 'Luyện tập flashcards',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildActionButton(
                                onPressed: () {},
                                icon: Icons.pause_circle_outline_rounded,
                                label: 'Dừng học bộ này',
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 16),
                      ...state.flashCards.map((flashcard) =>
                          FlashCardLearningTile(flashcard: flashcard)),
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

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  void _showStatusInfo() {
    final isMobile = MediaQuery.of(context).size.width < 600;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Status Explanation',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isMobile ? 18 : 20,
              ),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            )
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mức độ ghi nhớ (Decay Score)',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: isMobile ? 16 : 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Biểu thị khả năng ghi nhớ tại thời điểm hiện tại:',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: isMobile ? 14 : 16,
                ),
              ),
              const SizedBox(height: 8),
              _buildStatusRow(
                '0.7 - 1.0',
                'Vùng nhớ ổn định: Bạn vẫn ghi nhớ tốt từ vựng này.',
                Colors.green,
                isMobile,
              ),
              _buildStatusRow(
                '0.5-0.7',
                'Vùng nhớ vừa: Bắt đầu quên, nhưng thông tin vẫn có thể phục hồi dễ dàng.',
                Colors.orange,
                isMobile,
              ),
              _buildStatusRow(
                '0-0.5',
                'Vùng quên sâu: Đã quên nhiều, phải ôn tập ngay để tránh mất hoàn toàn kiến thức.',
                Colors.red,
                isMobile,
              ),
              const SizedBox(height: 16),
              Text(
                'Mức độ ghi nhớ (Retention Score)',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: isMobile ? 16 : 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Biểu thị khả năng ghi nhớ tại thời điểm hiện tại:',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: isMobile ? 14 : 16,
                ),
              ),
              const SizedBox(height: 8),
              _buildStatusRow(
                  '4', 'Ghi nhớ tốt, quên khá chậm.', Colors.green, isMobile),
              _buildStatusRow('3-4', 'Ghi nhớ tốt, quên khá chậm.',
                  Colors.orange, isMobile),
              _buildStatusRow('2-3', 'Ghi nhớ trung bình, quên chậm hơn.',
                  Colors.orange, isMobile),
              _buildStatusRow(
                '1-2',
                'Ghi nhớ kém, thông tin bị lãng quên nhanh chóng.',
                Colors.red,
                isMobile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusRow(
      String range, String description, Color color, bool isMobile) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, color: color, size: isMobile ? 10 : 12),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '($range) $description',
              style: TextStyle(fontSize: isMobile ? 14 : 16),
            ),
          ),
        ],
      ),
    );
  }
}

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
  const FlashCardDetailLearningPage(
      {super.key, required this.setFlashCardLearning});

  final SetFlashCardLearning setFlashCardLearning;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          injector<FlashCardDetailLearningCubit>()..fetchFlashCards(setFlashCardLearning.id),
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
    return Scaffold(
        body: BlocConsumer<FlashCardDetailLearningCubit,
            FlashCardDetailLearningState>(listener: (context, state) {
          if (state.loadStatus == LoadStatus.failure) {
            AppNavigator(context: context).error(state.message);
          }
        }, builder: (context, state) {
          if (state.loadStatus == LoadStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.loadStatus == LoadStatus.success) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  title: BlocSelector<FlashCardDetailLearningCubit,
                      FlashCardDetailLearningState, List<FlashCardLearning>>(
                    selector: (state) => state.flashCards,
                    builder: (context, flashCards) {
                      return Text(
                          'Flashcard: ${widget.setFlashCardLearning.setFlashcardId.title} (${flashCards.length} từ)');
                    },
                  ),
                  actions: [
                    IconButton(
                        onPressed: _showStatusInfo,
                        icon: FaIcon(FontAwesomeIcons.circleInfo, size: 16)),
                  ],
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.sizeOf(context).width * 0.1),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                GoRouter.of(context).pushReplacementNamed(
                                    AppRouter.flashCardQuizz,
                                    extra: {
                                      'id': widget.setFlashCardLearning
                                          .setFlashcardId.id,
                                    });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.play_circle_outline_rounded),
                                  SizedBox(width: 8),
                                  Text('Luyện tập flashcards'),
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
                      ...state.flashCards.map((flashcard) =>
                          FlashCardLearningTile(flashcard: flashcard)),
                    ]),
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        }));
  }

  void _showStatusInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Status Explanation',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.close),
            )
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mức độ ghi nhớ (Decay Score)',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              'Biểu thị khả năng ghi nhớ tại thời điểm hiện tại:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            _buildStatusRow(
                '0.7 - 1.0',
                'Vùng nhớ ổn định: Bạn vẫn ghi nhớ tốt từ vựng này.',
                Colors.green),
            _buildStatusRow(
                '0.5-0.7',
                'Vùng nhớ vừa: Bắt đầu quên, nhưng thông tin vẫn có thể phục hồi dễ dàng.',
                Colors.orange),
            _buildStatusRow(
                '0-0.5',
                'Vùng quên sâu: Đã quên nhiều, phải ôn tập ngay để tránh mất hoàn toàn kiến thức.',
                Colors.red),
            SizedBox(height: 16),
            Text(
              'Mức độ ghi nhớ (Retention Score)',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              'Biểu thị khả năng ghi nhớ tại thời điểm hiện tại:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            _buildStatusRow('4', 'Ghi nhớ tốt, quên khá chậm.', Colors.green),
            _buildStatusRow(
                '3-4', 'Ghi nhớ tốt, quên khá chậm.', Colors.orange),
            _buildStatusRow(
                '2-3', 'Ghi nhớ trung bình, quên chậm hơn.', Colors.orange),
            _buildStatusRow('1-2',
                'Ghi nhớ kém, thông tin bị lãng quên nhanh chóng.', Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String range, String description, Color color) {
    return Row(
      children: [
        Icon(Icons.circle, color: color, size: 12),
        SizedBox(width: 8),
        Text('($range) $description'),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_learning.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/set_flash_card/set_flash_card_learning.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_learning_detail/flash_card_detail_learning_cubit.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_learning_detail/flash_card_detail_learning_state.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_learning_detail/widgets/flash_card_learning_tile.dart';

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
    final theme = Theme.of(context);
    return Scaffold(
      body: BlocConsumer<FlashCardDetailLearningCubit,
          FlashCardDetailLearningState>(
        listener: (context, state) {
          if (state.loadStatus == LoadStatus.failure) {
            AppNavigator(context: context).error(state.message);
          }
        },
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                leading: const LeadingBackButton(),
                snap: true,
                title: BlocSelector<FlashCardDetailLearningCubit,
                    FlashCardDetailLearningState, List<FlashCardLearning>>(
                  selector: (state) => state.flashCards,
                  builder: (context, flashCards) {
                    return Text(
                      '${widget.setFlashCardLearning.setFlashcardId.title} (${flashCards.length} ${S.current.words})',
                      style: theme.textTheme.titleMedium,
                    );
                  },
                ),
                actions: [
                  IconButton(
                    onPressed: _showStatusInfo,
                    icon: const FaIcon(FontAwesomeIcons.circleInfo, size: 16),
                  ),
                ],
              ),
              if (state.loadStatus == LoadStatus.loading)
                const SliverFillRemaining(
                  child: LoadingCircle(),
                )
              else if (state.loadStatus == LoadStatus.success)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 24),
                      CustomButton(
                        height: 50,
                        onPressed: () {
                          GoRouter.of(context).pushReplacementNamed(
                            AppRouter.flashCardQuizz,
                            extra: {
                              'id':
                                  widget.setFlashCardLearning.setFlashcardId.id,
                            },
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.play_circle_outline_rounded),
                            const SizedBox(width: 8),
                            Text(S.current.practive_flashcard),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...state.flashCards.map((flashcard) =>
                          FlashCardLearningTile(flashcard: flashcard)),
                    ]),
                  ),
                ),
            ],
          );
        },
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
              onPressed: () => GoRouter.of(context).pop(),
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

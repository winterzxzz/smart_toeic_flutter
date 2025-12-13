import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/common/utils/utils.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';
import 'package:toeic_desktop/ui/common/widgets/no_data_found_widget.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_detail/flash_card_detail_cubit.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_detail/flash_card_detail_state.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_detail/widgets/flash_card_tile.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_detail/widgets/form_flash_card_dia_log.dart';

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
  late final FlashCardDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<FlashCardDetailCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return Scaffold(
      body: BlocBuilder<FlashCardDetailCubit, FlashCardDetailState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                pinned: true,
                leading: const LeadingBackButton(),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: textTheme.titleMedium?.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${state.flashCards.length} ${S.current.words}',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textGray,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      _showForm();
                    },
                  ),
                ],
              ),
              if (state.loadStatus == LoadStatus.loading)
                const SliverFillRemaining(
                  child: LoadingCircle(),
                )
              else ...[
                if (state.flashCards.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          SizedBox(height: 16.h),
                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: _buildActionButton(
                                  context,
                                  icon: Icons.play_circle_outline_rounded,
                                  label: S.current.practice_flashcards,
                                  onPressed: () {
                                    GoRouter.of(context).pushNamed(
                                      AppRouter.flashCardQuizz,
                                      extra: {'id': widget.setId},
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: _buildActionButton(
                                  context,
                                  icon: Icons.shuffle,
                                  label: S.current.view_randomly,
                                  onPressed: () {
                                    GoRouter.of(context).pushNamed(
                                      AppRouter.flashCardLearnFlip,
                                      extra: {
                                        'title': widget.title,
                                        'flashCards': _cubit.state.flashCards,
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                        ],
                      ),
                    ),
                  ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  sliver: state.flashCards.isEmpty
                      ? const SliverFillRemaining(
                          child: NotDataFoundWidget(),
                        )
                      : SliverList.separated(
                          itemBuilder: (context, index) =>
                              FlashcardTile(flashcard: state.flashCards[index]),
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 12.h),
                          itemCount: state.flashCards.length,
                        ),
                ),
              ]
            ],
          );
        },
      ),
    );
  }

  void _showForm() {
    Utils.showModalBottomSheetForm(
      context: context,
      title: S.current.add_new_word,
      child: BlocProvider.value(
        value: _cubit,
        child: FlashCardDetailForm(
          args: FlashCardDetailFormArgs(
            type: FlashCardDetailFormType.create,
            setFlashcardId: widget.setId,
            onSave: (flashCardRequest) {
              _cubit.createFlashCard(flashCardRequest);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    final colorScheme = context.colorScheme;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28.spMin, color: colorScheme.primary),
            SizedBox(height: 8.h),
            Text(
              label,
              style: context.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

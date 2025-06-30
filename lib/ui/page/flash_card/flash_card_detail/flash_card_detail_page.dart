import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/configs/app_configs.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/common/utils/utils.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';
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
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<FlashCardDetailCubit>();
    if (injector<UserCubit>().state.user != null &&
        injector<UserCubit>().state.user!.isPremium() == false) {
      _bannerAd = BannerAd(
        adUnitId: AppConfigs.bannerAdUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (_) => setState(() => _isBannerAdReady = true),
        ),
      )..load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      '${state.flashCards.length} ${S.current.words}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textGray,
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
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          // Action Buttons
                          _buildActionButton(
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
                          const SizedBox(height: 12),
                          _buildActionButton(
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
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  sliver: state.flashCards.isEmpty
                      ? SliverToBoxAdapter(
                          child: Center(
                            child: Column(
                              children: [
                                const SizedBox(height: 100),
                                Text(S.current.no_words_in_flash_card,
                                    style: theme.textTheme.bodyMedium),
                              ],
                            ),
                          ),
                        )
                      : SliverList.separated(
                          itemBuilder: (context, index) =>
                              FlashcardTile(flashcard: state.flashCards[index]),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemCount: state.flashCards.length,
                        ),
                ),
              ]
            ],
          );
        },
      ),
      bottomNavigationBar: _isBannerAdReady
          ? SizedBox(
              width: _bannerAd.size.width.toDouble(),
              height: _bannerAd.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd),
            )
          : null,
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
    return CustomButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 12),
          Text(label),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/configs/app_configs.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/widgets/confirm_dia_log.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_cubit.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_state.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/widgets/processing_indicator.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/widgets/transcript__test_body.dart';

class TranscriptTestDetailPage extends StatelessWidget {
  const TranscriptTestDetailPage(
      {super.key, required this.transcriptTestId, required this.title});

  final String transcriptTestId;
  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<TranscriptTestDetailCubit>()
        ..getTranscriptTestDetail(transcriptTestId),
      child: Page(title: title),
    );
  }
}

class Page extends StatefulWidget {
  const Page({super.key, required this.title});

  final String title;

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> with TickerProviderStateMixin {
  late AnimationController _timerController;
  late TranscriptTestDetailCubit _cubit;
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _cubit = context.read<TranscriptTestDetailCubit>();
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
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TranscriptTestDetailCubit, TranscriptTestDetailState>(
      listenWhen: (previous, current) =>
          previous.loadStatus != current.loadStatus ||
          previous.isCorrect != current.isCorrect,
      listener: (context, state) {
        if (state.isCorrect) {
          _timerController.reset();
          _timerController.forward();
        } else {
          _timerController.stop();
        }
      },
      buildWhen: (previous, current) =>
          previous.loadStatus != current.loadStatus ||
          previous.isCorrect != current.isCorrect,
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              alignment: Alignment.center,
              children: [
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      title: Text(widget.title),
                      leading: LeadingBackButton(
                        isClose: true,
                        onPressed: () {
                          showConfirmDialog(context, S.current.exit,
                              S.current.are_you_sure_exit, () {
                            GoRouter.of(context).pop();
                          });
                        },
                      ),
                      pinned: true,
                      floating: false,
                      expandedHeight:
                          state.loadStatus == LoadStatus.success ? 50.0 : null,
                      bottom: state.loadStatus == LoadStatus.success
                          ? const PreferredSize(
                              preferredSize: Size.fromHeight(5),
                              child: ProcessingIndicator(),
                            )
                          : null,
                    ),
                    SliverFillRemaining(
                      child: state.loadStatus == LoadStatus.loading
                          ? const LoadingCircle()
                          : state.loadStatus == LoadStatus.success
                              ? const TranscriptTestBody()
                              : const SizedBox.shrink(),
                    ),
                  ],
                ),
                if (state.isCorrect) ...[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        color: state.isCorrect
                            ? Colors.green[200]
                            : Colors.red[200],
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedBuilder(
                            animation: _timerController,
                            builder: (context, child) {
                              return LinearProgressIndicator(
                                value: _timerController.value,
                                backgroundColor: Colors.transparent,
                                color:
                                    state.isCorrect ? Colors.green : Colors.red,
                                minHeight: 3,
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: FaIcon(
                                    state.isCorrect
                                        ? FontAwesomeIcons.check
                                        : FontAwesomeIcons.xmark,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  state.isCorrect
                                      ? S.current.great
                                      : S.current.try_harder,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  state.isCorrect
                                      ? S.current.you_answered_correctly
                                      : S.current.you_answered_incorrectly,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                BlocBuilder<TranscriptTestDetailCubit,
                                    TranscriptTestDetailState>(
                                  buildWhen: (previous, current) =>
                                      previous.currentIndex !=
                                          current.currentIndex ||
                                      previous.transcriptTests !=
                                          current.transcriptTests,
                                  builder: (context, state) {
                                    final isLast = state.currentIndex >=
                                        state.transcriptTests.length - 1;
                                    return SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: state.isCorrect
                                              ? Colors.green
                                              : Colors.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () {
                                          if (isLast) {
                                            GoRouter.of(context).pop();
                                            return;
                                          }
                                          _cubit.nextTranscriptTest();
                                        },
                                        child: Text(
                                          isLast
                                              ? S.current.finish
                                              : S.current.next_question,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 16,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ],
            ),
            bottomNavigationBar: _isBannerAdReady
                ? SizedBox(
                    width: _bannerAd.size.width.toDouble(),
                    height: _bannerAd.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd),
                  )
                : null,
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/configs/app_configs.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/data/models/enums/test_show.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/common/widgets/confirm_dia_log.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';
import 'package:toeic_desktop/ui/page/test/practice_test/practice_test_cubit.dart';
import 'package:toeic_desktop/ui/page/test/practice_test/practice_test_state.dart';
import 'package:toeic_desktop/ui/page/test/practice_test/widgets/heading_practice_test.dart';
import 'package:toeic_desktop/ui/page/test/practice_test/widgets/question_index.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/test/practice_test/widgets/question.dart';

class PracticeTestArgs {
  final String title;
  final TestShow testShow;
  final List<PartEnum> parts;
  final Duration duration;
  final String testId;
  final String? resultId;

  PracticeTestArgs({
    required this.title,
    required this.testShow,
    required this.parts,
    required this.duration,
    required this.testId,
    this.resultId,
  });
}

class PracticeTestPage extends StatefulWidget {
  const PracticeTestPage({
    super.key,
    required this.args,
  });

  final PracticeTestArgs args;

  @override
  State<PracticeTestPage> createState() => _PracticeTestPageState();
}

class _PracticeTestPageState extends State<PracticeTestPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          injector<PracticeTestCubit>()..initPracticeTest(widget.args),
      child: Page(testShow: widget.args.testShow),
    );
  }
}

class Page extends StatefulWidget {
  const Page({
    super.key,
    required this.testShow,
  });

  final TestShow testShow;

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  late final PracticeTestCubit _cubit;
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  @override
  void initState() {
    super.initState();
    _cubit = context.read<PracticeTestCubit>();
    if (injector<UserCubit>().state.user != null &&
        injector<UserCubit>().state.user!.isPremium() == false) {
      _bannerAd = BannerAd(
        adUnitId: AppConfigs.testAdUnitId,
        request: const AdRequest(),
        size: AdSize.fullBanner,
        listener: BannerAdListener(
          onAdLoaded: (_) => setState(() => _isBannerAdReady = true),
        ),
      )..load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final navigator = AppNavigator(context: context);
    return BlocListener<PracticeTestCubit, PracticeTestState>(
      listenWhen: (previous, current) =>
          previous.loadStatus != current.loadStatus,
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.loading) {
          navigator.showLoadingOverlay(message: S.current.please_wait);
        } else {
          navigator.hideLoadingOverlay();
        }
      },
      child: BlocListener<PracticeTestCubit, PracticeTestState>(
        listenWhen: (previous, current) {
          return previous.loadStatusSubmit != current.loadStatusSubmit;
        },
        listener: (context, state) {
          if (state.loadStatusSubmit == LoadStatus.loading) {
            navigator.showLoadingOverlay(message: S.current.submitting);
          } else {
            navigator.hideLoadingOverlay();
            if (state.loadStatusSubmit == LoadStatus.success) {
              navigator.pushReplacementNamed(AppRouter.resultTest,
                  extra: {'resultModel': state.resultModel});
            } else {
              navigator.error(state.message);
            }
          }
        },
        child: PopScope(
          canPop: widget.testShow == TestShow.test ? false : true,
          child: SafeArea(
            child: Scaffold(
              endDrawer: const QuestionIndex(),
              body: BlocBuilder<PracticeTestCubit, PracticeTestState>(
                buildWhen: (previous, current) =>
                    previous.questions != current.questions ||
                    previous.focusPart != current.focusPart ||
                    previous.parts != current.parts,
                builder: (context, state) {
                  final questions = state.questions
                      .where((q) => q.part == state.focusPart.numValue)
                      .toList();
                  return CustomScrollView(
                    controller: _cubit.scrollController,
                    slivers: [
                      SliverAppBar(
                        leading: LeadingBackButton(
                          isClose: true,
                          onPressed: () {
                            showConfirmDialog(
                              context,
                              S.current.exit,
                              S.current.are_you_sure_exit,
                              () {
                                GoRouter.of(context).pop();
                                if (widget.testShow == TestShow.test) {
                                  GoRouter.of(context).pop();
                                }
                              },
                            );
                          },
                        ),
                        automaticallyImplyLeading: false,
                        toolbarHeight: 55,
                        floating: true,
                        title: const HeadingPracticeTest(),
                        actions: [
                          IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () {
                              Scaffold.of(context).openEndDrawer();
                            },
                          )
                        ],
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _PartSelectorHeaderDelegate(
                          parts: state.parts,
                          focusPart: state.focusPart,
                          onTap: (part) => _cubit.setFocusPart(part),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        sliver: SuperSliverList.builder(
                          listController: _cubit.listController,
                          itemBuilder: (context, index) {
                            return QuestionWidget(question: questions[index]);
                          },
                          itemCount: questions.length,
                        ),
                      ),
                    ],
                  );
                },
              ),
              bottomNavigationBar: BottomAppBar(
                padding: const EdgeInsets.only(left: 16, right: 8),
                height: widget.testShow == TestShow.result
                    ? 0
                    : 56 +
                        (_isBannerAdReady
                            ? _bannerAd.size.height.toDouble()
                            : 0),
                child: widget.testShow == TestShow.result
                    ? null
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (_isBannerAdReady)
                            SizedBox(
                              width: double.infinity,
                              height: _bannerAd.size.height.toDouble(),
                              child: AdWidget(ad: _bannerAd),
                            ),
                          Row(children: [
                            BlocBuilder<PracticeTestCubit, PracticeTestState>(
                              buildWhen: (previous, current) =>
                                  previous.duration != current.duration,
                              builder: (context, state) {
                                return Text(
                                  '${state.duration.inMinutes}:${state.duration.inSeconds % 60 < 10 ? '0' : ''}${state.duration.inSeconds % 60}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: CustomButton(
                                height: 50,
                                onPressed: () {
                                  showConfirmDialog(
                                      context,
                                      S.current.are_you_sure,
                                      S.current.are_you_sure_submit_test, () {
                                    _cubit.submitTest();
                                  });
                                },
                                child: Text(S.current.submit),
                              ),
                            ),
                          ]),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PartSelectorHeaderDelegate extends SliverPersistentHeaderDelegate {
  final List<PartEnum> parts;
  final PartEnum focusPart;
  final ValueChanged<PartEnum> onTap;

  _PartSelectorHeaderDelegate({
    required this.parts,
    required this.focusPart,
    required this.onTap,
  });

  @override
  double get minExtent => 50;
  @override
  double get maxExtent => 50;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final theme = context.theme;
    return Container(
      color: theme.appBarTheme.backgroundColor,
      height: 50,
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.only(left: 8, right: 8, bottom: 4, top: 4),
              itemCount: parts.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) => InkWell(
                onTap: () => onTap(parts[index]),
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: parts[index].numValue == focusPart.numValue
                          ? colorScheme.primary
                          : colorScheme.brightness == Brightness.dark
                              ? AppColors.backgroundDarkSub
                              : AppColors.backgroundLightSub,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      parts[index].name,
                      style: textTheme.bodyMedium?.copyWith(
                        color: parts[index].numValue == focusPart.numValue
                            ? AppColors.textWhite
                            : null,
                      ),
                    )),
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/configs/app_configs.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/data/models/entities/profile/user_entity.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';
import 'package:toeic_desktop/ui/page/personal_analysis/analysis_cubit.dart';
import 'package:toeic_desktop/ui/page/personal_analysis/analysis_state.dart';
import 'package:toeic_desktop/ui/page/personal_analysis/widgets/analysis_markdown.dart';
import 'package:toeic_desktop/ui/page/personal_analysis/widgets/analysis_percentage.dart';
import 'package:toeic_desktop/ui/page/personal_analysis/widgets/analysis_score.dart';
import 'package:toeic_desktop/ui/page/personal_analysis/widgets/analysis_time.dart';
import 'package:toeic_desktop/ui/page/personal_analysis/widgets/chart.dart';

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<AnalysisCubit>()..fetchProfileAnalysis(),
      child: const Page(),
    );
  }
}

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  late final AnalysisCubit analysisCubit;
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  @override
  void initState() {
    super.initState();
    analysisCubit = context.read<AnalysisCubit>();
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
    return Scaffold(
      body: BlocBuilder<AnalysisCubit, AnalysisState>(
        builder: (context, state) {
          return CustomScrollView(
            controller: analysisCubit.scrollController,
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: true,
                centerTitle: true,
                title: Text(S.current.toeic_performance_dashboard),
                leading: const LeadingBackButton(),
                floating: true,
              ),
              if (state.loadStatus == LoadStatus.loading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: LoadingCircle(),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state.profileAnalysis.score != null)
                          AnalysisScore(
                            overallScore: state.profileAnalysis.score!,
                            listenScore: state.profileAnalysis.listenScore!,
                            readScore: state.profileAnalysis.readScore!,
                          ),
                        const SizedBox(height: 16),
                        if (state.profileAnalysis.accuracyByPart != null &&
                            state.profileAnalysis.accuracyByPart!.isNotEmpty)
                          AnalysisPercentage(
                            percentage: state.profileAnalysis.accuracyByPart!,
                          ),
                        const SizedBox(height: 16),
                        if (state.profileAnalysis.averageTimeByPart != null &&
                            state.profileAnalysis.averageTimeByPart!.isNotEmpty)
                          AnalysisTime(
                            averageTimeByPart:
                                state.profileAnalysis.averageTimeByPart!,
                            timeSecondRecommend:
                                state.profileAnalysis.timeSecondRecommend!,
                          ),
                        const SizedBox(height: 16),
                        if (state.profileAnalysis.categoryAccuracy != null &&
                            state.profileAnalysis.categoryAccuracy!.isNotEmpty)
                          StackedBarChartPage(
                            categoryAccuracys:
                                state.profileAnalysis.categoryAccuracy!,
                          ),
                        const SizedBox(height: 32),
                        BlocSelector<UserCubit, UserState, UserEntity?>(
                          selector: (state) => state.user,
                          builder: (context, user) {
                            final isPremium = user?.isPremium();
                            return SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: CustomButton(
                                isLoading: state.suggestForStudyStatus ==
                                    LoadStatus.loading,
                                onPressed: isPremium == true ||
                                        state.suggestForStudyStatus ==
                                            LoadStatus.success
                                    ? () {
                                        analysisCubit.fetchSuggestForStudy();
                                      }
                                    : null,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (isPremium == true)
                                      const FaIcon(FontAwesomeIcons.chartLine)
                                    else
                                      const FaIcon(FontAwesomeIcons.lock),
                                    const SizedBox(width: 8),
                                    Text(S.current.analysis_your_score),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        if (state.suggestForStudy.isNotEmpty)
                          AnalysisMarkdown(text: state.suggestForStudy),
                      ],
                    ),
                  ),
                ),
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
}

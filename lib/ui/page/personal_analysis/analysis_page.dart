import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/data/models/entities/profile/user_entity.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
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

class Page extends StatelessWidget {
  const Page({super.key});

  @override
  Widget build(BuildContext context) {
    final navigator = AppNavigator(context: context);
    return Scaffold(
      body: BlocConsumer<AnalysisCubit, AnalysisState>(
        listener: (context, state) {
          if (state.loadStatus == LoadStatus.loading) {
            navigator.showLoadingOverlay();
          } else {
            navigator.hideLoadingOverlay();
            if (state.loadStatus == LoadStatus.failure) {
              showToast(title: state.message, type: ToastificationType.error);
            }
          }
        },
        builder: (context, state) {
          return CustomScrollView(
            controller: context.read<AnalysisCubit>().scrollController,
            slivers: [
              const SliverAppBar(
                automaticallyImplyLeading: true,
                centerTitle: true,
                title: Text('TOEIC Performance Dashboard'),
                leading: LeadingBackButton(),
                floating: true,
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state.profileAnalysis.score != null)
                            AnalysisScore(
                              overallScore: state.profileAnalysis.score!,
                              listenScore: state.profileAnalysis.listenScore!,
                              readScore: state.profileAnalysis.readScore!,
                            ),
                          const SizedBox(height: 24),
                          if (state.profileAnalysis.accuracyByPart != null &&
                              state.profileAnalysis.accuracyByPart!.isNotEmpty)
                            AnalysisPercentage(
                              percentage: state.profileAnalysis.accuracyByPart!,
                            ),
                          const SizedBox(height: 24),
                          if (state.profileAnalysis.averageTimeByPart != null &&
                              state.profileAnalysis.averageTimeByPart!
                                  .isNotEmpty)
                            AnalysisTime(
                              averageTimeByPart:
                                  state.profileAnalysis.averageTimeByPart!,
                              timeSecondRecommend:
                                  state.profileAnalysis.timeSecondRecommend!,
                            ),
                          const SizedBox(height: 24),
                          if (state.profileAnalysis.categoryAccuracy != null &&
                              state
                                  .profileAnalysis.categoryAccuracy!.isNotEmpty)
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
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: isPremium == true
                                      ? () {
                                          context
                                              .read<AnalysisCubit>()
                                              .fetchSuggestForStudy();
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
                                      const Text('Analysis Your Score'),
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
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

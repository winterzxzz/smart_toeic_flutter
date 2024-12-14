import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/analysis/analysis_cubit.dart';
import 'package:toeic_desktop/ui/page/analysis/analysis_state.dart';
import 'package:toeic_desktop/ui/page/analysis/widgets/analysis_markdown.dart';
import 'package:toeic_desktop/ui/page/analysis/widgets/analysis_percentage.dart';
import 'package:toeic_desktop/ui/page/analysis/widgets/analysis_score.dart';
import 'package:toeic_desktop/ui/page/analysis/widgets/analysis_time.dart';
import 'package:toeic_desktop/ui/page/analysis/widgets/chart.dart';

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
  const Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AnalysisCubit, AnalysisState>(
        listener: (context, state) {
          if (state.loadStatus == LoadStatus.failure) {
            showToast(title: state.message, type: ToastificationType.error);
          }
        },
        builder: (context, state) {
          if (state.loadStatus == LoadStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.loadStatus == LoadStatus.success) {
            return CustomScrollView(
              slivers: [
                const SliverAppBar(
                  automaticallyImplyLeading: false,
                  title: Text('TOEIC Performance Dashboard'),
                  floating: true,
                  snap: true,
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 16,
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: AnalysisScore(
                                  overallScore: state.profileAnalysis.score,
                                  listenScore:
                                      state.profileAnalysis.listenScore,
                                  readScore: state.profileAnalysis.readScore,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 32),
                                    AnalysisPercentage(
                                      percentage:
                                          state.profileAnalysis.accuracyByPart,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: AnalysisTime(
                                  averageTimeByPart:
                                      state.profileAnalysis.averageTimeByPart,
                                  timeSecondRecommend:
                                      state.profileAnalysis.timeSecondRecommend,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 2,
                                child: StackedBarChartPage(
                                  categoryAccuracys:
                                      state.profileAnalysis.categoryAccuracy,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          AnalysisMarkdown(text: state.suggestForStudy),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

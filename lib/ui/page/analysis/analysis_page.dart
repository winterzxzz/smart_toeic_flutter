import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/data/models/entities/profile/user_entity.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: AnalysisScore(
                                overallScore: state.profileAnalysis.score ?? 0,
                                listenScore:
                                    state.profileAnalysis.listenScore ?? 0,
                                readScore: state.profileAnalysis.readScore ?? 0,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child:
                                  state.profileAnalysis.accuracyByPart != null
                                      ? Column(
                                          children: [
                                            const SizedBox(height: 32),
                                            AnalysisPercentage(
                                              percentage: state.profileAnalysis
                                                  .accuracyByPart!,
                                            ),
                                          ],
                                        )
                                      : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: state.profileAnalysis.averageTimeByPart !=
                                      null
                                  ? AnalysisTime(
                                      averageTimeByPart: state
                                          .profileAnalysis.averageTimeByPart!,
                                      timeSecondRecommend: state
                                          .profileAnalysis.timeSecondRecommend!,
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child:
                                  state.profileAnalysis.categoryAccuracy != null
                                      ? StackedBarChartPage(
                                          categoryAccuracys: state
                                              .profileAnalysis
                                              .categoryAccuracy!,
                                        )
                                      : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        BlocSelector<UserCubit, UserState, UserEntity?>(
                          selector: (state) {
                            return state.user;
                          },
                          builder: (context, user) {
                            final isPremium = user?.isPremium();
                            return ElevatedButton(
                              onPressed: isPremium == true
                                  ? () {
                                      context
                                          .read<AnalysisCubit>()
                                          .fetchSuggestForStudy();
                                    }
                                  : null,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (isPremium == true)
                                    FaIcon(FontAwesomeIcons.chartLine)
                                  else
                                    FaIcon(FontAwesomeIcons.lock),
                                  const SizedBox(width: 8),
                                  Text('Analysis Your Score'),
                                ],
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
            ],
          );
        },
      ),
    );
  }
}

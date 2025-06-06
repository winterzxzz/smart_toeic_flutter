import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/test/history_test/history_test_cubit.dart';
import 'package:toeic_desktop/ui/page/test/history_test/history_test_state.dart';
import 'package:toeic_desktop/ui/page/home/widgets/result_card.dart';

class HistoryTestPage extends StatelessWidget {
  const HistoryTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<HistoryTestCubit>()..getResultTests(),
      child: const Page(),
    );
  }
}

class Page extends StatelessWidget {
  const Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: true,
            title: Text(S.current.history_test),
            floating: true,
            leading: const LeadingBackButton(),
          ),
          BlocConsumer<HistoryTestCubit, HistoryTestState>(
            listener: (context, state) {
              if (state.loadStatus == LoadStatus.failure) {
                showToast(title: state.message, type: ToastificationType.error);
              }
            },
            builder: (context, state) {
              if (state.loadStatus == LoadStatus.loading) {
                return const SliverFillRemaining(
                  child: LoadingCircle(),
                );
              }
              if (state.loadStatus == LoadStatus.success) {
                if (state.results.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(child: Text(S.current.no_data_found)),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16),
                  sliver: SliverList.separated(
                    itemBuilder: (context, index) => ExamResultCard(
                      result: state.results[index],
                    ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemCount: state.results.length,
                  ),
                );
              }
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),
        ],
      ),
    );
  }
}

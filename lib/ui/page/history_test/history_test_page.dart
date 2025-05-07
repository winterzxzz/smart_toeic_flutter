import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/history_test/history_test_cubit.dart';
import 'package:toeic_desktop/ui/page/history_test/history_test_state.dart';
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
            title: const Text('History Test'),
            floating: true,
            pinned: true,
            elevation: 0,
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
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (state.loadStatus == LoadStatus.success) {
                if (state.results.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text('No data')),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: ExamResultCard(
                          result: state.results[index],
                        ),
                      ),
                      childCount: state.results.length,
                    ),
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

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return 1; // Single column for mobile
    } else if (width < 900) {
      return 2; // Two columns for tablets
    }
    return 3; // Three columns for larger screens
  }
}

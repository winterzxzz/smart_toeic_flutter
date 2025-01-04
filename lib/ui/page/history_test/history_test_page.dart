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
      child: Page(),
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
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            automaticallyImplyLeading: false,
            title: Text('History Test'),
            floating: true,
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
                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.4,
                    mainAxisExtent: 270,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        ExamResultCard(result: state.results[index]),
                    childCount: state.results.length,
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

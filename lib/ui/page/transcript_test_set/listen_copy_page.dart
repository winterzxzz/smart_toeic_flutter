import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/transcript_test_set/listen_copy_cubit.dart';
import 'package:toeic_desktop/ui/page/transcript_test_set/listen_copy_state.dart';
import 'package:toeic_desktop/ui/page/transcript_test_set/widgets/transcript_test_item.dart';

class ListenCopyPage extends StatelessWidget {
  const ListenCopyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<ListenCopyCubit>()..getTranscriptTests(),
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
    return BlocConsumer<ListenCopyCubit, ListenCopyState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.failure) {
          showToast(title: state.message, type: ToastificationType.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          body: Row(
            children: [
              SizedBox(
                width: (MediaQuery.of(context).size.width - 60) * 0.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        context.read<ListenCopyCubit>().toggleFilter();
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            Text(
                              'Bộ lọc',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            AnimatedRotation(
                              duration: const Duration(milliseconds: 200),
                              turns: state.isFilterOpen ? 0 : 0.5,
                              child: Icon(Icons.keyboard_arrow_up),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: state.isFilterOpen ? 350 : 0,
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            const Divider(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: List.generate(
                                  4,
                                  (index) => CheckboxListTile(
                                    title: Text('Part ${index + 1}'),
                                    value: state.filterParts
                                        .contains('${index + 1}'),
                                    onChanged: (value) {
                                      context
                                          .read<ListenCopyCubit>()
                                          .setFilterPart('${index + 1}');
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: state.loadStatus == LoadStatus.loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : state.filteredTranscriptTestSets.isEmpty
                        ? const Center(
                            child: Text('Không có bài tập nào'),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.all(24.0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 24,
                              mainAxisSpacing: 24,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: state.filteredTranscriptTestSets.length,
                            itemBuilder: (context, index) {
                              final test =
                                  state.filteredTranscriptTestSets[index];
                              return TranscriptTestItem(test: test);
                            },
                          ),
              ),
            ],
          ),
        );
      },
    );
  }
}

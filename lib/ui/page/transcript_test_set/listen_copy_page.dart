import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';
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
      child: const Page(),
    );
  }
}

class Page extends StatelessWidget {
  const Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ListenCopyCubit, ListenCopyState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.failure) {
          showToast(title: state.message, type: ToastificationType.error);
        }
      },
      builder: (context, state) {
        // Make sure state isn't null
        return Scaffold(
          endDrawer: Drawer(
            backgroundColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.center,
                      child: const Row(
                        children: [
                          Text(
                            'Filter',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Divider(),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: _FilterOptions(),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          body: CustomScrollView(
            slivers: [
              const SliverAppBar(
                title: Text('Test Listening'),
                centerTitle: true,
                floating: true,
                snap: true,
                leading: LeadingBackButton(),
              ),
              if (state.loadStatus == LoadStatus.loading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (state.filteredTranscriptTestSets.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: Text('No test found'),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverList.separated(
                    itemCount: state.filteredTranscriptTestSets.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final test = state.filteredTranscriptTestSets[index];
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

class _FilterOptions extends StatelessWidget {
  const _FilterOptions();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListenCopyCubit, ListenCopyState>(
      builder: (context, state) {
        return Column(
          children: List.generate(
            4,
            (index) => CheckboxListTile(
              title: Text('Part ${index + 1}'),
              value: state.filterParts.contains('${index + 1}'),
              onChanged: (value) {
                context.read<ListenCopyCubit>().setFilterPart('${index + 1}');
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        );
      },
    );
  }
}

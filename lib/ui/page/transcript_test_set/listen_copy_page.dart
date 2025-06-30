import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';
import 'package:toeic_desktop/ui/common/widgets/no_data_found_widget.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/transcript_test_set/listen_copy_cubit.dart';
import 'package:toeic_desktop/ui/page/transcript_test_set/listen_copy_state.dart';
import 'package:toeic_desktop/ui/page/transcript_test_set/widgets/filter_option.dart';
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

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
            backgroundColor: theme.appBarTheme.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Text(
                          S.current.filter,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  const Expanded(child: FilterOptions()),
                ],
              ),
            ),
          ),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(S.current.test_listening),
                centerTitle: true,
                floating: true,
                snap: true,
                leading: const LeadingBackButton(),
              ),
              if (state.loadStatus == LoadStatus.loading)
                const SliverFillRemaining(
                  child: LoadingCircle(),
                )
              else if (state.filteredTranscriptTestSets.isEmpty)
                const SliverFillRemaining(
                  child: NotDataFoundWidget(),
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

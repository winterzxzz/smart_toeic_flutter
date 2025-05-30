import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_cubit.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_state.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/widgets/question_list.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/widgets/transcript__test_body.dart';

class TranscriptTestDetailPage extends StatelessWidget {
  const TranscriptTestDetailPage({super.key, required this.transcriptTestId});

  final String transcriptTestId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<TranscriptTestDetailCubit>()
        ..getTranscriptTestDetail(transcriptTestId),
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<TranscriptTestDetailCubit, TranscriptTestDetailState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.failure) {
          showToast(title: state.message, type: ToastificationType.error);
        }
      },
      buildWhen: (previous, current) =>
          previous.loadStatus != current.loadStatus,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(S.current.transcript_test),
            leading: const LeadingBackButton(),
          ),
          endDrawer: state.loadStatus == LoadStatus.success
              ? Drawer(
                  backgroundColor: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      child: const QuestionList(),
                    ),
                  ),
                )
              : null,
          backgroundColor: theme.appBarTheme.backgroundColor,
          body: state.loadStatus == LoadStatus.loading
              ? const LoadingCircle()
              : const TranscriptTestBody(),
        );
      },
    );
  }
}

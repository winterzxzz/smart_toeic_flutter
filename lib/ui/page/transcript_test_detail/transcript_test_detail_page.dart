import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/practice_test/widgets/audio_section.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_cubit.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_state.dart';

class TranscriptTestDetailPage extends StatelessWidget {
  const TranscriptTestDetailPage({super.key, required this.transcriptTestId});

  final String transcriptTestId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<TranscriptTestDetailCubit>()..getTranscriptTestDetail(transcriptTestId),
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
    final navigator = AppNavigator(context: context);
    return BlocConsumer<TranscriptTestDetailCubit, TranscriptTestDetailState>(
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
        if(state.loadStatus != LoadStatus.success) {
          return const SizedBox.shrink();
        }
        return Scaffold(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,  
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Thực hành nghe chép', style: Theme.of(context).textTheme.titleLarge), 
                    Text('${state.currentIndex + 1}/${state.transcriptTests.length}', style: Theme.of(context).textTheme.titleLarge)
                  ],
                ), 
                const SizedBox(height: 16),
                // audio section
                AudioSection(audioUrl: state.transcriptTests[state.currentIndex].audioUrl ?? ''),
                const SizedBox(height: 16),
                // transcript section
                TextField(
                  controller: TextEditingController(),
                  decoration: InputDecoration(
                    hintText: 'Nhập nội dung bạn nghe được...',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.inputBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.focusBorder ),
                    ),
                  ),
                ), 
                const SizedBox(height: 32),
                // button section
                Row(
                  children: [
                    SizedBox(height: 45, child: ElevatedButton(onPressed: () {}, child: Text('Kiểm tra'))),
                    const SizedBox(width: 32),
                    SizedBox(height: 45, child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {}, child: Row(
                      children: [
                        Icon(Icons.volume_up),  
                        const SizedBox( width: 8),
                        Text('Thực hành phát âm'),
                      ],
                    ))),
                  ],
                ) ,   
              ],
            ),
          ),
        );
      },
    );
  }
}

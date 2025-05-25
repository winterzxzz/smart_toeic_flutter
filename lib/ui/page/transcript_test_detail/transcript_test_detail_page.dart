import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/configs/app_configs.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/transcript/check_result.dart';
import 'package:toeic_desktop/data/services/transcript_checker_service.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/test/practice_test/widgets/audio_section.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_cubit.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_state.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/widgets/check_result_display.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/widgets/question_list.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/widgets/speech_test.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';

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
  late final TextEditingController _transcriptController;
  late final TranscriptCheckerService _transcriptChecker;
  bool _isCheck = false;
  List<CheckResult> _checkResult = [];
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _transcriptController = TextEditingController();
    _transcriptChecker = TranscriptCheckerService();
  }

  @override
  void dispose() {
    _transcriptController.dispose();
    super.dispose();
  }

  void _handleCheck(String correctTranscript) {
    final result = _transcriptChecker.checkTranscription(
      userInput: _transcriptController.text,
      correctTranscript: correctTranscript,
    );

    setState(() {
      _checkResult = result.results;
      _isCorrect = result.isAllCorrect;
      _isCheck = true;
    });
  }

  Widget _buildInputSection(String correctTranscript) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _transcriptController,
          onChanged: (value) {
            if (_isCheck) {
              setState(() {
                _isCheck = false;
              });
            }
          },
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Type what you hear...',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.focusBorder),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 48,
              width: 300,
              child: ElevatedButton(
                onPressed: () => _handleCheck(correctTranscript),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Text('Check'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 48,
              width: 300,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const Dialog(
                        child: SpeechTest(),
                      );
                    },
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.microphoneLines),
                    SizedBox(width: 8),
                    Text('Practice Pronunciation'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNavigationBar(TranscriptTestDetailState state) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: state.currentIndex > 0
                    ? () {
                        context
                            .read<TranscriptTestDetailCubit>()
                            .previousTranscriptTest();
                      }
                    : null,
                icon: const FaIcon(
                  FontAwesomeIcons.chevronLeft,
                  size: 20,
                ),
                tooltip: 'Previous Question',
              ),
              Text(
                '${state.currentIndex + 1}/${state.transcriptTests.length}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              IconButton(
                onPressed: state.currentIndex < state.transcriptTests.length - 1
                    ? () {
                        context
                            .read<TranscriptTestDetailCubit>()
                            .nextTranscriptTest();
                      }
                    : null,
                icon: const FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: 20,
                ),
                tooltip: 'Next Question',
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () => GoRouter.of(context).pop(),
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TranscriptTestDetailCubit, TranscriptTestDetailState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.failure) {
          showToast(title: state.message, type: ToastificationType.error);
        }
        setState(() {
          _isCheck = false;
          _transcriptController.text = '';
        });
      },
      builder: (context, state) {
        final bool isLoading = state.loadStatus == LoadStatus.loading ||
            state.loadStatus == LoadStatus.initial;
        final bool isSuccess = state.loadStatus == LoadStatus.success;
        final currentTest =
            isSuccess ? state.transcriptTests[state.currentIndex] : null;
        final audioUrl = isSuccess && currentTest != null
            ? '${AppConfigs.baseUrl.replaceAll('/api', '')}/uploads${currentTest.audioUrl}'
            : '';

        return Scaffold(
          appBar: AppBar(
            title: const Text('Transcript Test'),
            leading: const LeadingBackButton(),
          ),
          key: isSuccess && currentTest != null
              ? ValueKey(currentTest.id)
              : null,
          endDrawer: isSuccess
              ? Drawer(
                  backgroundColor: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      child: QuestionList(
                        transcriptTests: state.transcriptTests,
                        currentIndex: state.currentIndex,
                      ),
                    ),
                  ),
                )
              : null,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          body: isLoading
              ? const LoadingCircle()
              : isSuccess && currentTest != null
                  ? Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 64),
                                  AudioSection(audioUrl: audioUrl),
                                  const SizedBox(height: 16),
                                  _buildInputSection(currentTest.transcript!),
                                  if (_isCheck) ...[
                                    const SizedBox(height: 24),
                                    CheckResultDisplay(
                                      results: _checkResult,
                                      userInput: _transcriptController.text,
                                    ),
                                    const SizedBox(height: 16),
                                    if (_isCorrect)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const FaIcon(
                                              FontAwesomeIcons.circleCheck,
                                              color: AppColors.success),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Correct!',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  color: AppColors.success,
                                                ),
                                          ),
                                        ],
                                      )
                                  ],
                                  const SizedBox(height: 32),
                                ],
                              ),
                            ),
                          ),
                        ),
                        _buildNavigationBar(state),
                      ],
                    )
                  : const SizedBox.shrink(),
        );
      },
    );
  }
}

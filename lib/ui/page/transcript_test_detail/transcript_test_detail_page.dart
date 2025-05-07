import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/utils/constants.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/practice_test/widgets/audio_section.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_cubit.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_state.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/widgets/speech_test.dart';

class TranscriptTestDetailPage extends StatelessWidget {
  const TranscriptTestDetailPage({super.key, required this.transcriptTestId});

  final String transcriptTestId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<TranscriptTestDetailCubit>()
        ..getTranscriptTestDetail(transcriptTestId),
      child: Page(),
    );
  }
}

class Page extends StatefulWidget {
  const Page({
    super.key,
  });

  @override
  State<Page> createState() => _PageState();
}

class CheckResult {
  final String word;
  final String status; // "correct", "incorrect", "next"

  CheckResult({required this.word, required this.status});
}

class _PageState extends State<Page> {
  late TextEditingController _transcriptController;
  bool isCheck = false;
  List<CheckResult> _checkResult = [];
  bool _isCorrect = false;
  bool _showQuestionList = false;

  @override
  void initState() {
    super.initState();
    _transcriptController = TextEditingController();
  }

  @override
  void dispose() {
    _transcriptController.dispose();
    super.dispose();
  }

  List<String> _splitAndLowercase(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[.,!?]'), '')
        .split(RegExp(r'\s+'))
      ..removeWhere((word) => word.isEmpty);
  }

  List<Map<String, dynamic>> _splitAndIndexWords(String text) {
    List<Map<String, dynamic>> result = [];
    int currentIndex = 0;

    final cleanText = text.replaceAll(RegExp(r'[.,!?]'), '');
    final words = cleanText.split(RegExp(r'\s+'))
      ..removeWhere((word) => word.isEmpty);

    for (String word in words) {
      result.add({
        'word': word.toLowerCase(),
        'index': currentIndex,
      });
      currentIndex += word.length + 1; // +1 for the space
    }
    return result;
  }

  void _checkTranscription(String correctTranscript) {
    final userWords = _splitAndLowercase(_transcriptController.text);
    final correctWords = _splitAndIndexWords(correctTranscript);

    bool allCorrect = false;
    int index = 0;
    List<CheckResult> result = [];
    int numWord = -1;
    bool isFalsePart = false;

    for (int i = 0; i < userWords.length; i++) {
      if (i > correctWords.length - 1) break;

      if (userWords[i] == correctWords[i]['word']) {
        numWord = i;
        int preIndex = index;

        if (i == correctWords.length - 1) {
          result.add(CheckResult(
            word: correctTranscript.substring(index),
            status: 'correct',
          ));
          allCorrect = true;
          break;
        }

        index = correctWords[i + 1]['index'];
        result.add(CheckResult(
          word: correctTranscript.substring(preIndex, index),
          status: 'correct',
        ));
      } else {
        numWord = i;
        isFalsePart = true;
        int preIndex = index;
        allCorrect = false;

        if (i == correctWords.length - 1) {
          result.add(CheckResult(
            word: correctTranscript.substring(index),
            status: 'incorrect',
          ));
          break;
        }

        index = correctWords[i + 1]['index'];
        result.add(CheckResult(
          word: correctTranscript.substring(preIndex, index),
          status: 'incorrect',
        ));
        break;
      }
    }

    if (!isFalsePart && !allCorrect) {
      if (numWord < correctWords.length) {
        if (numWord + 2 < correctWords.length) {
          result.add(CheckResult(
            word: correctTranscript.substring(
              index,
              correctWords[numWord + 2]['index'],
            ),
            status: 'next',
          ));
        } else {
          result.add(CheckResult(
            word: correctTranscript.substring(index),
            status: 'next',
          ));
        }
      }
    }

    setState(() {
      _checkResult = result;
      _isCorrect = allCorrect;
      isCheck = true;
    });
  }

  Widget _buildCheckResultDisplay(String transcript) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text('Kết quả: ', style: Theme.of(context).textTheme.bodyLarge),
          Expanded(
            child: Wrap(
              children: _checkResult.map((result) {
                final color = switch (result.status) {
                  'correct' => Colors.green,
                  'incorrect' => Colors.red,
                  'next' => Colors.grey,
                  _ => Colors.black,
                };

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    result.word,
                    style: TextStyle(color: color),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionList(TranscriptTestDetailState state) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Danh sách câu hỏi',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _showQuestionList = false;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: state.transcriptTests.length,
              itemBuilder: (context, index) {
                final isCurrentQuestion = index == state.currentIndex;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isCurrentQuestion
                        ? AppColors.primary
                        : Theme.of(context).dividerColor,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isCurrentQuestion ? Colors.white : null,
                      ),
                    ),
                  ),
                  title: Text(
                    'Câu hỏi ${index + 1}',
                    style: TextStyle(
                      fontWeight: isCurrentQuestion ? FontWeight.bold : null,
                    ),
                  ),
                  onTap: () {
                    context
                        .read<TranscriptTestDetailCubit>()
                        .goToTranscriptTest(index);
                    setState(() {
                      _showQuestionList = false;
                    });
                  },
                );
              },
            ),
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
          isCheck = false;
          _transcriptController.text = '';
        });
      },
      builder: (context, state) {
        if (state.loadStatus != LoadStatus.success) {
          if (state.loadStatus == LoadStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const SizedBox.shrink();
        }
        return Scaffold(
          key: ValueKey(state.transcriptTests[state.currentIndex].id),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width > 600
                        ? MediaQuery.of(context).size.width * 0.1
                        : 16,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Thực hành nghe chép',
                              style: Theme.of(context).textTheme.titleLarge,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _showQuestionList = true;
                                  });
                                },
                                icon: const Icon(Icons.list),
                              ),
                              IconButton(
                                onPressed: state.currentIndex > 0
                                    ? () {
                                        context
                                            .read<TranscriptTestDetailCubit>()
                                            .previousTranscriptTest();
                                      }
                                    : null,
                                icon: const Icon(Icons.arrow_back),
                              ),
                              Text(
                                '${state.currentIndex + 1}/${state.transcriptTests.length}',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              IconButton(
                                onPressed: state.currentIndex <
                                        state.transcriptTests.length - 1
                                    ? () {
                                        context
                                            .read<TranscriptTestDetailCubit>()
                                            .nextTranscriptTest();
                                      }
                                    : null,
                                icon: const Icon(Icons.arrow_forward),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Builder(builder: (context) {
                        final audioUrl =
                            '${Constants.hostUrl}/uploads${state.transcriptTests[state.currentIndex].audioUrl}';
                        return AudioSection(
                          audioUrl: audioUrl,
                        );
                      }),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _transcriptController,
                        onChanged: (value) {
                          if (isCheck) {
                            setState(() {
                              isCheck = false;
                            });
                          }
                        },
                        autofocus: true,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Nhập nội dung bạn nghe được...',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: AppColors.inputBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: AppColors.focusBorder),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children: [
                          SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () {
                                _checkTranscription(state
                                    .transcriptTests[state.currentIndex]
                                    .transcript!);
                              },
                              child: const Text('Kiểm tra'),
                            ),
                          ),
                          SizedBox(
                            height: 45,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: SpeechTest(),
                                    );
                                  },
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.volume_up),
                                  SizedBox(width: 8),
                                  Text('Thực hành phát âm'),
                                ],
                              ),
                            ),
                          ),
                          if (state.currentIndex <
                              state.transcriptTests.length - 1)
                            SizedBox(
                              height: 45,
                              child: ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<TranscriptTestDetailCubit>()
                                      .nextTranscriptTest();
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.skip_next),
                                    SizedBox(width: 8),
                                    Text('Bỏ qua'),
                                  ],
                                ),
                              ),
                            )
                          else
                            SizedBox(
                              height: 45,
                              child: ElevatedButton(
                                onPressed: () {
                                  GoRouter.of(context).pop();
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.skip_next),
                                    SizedBox(width: 8),
                                    Text('Kết thúc'),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (isCheck) ...[
                        const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.all(16),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Nội dung bạn nhập: ${_transcriptController.text}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildCheckResultDisplay(state
                            .transcriptTests[state.currentIndex].transcript!),
                        const SizedBox(height: 16),
                        if (_isCorrect)
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(FontAwesomeIcons.circleCheck,
                                      color: AppColors.success),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Bạn đã đúng!',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: AppColors.success,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          )
                      ],
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              if (_showQuestionList)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.5),
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        child: _buildQuestionList(state),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

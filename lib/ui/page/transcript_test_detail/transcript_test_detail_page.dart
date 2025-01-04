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
          body: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Thực hành nghe chép',
                        style: Theme.of(context).textTheme.titleLarge),
                    Row(
                      children: [
                        IconButton(
                            onPressed: state.currentIndex > 0
                                ? () {
                                    context
                                        .read<TranscriptTestDetailCubit>()
                                        .previousTranscriptTest();
                                  }
                                : null,
                            icon: const Icon(Icons.arrow_back)),
                        const SizedBox(width: 8),
                        Text(
                            '${state.currentIndex + 1}/${state.transcriptTests.length}',
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(width: 8),
                        IconButton(
                            onPressed: state.currentIndex <
                                    state.transcriptTests.length - 1
                                ? () {
                                    context
                                        .read<TranscriptTestDetailCubit>()
                                        .nextTranscriptTest();
                                  }
                                : null,
                            icon: const Icon(Icons.arrow_forward)),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 16),
                // audio section
                Builder(builder: (context) {
                  final audioUrl =
                      '${Constants.hostUrl}/uploads${state.transcriptTests[state.currentIndex].audioUrl}';
                  return AudioSection(
                    audioUrl: audioUrl,
                  );
                }),
                const SizedBox(height: 16),
                // transcript section
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
                  decoration: InputDecoration(
                    hintText: 'Nhập nội dung bạn nghe được...',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.inputBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.focusBorder),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // button section
                Row(
                  children: [
                    SizedBox(
                        height: 45,
                        child: ElevatedButton(
                            onPressed: () {
                              _checkTranscription(state
                                  .transcriptTests[state.currentIndex]
                                  .transcript!);
                            },
                            child: Text('Kiểm tra'))),
                    const SizedBox(width: 32),
                    SizedBox(
                        height: 45,
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              // show dialog to speech test
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
                              children: [
                                Icon(Icons.volume_up),
                                const SizedBox(width: 8),
                                Text('Thực hành phát âm'),
                              ],
                            ))),
                    Spacer(),
                    if (state.currentIndex < state.transcriptTests.length - 1)
                      SizedBox(
                          height: 45,
                          child: ElevatedButton(
                              onPressed: () {
                                context
                                    .read<TranscriptTestDetailCubit>()
                                    .nextTranscriptTest();
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.skip_next),
                                  const SizedBox(width: 8),
                                  Text('Bỏ qua'),
                                ],
                              )))
                    else
                      SizedBox(
                          height: 45,
                          child: ElevatedButton(
                              onPressed: () {
                                GoRouter.of(context).pop();
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.skip_next),
                                  const SizedBox(width: 8),
                                  Text('Kết thúc  '),
                                ],
                              )))
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
                  _buildCheckResultDisplay(
                      state.transcriptTests[state.currentIndex].transcript!),
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
                            Text('Bạn đã đúng!',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: AppColors.success,
                                    )),
                          ],
                        ),
                      ],
                    )
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}

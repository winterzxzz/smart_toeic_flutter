import 'package:toeic_desktop/data/models/transcript/check_result.dart';

class TranscriptCheckerService {
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

  ({List<CheckResult> results, bool isAllCorrect}) checkTranscription({
    required String userInput,
    required String correctTranscript,
  }) {
    final userWords = _splitAndLowercase(userInput);
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
            status: CheckResultStatus.correct,
          ));
          allCorrect = true;
          break;
        }

        index = correctWords[i + 1]['index'];
        result.add(CheckResult(
          word: correctTranscript.substring(preIndex, index),
          status: CheckResultStatus.correct,
        ));
      } else {
        numWord = i;
        isFalsePart = true;
        int preIndex = index;
        allCorrect = false;

        if (i == correctWords.length - 1) {
          result.add(CheckResult(
            word: correctTranscript.substring(index),
            status: CheckResultStatus.incorrect,
          ));
          break;
        }

        index = correctWords[i + 1]['index'];
        result.add(CheckResult(
          word: correctTranscript.substring(preIndex, index),
          status: CheckResultStatus.incorrect,
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
            status: CheckResultStatus.next,
          ));
        } else {
          result.add(CheckResult(
            word: correctTranscript.substring(index),
            status: CheckResultStatus.next,
          ));
        }
      }
    }

    return (results: result, isAllCorrect: allCorrect);
  }
}

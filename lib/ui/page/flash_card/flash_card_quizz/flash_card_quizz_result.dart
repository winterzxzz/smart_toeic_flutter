import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/request/flash_card_quizz_score_request.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_quizz/widgets/matching_word.dart';

class FlashCardQuizResultPage extends StatelessWidget {
  final List<FlashCardQuizzScoreRequest> flashCardQuizzScoreRequest;

  const FlashCardQuizResultPage({
    super.key,
    required this.flashCardQuizzScoreRequest,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: const LeadingBackButton(),
        title: Text(
          S.current.quiz_result,
          style: theme.textTheme.titleMedium,
        ),
      ),
      body: ListView.builder(
        itemCount: flashCardQuizzScoreRequest.length,
        itemBuilder: (context, index) {
          final item = flashCardQuizzScoreRequest[index];
          return Card(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getColorByAccuracyRate(item.accuracy ?? 0),
                  width: 1,
                ),
              ),
              child: ListTile(
                title: Text(
                  item.word!.capitalizeFirst,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${S.current.difficulty_rate}: ${item.difficultRate}'),
                    Text('${S.current.time}: ${item.timeMinutes ?? 0} minutes'),
                    Text(
                        '${S.current.number_of_questions}: ${item.numOfQuiz ?? 0}'),
                    Text(
                        '${S.current.number_of_correct_answers}: ${item.numOfCorrect ?? 0}'),
                    Text(
                        '${S.current.number_of_wrong_answers}: ${(item.numOfQuiz ?? 0) - (item.numOfCorrect ?? 0)}'),
                    Text(
                        '${S.current.quiz_result}: ${(item.accuracy ?? 0) * 100}%'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getColorByAccuracyRate(double accuracy) {
    if (accuracy >= 0.8) {
      return Colors.green;
    } else if (accuracy >= 0.5) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}

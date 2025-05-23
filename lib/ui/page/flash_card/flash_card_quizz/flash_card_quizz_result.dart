import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/request/flash_card_quizz_score_request.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';

class FlashCardQuizResultPage extends StatelessWidget {
  final List<FlashCardQuizzScoreRequest> flashCardQuizzScoreRequest;

  const FlashCardQuizResultPage({
    super.key,
    required this.flashCardQuizzScoreRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const LeadingBackButton(),
        title: const Text('Quiz Result'),
      ),
      body: ListView.builder(
        itemCount: flashCardQuizzScoreRequest.length,
        itemBuilder: (context, index) {
          final item = flashCardQuizzScoreRequest[index];
          return Card(
            child: ListTile(
              title: Text(
                item.word!,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Difficulty rate: ${item.difficultRate}'),
                  Text('Time: ${item.timeMinutes ?? 0} minutes'),
                  Text('Number of questions: ${item.numOfQuiz ?? 0}'),
                  Text('Number of correct answers: ${item.numOfCorrect ?? 0}'),
                  Text(
                      'Number of wrong answers: ${(item.numOfQuiz ?? 0) - (item.numOfCorrect ?? 0)}'),
                  Text('Accuracy rate: ${(item.accuracy ?? 0) * 100}%'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

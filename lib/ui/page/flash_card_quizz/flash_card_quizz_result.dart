import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/request/flash_card_quizz_score_request.dart';

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
        automaticallyImplyLeading: false,
        title: Text('Kết quả bài kiểm tra'),
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
                  Text('Tỉ lệ khó: ${item.difficultRate}'),
                  Text('Thời gian: ${item.timeMinutes ?? 0} phút'),
                  Text('Số câu hỏi: ${item.numOfQuiz ?? 0}'),
                  Text('Số câu đúng: ${item.numOfCorrect ?? 0}'),
                  Text(
                      'Số câu sai: ${(item.numOfQuiz ?? 0) - (item.numOfCorrect ?? 0)}'),
                  Text('Tỉ lệ đúng: ${(item.accuracy ?? 0) * 100}%'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

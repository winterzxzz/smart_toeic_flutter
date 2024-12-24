import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_learning.dart';
import 'package:toeic_desktop/data/models/request/flash_card_quizz_score_request.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/flash_card_quizz_cubit.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/flash_card_quizz_state.dart';

Map<double, String> diffLevels = {
  0: 'Khó nhớ',
  0.3: 'Tương đối khó',
  0.6: 'Dễ nhớ',
  1: 'Rất dễ nhớ',
};

class ConfidenceLevel extends StatelessWidget {
  const ConfidenceLevel({super.key, required this.fcLearning});

  final FlashCardLearning fcLearning;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      key: key,
      children: [
        Text(
          fcLearning.flashcardId!.word,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.purple[700],
          ),
        ),
        SizedBox(height: 32),
        Text(
          'Bạn đã thuộc từ này ở mức nào?',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 32),
        ...diffLevels.entries.map((level) {
          return Column(
            children: [
              const SizedBox(height: 32),
              InkWell(
                onTap: () {
                  context.read<FlashCardQuizzCubit>().updateConfidenceLevel(
                      level.key, fcLearning.flashcardId!.id);
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 70,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: BlocSelector<FlashCardQuizzCubit, FlashCardQuizzState,
                      List<FlashCardQuizzScoreRequest>>(
                    selector: (state) {
                      return state.flashCardQuizzScoreRequest;
                    },
                    builder: (context, flashCardQuizzScoreRequest) {
                      final scoreRequest =
                          getScoreRequest(flashCardQuizzScoreRequest);
                      return Row(
                        children: [
                          Radio<double>(
                            value: level.key,
                            groupValue: scoreRequest.difficultRate,
                            onChanged: (value) {
                              context
                                  .read<FlashCardQuizzCubit>()
                                  .updateConfidenceLevel(
                                      value!, fcLearning.flashcardId!.id);
                            },
                          ),
                          SizedBox(width: 8),
                          Text(level.value),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  FlashCardQuizzScoreRequest getScoreRequest(
      List<FlashCardQuizzScoreRequest> flashCardQuizzScoreRequest) {
    FlashCardQuizzScoreRequest? scoreRequest;
    for (var score in flashCardQuizzScoreRequest) {
      if (score.id == fcLearning.flashcardId!.id) {
        scoreRequest = score;
      }
    }
    return scoreRequest!;
  }
}

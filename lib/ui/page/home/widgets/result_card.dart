import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/data/models/entities/test/result_test.dart';
import 'package:toeic_desktop/ui/page/home/widgets/score_tile.dart';

class ExamResultCard extends StatelessWidget {
  final ResultTest result;

  const ExamResultCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Container(
        width: double.infinity,
        height: 270,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              result.testId.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormat('dd/MM/yyyy').format(result.createdAt),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${result.secondTime}s',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ScoreTile(
                  icon: Icons.check_circle,
                  label: 'Correct',
                  score: result.numberOfCorrectAnswers,
                  color: Colors.green,
                ),
                ScoreTile(
                  icon: Icons.edit,
                  label: 'Attempted',
                  score: getCountAttempt(result),
                  color: Colors.blue,
                ),
                ScoreTile(
                  icon: Icons.help,
                  label: 'Total',
                  score: result.numberOfQuestions,
                  color: Colors.orange,
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'View Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int getCountAttempt(ResultTest result) {
    final currentUserId = injector<UserCubit>().state.user?.id;
    return result.testId.attempts
        .firstWhere((e) => e.userId == currentUserId,
            orElse: () => Attempt(userId: '', times: 0))
        .times;
  }
}

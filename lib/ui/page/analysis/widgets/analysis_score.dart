import 'package:flutter/material.dart';

class AnalysisScore extends StatelessWidget {
  const AnalysisScore({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Phân tích Điểm số',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildScoreRow('Overall Score', 0, 990),
            const SizedBox(height: 10),
            _buildScoreRow('Listening', 0, 495),
            const SizedBox(height: 10),
            _buildScoreRow('Reading', 95, 495),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreRow(String title, int score, int maxScore) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text('$score/$maxScore'),
          ],
        ),
        const SizedBox(height: 5),
        LinearProgressIndicator(
          value: score / maxScore,
          backgroundColor: Colors.grey[300],
          minHeight: 20,
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
        ),
      ],
    );
  }
}

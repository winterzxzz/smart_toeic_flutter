import 'package:flutter/material.dart';

class AnalysisScore extends StatelessWidget {
  const AnalysisScore({
    super.key,
    required this.overallScore,
    required this.listenScore,
    required this.readScore,
  });

  final int overallScore;
  final int listenScore;
  final int readScore;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Phân tích Điểm số',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildScoreRow('Overall Score', overallScore, 990),
            const SizedBox(height: 10),
            _buildScoreRow('Listening', listenScore, 495),
            const SizedBox(height: 10),
            _buildScoreRow('Reading', readScore, 495),
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

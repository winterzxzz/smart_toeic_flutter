import 'package:flutter/material.dart';

class AnalysisScore extends StatefulWidget {
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
  State<AnalysisScore> createState() => _AnalysisScoreState();
}

class _AnalysisScoreState extends State<AnalysisScore> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Phân tích Điểm số',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildScoreRow('Overall Score', widget.overallScore, 990),
            const SizedBox(height: 8),
            _buildScoreRow('Listening', widget.listenScore, 495),
            const SizedBox(height: 8),
            _buildScoreRow('Reading', widget.readScore, 495),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreRow(String title, int score, int maxScore) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(title, style: theme.textTheme.bodyMedium)),
            Text.rich(
              TextSpan(
                text: '$score',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: '/$maxScore',
                    style: theme.textTheme.bodySmall,
                  )
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 5),
        LinearProgressIndicator(
          value: score / maxScore,
          backgroundColor: Colors.grey[300],
          minHeight: 20,
          color: theme.primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
        ),
      ],
    );
  }
}

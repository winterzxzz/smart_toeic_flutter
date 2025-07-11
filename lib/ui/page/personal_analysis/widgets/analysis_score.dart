import 'package:flutter/material.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';

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
    final textTheme = context.textTheme;
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              S.current.analysis_score,
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildScoreRow(S.current.overall_score, widget.overallScore, 990),
            const SizedBox(height: 8),
            _buildScoreRow(S.current.listening, widget.listenScore, 495),
            const SizedBox(height: 8),
            _buildScoreRow(S.current.reading, widget.readScore, 495),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreRow(String title, int score, int maxScore) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(title, style: textTheme.bodyMedium)),
            Text.rich(
              TextSpan(
                text: '$score',
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: '/$maxScore',
                    style: textTheme.bodySmall,
                  )
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 5),
        LinearProgressIndicator(
          value: score / maxScore,
          backgroundColor: colorScheme.primary.withValues(alpha: 0.3),
          minHeight: 20,
          color: colorScheme.primary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
        ),
      ],
    );
  }
}

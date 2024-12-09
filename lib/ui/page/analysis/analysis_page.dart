import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/page/analysis/widgets/analysis_percentage.dart';
import 'package:toeic_desktop/ui/page/analysis/widgets/analysis_score.dart';
import 'package:toeic_desktop/ui/page/analysis/widgets/chart1.dart';

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('TOEIC Performance Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: const AnalysisScore()),
                const SizedBox(width: 16),
                Expanded(child: const AnalysisPercentage()),
              ],
            ),
            const SizedBox(height: 16),
            const BarChartSample2(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';

class AnalysisPercentage extends StatefulWidget {
  const AnalysisPercentage({
    super.key,
    required this.percentage,
  });

  final Map<String, String> percentage;

  @override
  State<AnalysisPercentage> createState() => _AnalysisPercentageState();
}

class _AnalysisPercentageState extends State<AnalysisPercentage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 300, // Add fixed height for the chart
        child: Column(
          children: [
            Text(
              S.current.accuracy_by_part,
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: 100,
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const titles = [
                            'Part 1',
                            'Part 2',
                            'Part 3',
                            'Part 4',
                            'Part 5',
                            'Part 6',
                            'Part 7',
                          ];
                          return Text(
                            titles[value.toInt() - 1],
                            style: textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600, fontSize: 8),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 20,
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: true),
                  barGroups: widget.percentage.entries
                      .map((e) => _createBarData(
                          int.parse(e.key), double.parse(e.value)))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _createBarData(int x, double y) {
    final colorScheme = context.colorScheme;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          gradient: LinearGradient(
            colors: [
              colorScheme.primary,
              colorScheme.primary.withValues(alpha: .8)
            ],
          ),
          width: 20,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
      ],
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalysisPercentage extends StatelessWidget {
  const AnalysisPercentage({
    super.key,
    required this.percentage,
  });

  final Map<String, String> percentage;

  @override
  Widget build(BuildContext context) {
    log('percentage: ${percentage.entries}');

    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 300, // Add fixed height for the chart
        child: Column(
          children: [
            const Text(
              'Độ chính xác theo Phần(%)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
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
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
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
                  barGroups: percentage.entries
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
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          gradient: LinearGradient(
            colors: [Colors.red.shade300, Colors.orange.shade100],
          ),
          width: 25,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
      ],
    );
  }
}

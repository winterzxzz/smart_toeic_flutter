import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toeic_desktop/data/models/entities/profile/profile_analysis.dart';

class StackedBarChartPage extends StatelessWidget {
  const StackedBarChartPage({super.key, required this.categoryAccuracys});

  final Map<String, CategoryAccuracy> categoryAccuracys;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 1000,
        padding: const EdgeInsets.all(16.0),
        child: SfCartesianChart(
          enableAxisAnimation: true,
          enableMultiSelection: true,
          title: ChartTitle(
            text: 'Category Accuracy Chart',
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          legend: Legend(isVisible: true, position: LegendPosition.bottom),
          primaryXAxis: CategoryAxis(
            title: AxisTitle(text: 'Question Types'),
          ),
          primaryYAxis: NumericAxis(
            title: AxisTitle(text: 'Count'),
            interval: 25,
          ),
          series: _buildSeries(),
        ),
      ),
    );
  }

  List<StackedBarSeries<ChartData, String>> _buildSeries() {
    // Convert categoryAccuracys map to ChartData format
    final List<ChartData> data = categoryAccuracys.entries.map((entry) {
      List<double> values = List.filled(7, 0.0); // Create array of 7 zeros
      // Set the accuracy value for the corresponding part
      values[entry.value.categoryAccuracyPart - 1] =
          double.parse(entry.value.accuracy);
      return ChartData(entry.value.title, values);
    }).toList();

    final List<Color> colors = [
      Colors.orange,
      Colors.teal,
      Colors.indigo,
      Colors.yellow,
      Colors.orangeAccent,
      Colors.green,
      Colors.blue,
    ];

    return List<StackedBarSeries<ChartData, String>>.generate(
      7, // Number of parts
      (index) => StackedBarSeries<ChartData, String>(
        dataSource: data,
        xValueMapper: (ChartData data, _) => data.label,
        yValueMapper: (ChartData data, _) => data.values[index],
        color: colors[index],
        sortFieldValueMapper: (ChartData data, _) => data.label,
        pointColorMapper: (ChartData data, _) => colors[index],
        name: 'Part ${index + 1}',
      ),
    );
  }
}

class ChartData {
  final String label;
  final List<double> values;

  ChartData(this.label, this.values);
}

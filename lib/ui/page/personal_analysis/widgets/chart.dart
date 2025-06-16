import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toeic_desktop/data/models/entities/profile/profile_analysis.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/page/test/tests/choose_mode_test/widgets/custom_drop_down.dart';

class StackedBarChartPage extends StatefulWidget {
  const StackedBarChartPage({super.key, required this.categoryAccuracys});

  final Map<String, CategoryAccuracy> categoryAccuracys;

  @override
  State<StackedBarChartPage> createState() => _StackedBarChartPageState();
}

class _StackedBarChartPageState extends State<StackedBarChartPage> {
  int? selectedPart;
  static const List<Color> colors = [
    Colors.orange,
    Colors.teal,
    Colors.indigo,
    Colors.yellow,
    Colors.orangeAccent,
    Colors.green,
    Colors.blue,
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Container(
        height: 1000,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown filter
            CustomDropdownExample<String>(
              data: [
                S.current.all_parts,
                ...List.generate(
                  7,
                  (index) => 'Part ${index + 1}',
                ),
              ],
              dataString: [
                S.current.all_parts,
                ...List.generate(
                  7,
                  (index) => 'Part ${index + 1}',
                ),
              ],
              onChanged: (value) {
                if (value == S.current.all_parts) {
                  setState(() {
                    selectedPart = null;
                  });
                } else {
                  setState(() {
                    selectedPart = int.parse(value.split(' ')[1]);
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            // Chart
            Expanded(
              child: SfCartesianChart(
                enableSideBySideSeriesPlacement: true,
                enableAxisAnimation: true,
                enableMultiSelection: true,
                title: ChartTitle(
                  text: S.current.category_accuracy_chart,
                  textStyle: theme.textTheme.titleLarge,
                ),
                legend: const Legend(
                    isVisible: true, position: LegendPosition.bottom),
                primaryXAxis: CategoryAxis(
                  title: AxisTitle(
                    text: S.current.question_types,
                    textStyle: theme.textTheme.bodyMedium,
                  ),
                ),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(
                    text: S.current.count,
                    textStyle: theme.textTheme.bodyMedium,
                  ),
                  interval: 25,
                ),
                series: _buildSeries(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<StackedBarSeries<ChartData, String>> _buildSeries() {
    // Group categories by part
    Map<int, List<MapEntry<String, CategoryAccuracy>>> categoriesByPart = {};
    for (var entry in widget.categoryAccuracys.entries) {
      int part = entry.value.categoryAccuracyPart ?? 0;
      categoriesByPart.putIfAbsent(part, () => []).add(entry);
    }

    if (selectedPart != null) {
      // Show only selected part
      List<ChartData> data = widget.categoryAccuracys.entries
          .where((entry) => entry.value.categoryAccuracyPart == selectedPart)
          .map((entry) {
        return ChartData(
          entry.value.title ?? '',
          [double.parse(entry.value.accuracy ?? '0')],
        );
      }).toList();

      return [
        StackedBarSeries<ChartData, String>(
          dataSource: data,
          xValueMapper: (ChartData data, _) => data.label,
          yValueMapper: (ChartData data, _) => data.values[0],
          color: Colors.orange,
          name: 'Part $selectedPart',
          enableTooltip: true,
        )
      ];
    } else {
      // Show all parts
      List<ChartData> chartData = [];

      // Create a map of category titles to their accuracies for each part
      Map<String, List<double>> categoryValues = {};

      // Initialize the lists with zeros for all parts (1-7)
      for (var entry in widget.categoryAccuracys.entries) {
        categoryValues[entry.value.title ?? ''] = List.filled(7, 0.0);
      }

      // Fill in the actual values
      for (var entry in widget.categoryAccuracys.entries) {
        int partIndex = entry.value.categoryAccuracyPart! - 1;
        categoryValues[entry.value.title ?? '']![partIndex] =
            double.parse(entry.value.accuracy ?? '0');
      }

      // Convert to ChartData objects
      chartData = categoryValues.entries
          .map((entry) => ChartData(entry.key, entry.value))
          .toList();

      return List<StackedBarSeries<ChartData, String>>.generate(
        7,
        (index) => StackedBarSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.label,
          yValueMapper: (ChartData data, _) => data.values[index],
          color: colors[index],
          name: 'Part ${index + 1}',
        ),
      );
    }
  }
}

class ChartData {
  final String label;
  final List<double> values;

  ChartData(this.label, this.values);
}

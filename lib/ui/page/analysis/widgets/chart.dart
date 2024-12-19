import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toeic_desktop/data/models/entities/profile/profile_analysis.dart';
import 'package:toeic_desktop/ui/page/mode_test/widgets/custom_drop_down.dart';

class StackedBarChartPage extends StatefulWidget {
  const StackedBarChartPage({super.key, required this.categoryAccuracys});

  final Map<String, CategoryAccuracy> categoryAccuracys;

  @override
  State<StackedBarChartPage> createState() => _StackedBarChartPageState();
}

class _StackedBarChartPageState extends State<StackedBarChartPage> {
  int? selectedPart;
  late TooltipBehavior _tooltipBehavior;
  final List<Color> colors = [
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
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      canShowMarker: true,
      header: '',
      textStyle: const TextStyle(color: Colors.white),
      animationDuration: 150,
      builder: (dynamic data, dynamic point, dynamic series, dynamic pointIndex,
          dynamic seriesIndex) {
        return Container(
          height: 70,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 10,
                width: 10,
                color: colors[seriesIndex],
              ),
              const SizedBox(width: 10),
              Wrap(
                direction: Axis.vertical,
                spacing: 10,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Category: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colors[seriesIndex],
                          ),
                        ),
                        TextSpan(
                          text: ' ${point.x}',
                          style: TextStyle(
                            color: colors[seriesIndex],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Value: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colors[seriesIndex],
                          ),
                        ),
                        TextSpan(
                          text: '${point.y}%',
                          style: TextStyle(
                            color: colors[seriesIndex],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 1000,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown filter
            CustomDropdownExample(
              data: [
                'All parts',
                ...List.generate(
                  7,
                  (index) => 'Part ${index + 1}',
                ),
              ],
              onChanged: (value) {
                if (value == 'All parts') {
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
                  text: 'Category Accuracy Chart',
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                legend:
                    Legend(isVisible: true, position: LegendPosition.bottom),
                primaryXAxis: CategoryAxis(
                  title: AxisTitle(text: 'Question Types'),
                ),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(text: 'Count'),
                  interval: 25,
                ),
                series: _buildSeries(),
                tooltipBehavior: _tooltipBehavior,
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
          enableTooltip: true,
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

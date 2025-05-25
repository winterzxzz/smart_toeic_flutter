import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toeic_desktop/data/models/ui_models/result_model.dart';
import 'package:toeic_desktop/ui/page/test/result_test/widgets/result_info_item.dart';

class ResultHeaderCard extends StatelessWidget {
  const ResultHeaderCard({super.key, required this.resultModel});

  final ResultModel resultModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResultInfoItem(
              icon: FontAwesomeIcons.circleCheck,
              title: 'Test Result',
              value:
                  '${resultModel.correctQuestion}/${resultModel.totalQuestion}',
            ),
            const SizedBox(height: 12),
            ResultInfoItem(
              icon: FontAwesomeIcons.percent,
              title: 'Accuracy',
              value:
                  '${((resultModel.correctQuestion / (resultModel.totalQuestion == 0 ? 1 : resultModel.totalQuestion)) * 100).toStringAsFixed(2)}%',
            ),
            const SizedBox(height: 12),
            ResultInfoItem(
              icon: FontAwesomeIcons.clock,
              title: 'Time to finish',
              value:
                  '${resultModel.duration.inMinutes}:${resultModel.duration.inSeconds % 60 < 10 ? '0' : ''}${resultModel.duration.inSeconds % 60}',
            ),
          ],
        ),
      ),
    );
  }
}

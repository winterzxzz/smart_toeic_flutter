import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/ui_models/result_model.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

class ResultTestPage extends StatelessWidget {
  const ResultTestPage({super.key, required this.resultModel});

  final ResultModel resultModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Test Result: ${resultModel.testName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Top stats row
            Container(
              width: 300,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.textWhite,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResultInfoItem(
                    icon: Icons.check,
                    title: 'Test Result',
                    value:
                        '${resultModel.correctQuestion}/${resultModel.totalQuestion}',
                  ),
                  SizedBox(height: 16),
                  ResultInfoItem(
                    icon: Icons.check,
                    title: 'Accuracy(#correct/#total)',
                    value:
                        '${((resultModel.correctQuestion / resultModel.totalQuestion) * 100).toStringAsFixed(2)}%',
                  ),
                  SizedBox(height: 16),
                  ResultInfoItem(
                    icon: Icons.timer,
                    title: 'Time to finish',
                    value:
                        '${resultModel.duration.inMinutes}:${resultModel.duration.inSeconds % 60 < 10 ? '0' : ''}${resultModel.duration.inSeconds % 60}',
                  ),
                ],
              ),
            ),

            SizedBox(width: 20),

            Expanded(
              child: Column(
                children: [
                  // Score indicators row

                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            GoRouter.of(context)
                                .pushReplacementNamed(AppRouter.practiceTest);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.visibility),
                              SizedBox(width: 8),
                              Text('View Answer'),
                            ],
                          )),
                      SizedBox(width: 16),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.textWhite,
                            side: BorderSide(
                              color: AppColors.textBlack,
                            ),
                          ),
                          onPressed: () {
                            GoRouter.of(context).pop();
                          },
                          child: Row(
                            children: [
                              Icon(Icons.arrow_back,
                                  color: AppColors.textBlack, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Back to test page',
                                style: TextStyle(color: AppColors.textBlack),
                              ),
                            ],
                          )),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          child: _buildScoreBox('Correct',
                              '${resultModel.correctQuestion}', Colors.green)),
                      Expanded(
                          child: _buildScoreBox('Incorrect', '0', Colors.red)),
                      Expanded(
                          child: _buildScoreBox('Skip',
                              '${resultModel.notAnswerQuestion}', Colors.grey)),
                      Expanded(
                          child: _buildScoreBox('Score',
                              '${resultModel.overallScore}', Colors.blue)),
                    ],
                  ),

                  SizedBox(height: 50),

                  // Bottom section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          child: _buildProgressSection(
                              'Listening',
                              '${resultModel.listeningScore}/495',
                              '${resultModel.correctQuestion}/100')),
                      Expanded(
                          child: _buildProgressSection(
                              'Reading',
                              '${resultModel.readingScore}/495',
                              '${resultModel.correctQuestion}/100')),
                    ],
                  ),

                  SizedBox(height: 20),
                  SizedBox(
                      width: double.infinity,
                      child: _buildProgressSection(
                          'Overall',
                          '${resultModel.overallScore}/990',
                          '${resultModel.correctQuestion}/200')),

                  SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBox(String label, String value, Color color) {
    return Card(
      child: Container(
        width: 120,
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(horizontal: 12),
        color: AppColors.textWhite,
        child: Column(
          children: [
            Icon(
              label == 'Correct'
                  ? Icons.check_circle
                  : label == 'Incorrect'
                      ? Icons.cancel
                      : label == 'Skip'
                          ? Icons.remove_circle
                          : Icons.flag,
              color: color,
            ),
            SizedBox(height: 4),
            Text(value,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection(String title, String score, String correct) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(score,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Correct: $correct',
                style: TextStyle(fontSize: 12, color: AppColors.success)),
          ],
        ),
      ),
    );
  }
}

class ResultInfoItem extends StatelessWidget {
  const ResultInfoItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 20),
          SizedBox(width: 8),
          SizedBox(
            width: 120,
            child: Text(title),
          ),
          const Spacer(),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.success)),
        ],
      ),
    );
  }
}

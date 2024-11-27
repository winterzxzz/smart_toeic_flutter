import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

class ResultTestPage extends StatelessWidget {
  const ResultTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Kết quả thi: New Economy TOEIC Test 1'),
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
                    title: 'Kết quả làm bài',
                    value: '1/200',
                  ),
                  SizedBox(height: 16),
                  ResultInfoItem(
                    icon: Icons.check,
                    title: 'Độ chính xác(#đúng/#tổng)',
                    value: '100%',
                  ),
                  SizedBox(height: 16),
                  ResultInfoItem(
                    icon: Icons.timer,
                    title: 'Thời gian hoàn thành',
                    value: '0:04:48',
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.textBlue,
                          ),
                          onPressed: () {},
                          child: Text('Xem đáp án')),
                      SizedBox(width: 16),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.textBlue.withOpacity(0.15),
                            side: BorderSide(
                              color: AppColors.textBlack,
                            ),
                          ),
                          onPressed: () {
                            GoRouter.of(context).pop();
                          },
                          child: Text(
                            'Quay về trang đề thi',
                            style: TextStyle(color: AppColors.textBlack),
                          )),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          child: _buildScoreBox(
                              'Trả lời đúng', '1', Colors.green)),
                      Expanded(
                          child:
                              _buildScoreBox('Trả lời sai', '0', Colors.red)),
                      Expanded(
                          child: _buildScoreBox('Bỏ qua', '199', Colors.grey)),
                      Expanded(
                          child: _buildScoreBox('Điểm', '15', Colors.blue)),
                    ],
                  ),

                  SizedBox(height: 50),

                  // Bottom section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          child: _buildProgressSection(
                              'Listening', '15/495', '1/100')),
                      Expanded(
                          child: _buildProgressSection(
                              'Reading', '0/495', '0/100')),
                    ],
                  ),

                  SizedBox(height: 20),
                  SizedBox(
                      width: double.infinity,
                      child:
                          _buildProgressSection('Overall', '0/990', '0/200')),

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
              label == 'Trả lời đúng'
                  ? Icons.check_circle
                  : label == 'Trả lời sai'
                      ? Icons.cancel
                      : label == 'Bỏ qua'
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
            Text('Trả lời đúng: $correct', style: TextStyle(fontSize: 12)),
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
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

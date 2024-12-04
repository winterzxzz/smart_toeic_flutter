import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/entities/test.dart';

class TestCard extends StatelessWidget {
  const TestCard({
    super.key,
    required this.test,
  });

  final Test test;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              test.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "${test.duration} | 📄 ${test.attempts.length} attempts | ${test.type}",
            ),
            SizedBox(height: 8),
            Text(
              "${test.numberOfParts} parts | ${test.numberOfQuestions} questions",
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).pushNamed(AppRouter.modeTest, extra: {
                    'test': test,
                  });
                },
                child: Text("Details"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FlashCardQuizResultPage extends StatelessWidget {
  final int correctAnswers;
  final int totalQuestions;

  const FlashCardQuizResultPage({super.key, required this.correctAnswers, required this.totalQuestions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Your Score',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              '$correctAnswers / $totalQuestions',
              style: TextStyle(fontSize: 48, color: Colors.blueAccent),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add functionality to restart the quiz or go back to home
                GoRouter.of(context).pop();
              },
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/transcript/check_result.dart';

class CheckResultDisplay extends StatelessWidget {
  const CheckResultDisplay({
    super.key,
    required this.results,
    required this.userInput,
  });

  final List<CheckResult> results;
  final String userInput;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Your input: $userInput',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Text('Result: ', style: Theme.of(context).textTheme.bodyLarge),
              Expanded(
                child: Wrap(
                  children: results.map((result) {
                    final color = switch (result.status) {
                      CheckResultStatus.correct => Colors.green,
                      CheckResultStatus.incorrect => Colors.red,
                      CheckResultStatus.next => Colors.grey,
                    };

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        result.word,
                        style: TextStyle(color: color),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

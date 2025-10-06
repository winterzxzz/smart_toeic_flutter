import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/ui/page/chat_ai/chat_ai_cubit.dart';

class SuggestionPanel extends StatelessWidget {
  const SuggestionPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final suggestions = <String>[
      'Give me 5 TOEIC Part 5 practice questions.',
      'Explain common grammar for TOEIC Part 5: verbs vs nouns.',
      'Create a 10-word TOEIC vocabulary quiz with answers.',
      'How to improve TOEIC listening Part 3 quickly?',
      'Summarize strategies for TOEIC Reading Part 7.',
    ];

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Try a quick TOEIC prompt',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: suggestions.map((q) {
                return OutlinedButton(
                  onPressed: () {
                    final cubit = context.read<ChatAiCubit>();
                    cubit.onInputChanged(q);
                    cubit.sendMessage();
                  },
                  child: Text(
                    q,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

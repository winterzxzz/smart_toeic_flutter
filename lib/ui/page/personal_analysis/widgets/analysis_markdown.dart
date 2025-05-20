import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class AnalysisMarkdown extends StatelessWidget {
  const AnalysisMarkdown({super.key, required this.text});

  final String text;

  String _decodeString(String input) {
    final decodedText = input
        .replaceAll('\\n', '\n') // Replace escaped newlines
        .replaceAll('\\"', '"'); // Replace escaped quotes
    // remove first and last
    return decodedText.substring(1, decodedText.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    final decodedText = _decodeString(text);

    return Card(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Markdown(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          data: decodedText,
          softLineBreak: true,
          listItemCrossAxisAlignment:
              MarkdownListItemCrossAxisAlignment.baseline,
          styleSheet: MarkdownStyleSheet(
            h1: const TextStyle(color: Colors.blue, fontSize: 24),
            p: const TextStyle(fontSize: 16, height: 1.5),
            blockquote: const TextStyle(
                color: Colors.grey, fontStyle: FontStyle.italic),
            listBullet: const TextStyle(color: Colors.green),
          ),
          selectable: true,
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/ui/page/chat_ai/chat_ai_cubit.dart';
import 'package:toeic_desktop/ui/page/chat_ai/chat_ai_state.dart';

class MessageList extends StatelessWidget {
  const MessageList({
    super.key,
    required this.messages,
    required this.isStreaming,
  });

  final List<ChatMessage> messages;
  final bool isStreaming;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 16,
      ),
      itemCount: messages.length + (isStreaming ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length && isStreaming) {
          return const _StreamingBubble();
        }
        final m = messages[index];
        return _MessageBubble(message: m);
      },
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isUser
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: MarkdownBody(
          data: message.content,
        ),
      ),
    );
  }
}

class _StreamingBubble extends StatelessWidget {
  const _StreamingBubble();

  @override
  Widget build(BuildContext context) {
    final decodedText = _decodeStringText(
      context.read<ChatAiCubit>().state.streamingMessage,
    );
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: MarkdownBody(data: decodedText),
      ),
    );
  }
}

String _decodeStringText(String input) {
  if (input.isEmpty) return '';
  try {
    final looksQuoted = (input.startsWith('"') && input.endsWith('"')) ||
        (input.startsWith("'") && input.endsWith("'"));
    if (looksQuoted) {
      final normalized =
          input.startsWith("'") ? input.replaceAll("'", '"') : input;
      final decoded = jsonDecode(normalized);
      if (decoded is String) return decoded;
    }
  } catch (_) {
    // ignore
  }
  return input.replaceAll('\\n', '\n').replaceAll('\\"', '"');
}

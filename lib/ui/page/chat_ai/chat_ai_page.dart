import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/ui/page/chat_ai/chat_ai_cubit.dart';
import 'package:toeic_desktop/ui/page/chat_ai/chat_ai_state.dart';

class ChatAiPage extends StatelessWidget {
  const ChatAiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<ChatAiCubit>(),
      child: const Page(),
    );
  }
}

class Page extends StatelessWidget {
  const Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatAiCubit, ChatAiState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('AI Chat'),
            actions: [
              IconButton(
                onPressed: () =>
                    context.read<ChatAiCubit>().deleteCurrentSession(),
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Delete session',
              ),
            ],
          ),
          drawer: Drawer(
            child: SafeArea(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.add_comment_outlined),
                    title: const Text('New chat'),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.read<ChatAiCubit>().createTempSession();
                    },
                  ),
                  const Divider(),
                  Expanded(
                    child: _SessionList(
                      sessions: state.sessions,
                      selected: state.selectedSession,
                      onSelect: (s) {
                        Navigator.of(context).pop();
                        context.read<ChatAiCubit>().selectSession(s);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              if (state.error != null)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: SelectableText.rich(
                    TextSpan(
                      text: state.error!.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              Expanded(
                child: state.messages.isEmpty
                    ? const _SuggestionPanel()
                    : _MessageList(
                        messages: state.messages,
                        isStreaming: state.isStreaming,
                        streamingMessage: state.streamingMessage,
                      ),
              ),
              const _InputBar(),
            ],
          ),
        );
      },
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

class _MessageList extends StatelessWidget {
  const _MessageList({
    required this.messages,
    required this.isStreaming,
    required this.streamingMessage,
  });

  final List<ChatMessage> messages;
  final bool isStreaming;
  final String streamingMessage;

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

class _SuggestionPanel extends StatelessWidget {
  const _SuggestionPanel();

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

class _SessionList extends StatelessWidget {
  const _SessionList({
    required this.sessions,
    required this.selected,
    required this.onSelect,
  });

  final List<ChatSession> sessions;
  final ChatSession? selected;
  final void Function(ChatSession) onSelect;

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByDay(sessions);
    return ListView.builder(
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final (label, items) = grouped[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            ...items.map((s) {
              final isSelected = s == selected;
              return ListTile(
                selected: isSelected,
                leading: const Icon(Icons.chat_bubble_outline),
                title: Text(
                  s.title.isEmpty ? 'Untitled' : s.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => onSelect(s),
              );
            }),
          ],
        );
      },
    );
  }

  List<(String, List<ChatSession>)> _groupByDay(List<ChatSession> list) {
    final now = DateTime.now();
    String formatLabel(DateTime d) {
      final today = DateTime(now.year, now.month, now.day);
      final date = DateTime(d.year, d.month, d.day);
      final diff = today.difference(date).inDays;
      if (diff == 0) return 'Today';
      if (diff == 1) return 'Yesterday';
      return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    }

    final Map<String, List<ChatSession>> map = {};
    for (final s in list) {
      final label = formatLabel(s.createdAt.toLocal());
      map.putIfAbsent(label, () => []).add(s);
    }

    final entries = map.entries.toList()
      ..sort((a, b) {
        DateTime parseLabel(String l) {
          if (l == 'Today') return DateTime(now.year, now.month, now.day);
          if (l == 'Yesterday')
            return DateTime(now.year, now.month, now.day).subtract(
              const Duration(days: 1),
            );
          final parts = l.split('-');
          return DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
        }

        return parseLabel(b.key).compareTo(parseLabel(a.key));
      });

    return entries
        .map<(String, List<ChatSession>)>((e) => (e.key, e.value))
        .toList();
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Row(
          children: [
            Expanded(
              child: BlocSelector<ChatAiCubit, ChatAiState, String>(
                selector: (s) => s.input,
                builder: (context, input) {
                  return TextField(
                    controller: TextEditingController(text: input)
                      ..selection = TextSelection.fromPosition(
                        TextPosition(offset: input.length),
                      ),
                    onChanged: context.read<ChatAiCubit>().onInputChanged,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) =>
                        context.read<ChatAiCubit>().sendMessage(),
                    decoration: const InputDecoration(
                      hintText: 'Type a message…',
                      border: OutlineInputBorder(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            BlocSelector<ChatAiCubit, ChatAiState, (bool, bool)>(
              selector: (s) => (s.isLoading, s.isStreaming),
              builder: (context, state) {
                final (isLoading, isStreaming) = state;
                return IconButton(
                  onPressed: isStreaming
                      ? () => context.read<ChatAiCubit>().finishStreaming()
                      : isLoading
                          ? null
                          : () => context.read<ChatAiCubit>().sendMessage(),
                  icon: isStreaming
                      ? const Icon(Icons.stop_rounded)
                      : isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send_rounded),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

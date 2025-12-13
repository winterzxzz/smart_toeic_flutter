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
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.surface,
            scrolledUnderElevation: 0,
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
                  Container(
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Chat History',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      leading: Icon(
                        Icons.add_comment_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(
                        'New chat',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        context.read<ChatAiCubit>().createTempSession();
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Divider(),
                  ),
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

class _MessageList extends StatefulWidget {
  const _MessageList({
    super.key,
    required this.messages,
    required this.isStreaming,
  });

  final List<ChatMessage> messages;
  final bool isStreaming;

  @override
  State<_MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<_MessageList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_MessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    final isNewMessage = widget.messages.length > oldWidget.messages.length;
    final isStreamingStarted = widget.isStreaming && !oldWidget.isStreaming;

    if (isNewMessage || isStreamingStarted) {
      // Small delay to ensure the list has updated its content size
      Future.microtask(() => _scrollToBottom());
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 20,
      ),
      itemCount: widget.messages.length + (widget.isStreaming ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == 0 && widget.isStreaming) {
          return const _StreamingBubble();
        }
        final listIndex = widget.isStreaming ? index - 1 : index;
        final m = widget.messages[widget.messages.length - 1 - listIndex];
        return _MessageBubble(
          key: ValueKey(m.id),
          message: m,
        );
      },
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isUser
                ? colorScheme.primary
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft:
                  isUser ? const Radius.circular(20) : const Radius.circular(4),
              bottomRight:
                  isUser ? const Radius.circular(4) : const Radius.circular(20),
            ),
            boxShadow: [
              if (!isUser)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: MarkdownBody(
            data: message.content,
            styleSheet: MarkdownStyleSheet(
              p: theme.textTheme.bodyMedium?.copyWith(
                color: isUser ? colorScheme.onPrimary : colorScheme.onSurface,
              ),
              code: theme.textTheme.bodySmall?.copyWith(
                backgroundColor: isUser
                    ? Colors.black.withValues(alpha: 0.1)
                    : colorScheme.surface,
                color: isUser ? colorScheme.onPrimary : colorScheme.onSurface,
              ),
              codeblockDecoration: BoxDecoration(
                color: isUser
                    ? Colors.black.withValues(alpha: 0.1)
                    : colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StreamingBubble extends StatelessWidget {
  const _StreamingBubble();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ChatAiCubit, ChatAiState, String>(
      selector: (state) => state.streamingMessage,
      builder: (context, streamingMessage) {
        final decodedText = _decodeStringText(streamingMessage);
        return Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withValues(alpha: 0.5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: MarkdownBody(data: decodedText),
          ),
        );
      },
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
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_awesome,
              size: 48,
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'How can I help you today?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: suggestions.map((q) {
                return ActionChip(
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  label: Text(q),
                  onPressed: () {
                    final cubit = context.read<ChatAiCubit>();
                    cubit.onInputChanged(q);
                    cubit.sendMessage();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.2),
                    ),
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
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            ...items.map((s) {
              final isSelected = s == selected;
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 2,
                ),
                child: ListTile(
                  selected: isSelected,
                  selectedTileColor: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withValues(alpha: 0.3),
                  selectedColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  leading: const Icon(Icons.chat_bubble_outline, size: 20),
                  title: Text(
                    s.title.isEmpty ? 'Untitled' : s.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: isSelected
                        ? const TextStyle(fontWeight: FontWeight.w600)
                        : null,
                  ),
                  onTap: () => onSelect(s),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                  dense: true,
                ),
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
          if (l == 'Yesterday') {
            return DateTime(now.year, now.month, now.day).subtract(
              const Duration(days: 1),
            );
          }
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
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(24),
                  ),
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
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          isDense: true,
                        ),
                        maxLines: null,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              BlocSelector<ChatAiCubit, ChatAiState, (bool, bool)>(
                selector: (s) => (s.isLoading, s.isStreaming),
                builder: (context, state) {
                  final (isLoading, isStreaming) = state;
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: isStreaming
                          ? () => context.read<ChatAiCubit>().finishStreaming()
                          : isLoading
                              ? null
                              : () => context.read<ChatAiCubit>().sendMessage(),
                      icon: isStreaming
                          ? const Icon(Icons.stop_rounded, color: Colors.white)
                          : isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.arrow_upward_rounded,
                                  color: Colors.white),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

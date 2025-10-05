import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/ui/page/chat_ai/chat_ai_cubit.dart';

class ChatAiPage extends StatelessWidget {
  const ChatAiPage({super.key});

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
                      context.read<ChatAiCubit>().createSession('New chat');
                    },
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.sessions.length,
                      itemBuilder: (context, index) {
                        final s = state.sessions[index];
                        final isSelected = s == state.selectedSession;
                        return ListTile(
                          selected: isSelected,
                          leading: const Icon(Icons.chat_bubble_outline),
                          title: Text(s.title),
                          subtitle: Text(
                            s.createdAt.toLocal().toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            context.read<ChatAiCubit>().selectSession(s);
                          },
                        );
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
                    ? const _EmptyChat()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          final m = state.messages[index];
                          return Align(
                            alignment: m.isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: m.isUser
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.15)
                                    : Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(m.content),
                            ),
                          );
                        },
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

class _EmptyChat extends StatelessWidget {
  const _EmptyChat();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Start a new conversation from the drawer',
        style: Theme.of(context).textTheme.titleMedium,
        textAlign: TextAlign.center,
      ),
    );
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
            BlocSelector<ChatAiCubit, ChatAiState, bool>(
              selector: (s) => s.isLoading,
              builder: (context, isLoading) {
                return IconButton(
                  onPressed: isLoading
                      ? null
                      : () => context.read<ChatAiCubit>().sendMessage(),
                  icon: isLoading
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

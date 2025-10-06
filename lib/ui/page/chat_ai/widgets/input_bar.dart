import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/ui/page/chat_ai/chat_ai_cubit.dart';
import 'package:toeic_desktop/ui/page/chat_ai/chat_ai_state.dart';

class InputBar extends StatelessWidget {
  const InputBar({super.key});

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

import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/page/chat_ai/chat_ai_state.dart';

class SessionList extends StatelessWidget {
  const SessionList({
    super.key,
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

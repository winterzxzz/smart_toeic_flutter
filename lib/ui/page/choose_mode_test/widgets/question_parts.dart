import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/data/models/ui_models/part_model.dart';

class QuestionPart extends StatefulWidget {
  final PartModel part;
  final Function(PartModel) onChanged;
  final bool isSelected;

  const QuestionPart({
    super.key,
    required this.part,
    required this.onChanged,
    required this.isSelected,
  });

  @override
  State<QuestionPart> createState() => _QuestionPartState();
}

class _QuestionPartState extends State<QuestionPart> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Transform.scale(
              scale: 1.1,
              child: Checkbox(
                activeColor: theme.colorScheme.primary,
                shape: CircleBorder(
                  side: BorderSide(color: theme.colorScheme.primary, width: 1),
                ),
                value: widget.isSelected,
                onChanged: (value) {
                  widget.onChanged(widget.part);
                },
              ),
            ),
            Text(
              widget.part.partEnum.name,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        Wrap(
          spacing: 2,
          runSpacing: 4,
          children: List<Widget>.generate(
            widget.part.tags.length,
            (index) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                widget.part.tags[index],
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

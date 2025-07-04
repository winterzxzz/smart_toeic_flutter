import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';

class FlashCardMyListItem extends StatelessWidget {
  const FlashCardMyListItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return Expanded(
        child: Card(
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Word learned'),
                  Icon(Icons.check_circle_outline_outlined,
                      color: Colors.green),
                ],
              ),
              Text(
                '1,234',
                style: textTheme.headlineMedium,
              ),
              Text(
                'You\'ve learned 1,234 words so far',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';

class ProtipWidget extends StatelessWidget {
  const ProtipWidget({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  final String text;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: backgroundColor.withValues(alpha: 0.2)),
      child: Text(
        text,
        style: textTheme.bodySmall?.copyWith(
          color: textColor,
        ),
      ),
    );
  }
}

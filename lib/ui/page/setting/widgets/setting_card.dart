import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/app_style.dart';

class SettingsCard extends StatelessWidget {
  final Widget child;
  const SettingsCard({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Material(
      color: colorScheme.brightness == Brightness.dark
          ? Colors.grey.withValues(alpha: 0.2)
          : Colors.white70,
      shape: RoundedRectangleBorder(
        borderRadius: AppStyle.radius8,
        side: BorderSide(
          color: Colors.grey.withValues(alpha: 0.1),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppStyle.radius8,
        ),
        child: child,
      ),
    );
  }
}

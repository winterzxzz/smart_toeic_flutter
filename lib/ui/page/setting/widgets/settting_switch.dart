import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/app_style.dart';

class SettingsSwitch extends StatelessWidget {
  final bool value;
  final String title;
  final String? subtitle;
  final Function(bool) onChanged;
  const SettingsSwitch({
    required this.value,
    required this.title,
    this.subtitle,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return SwitchListTile(
      title: Text(
        title,
        style: textTheme.bodyMedium,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppStyle.radius8,
      ),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      contentPadding: AppStyle.edgeInsetsL16.copyWith(right: 8),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: textTheme.bodySmall!.copyWith(color: Colors.grey),
            )
          : null,
      value: value,
      onChanged: onChanged,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

class TextFieldHeading extends StatelessWidget {
  const TextFieldHeading({
    super.key,
    required this.label,
    required this.hintText,
    this.icon,
    required this.controller,
    this.maxLines,
  });

  final String label;
  final IconData? icon;
  final String hintText;
  final TextEditingController controller;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        SizedBox(
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w400,
            ),
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: hintText,
              isDense: true,
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textGray,
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
              prefix: icon != null
                  ? Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: FaIcon(icon, size: 16, color: AppColors.textGray))
                  : null,
              border: const OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColors.textGray),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColors.primary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

class TextFieldHeading extends StatelessWidget {
  const TextFieldHeading({
    super.key,
    required this.label,
    required this.description,
    required this.hintText,
    required this.controller,
  });

  final String label;
  final String description;
  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
              const SizedBox(height: 8),
              Text(description,
                  style: TextStyle(color: Colors.grey[500], fontSize: 10)),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: TextField(
            controller: controller,
            enabled: label != 'Profile Email',
            maxLines: label == 'Profile Bio' ? 3 : 1,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[500]),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).brightness == Brightness.light
                        ? AppColors.primary
                        : Colors.white),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

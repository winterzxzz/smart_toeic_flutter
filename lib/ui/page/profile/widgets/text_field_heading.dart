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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(description,
                  style: TextStyle(color: Colors.grey[500], fontSize: 14)),
            ],
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).brightness == Brightness.light
                        ? AppColors.primary
                        : Colors.white),
              ),
            ),
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}

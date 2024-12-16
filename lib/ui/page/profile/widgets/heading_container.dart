import 'package:flutter/material.dart';

class HeadingContainer extends StatelessWidget {
  const HeadingContainer(
      {super.key,
      required this.title,
      required this.description,
      required this.child});

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(description,
                  style: TextStyle(color: Colors.grey[500], fontSize: 14)),
            ],
          ),
        ),
        Expanded(
          child: child,
        ),
      ],
    );
  }
}

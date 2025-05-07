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
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
              const SizedBox(height: 8),
              Text(description,
                  style: TextStyle(color: Colors.grey[500], fontSize: 10)),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: child,
        ),
      ],
    );
  }
}

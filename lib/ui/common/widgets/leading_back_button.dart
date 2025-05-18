import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LeadingBackButton extends StatelessWidget {
  const LeadingBackButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ??
          () {
            GoRouter.of(context).pop();
          },
      icon: Icon(Icons.arrow_back_ios, size: 16),
    );
  }
}

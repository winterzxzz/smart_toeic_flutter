import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LeadingBackButton extends StatelessWidget {
  const LeadingBackButton({
    super.key,
    this.isClose = false,
    this.onPressed,
  });
  final bool isClose;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ??
          () {
            GoRouter.of(context).pop();
          },
      icon: isClose
          ? const Icon(Icons.close, size: 16)
          : const Icon(Icons.arrow_back_ios, size: 16),
    );
  }
}

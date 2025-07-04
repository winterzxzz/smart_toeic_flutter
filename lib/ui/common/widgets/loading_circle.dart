import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';

class LoadingCircle extends StatelessWidget {
  const LoadingCircle({
    super.key,
    this.size = 48,
    this.color,
    this.strokeWidth = 2,
  });

  final double size;
  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: CircularProgressIndicator(
            color: color ?? colorScheme.primary,
            strokeWidth: strokeWidth,
          ),
        ),
      ),
    );
  }
}

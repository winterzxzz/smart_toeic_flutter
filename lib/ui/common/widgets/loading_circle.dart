import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: CircularProgressIndicator(
            color: color ?? theme.colorScheme.primary,
            strokeWidth: strokeWidth,
          ),
        ),
      ),
    );
  }
}

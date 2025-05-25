import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

class LoadingCircle extends StatelessWidget {
  const LoadingCircle({
    super.key,
    this.size = 48,
    this.color = AppColors.primary,
    this.strokeWidth = 2,
  });

  final double size;
  final Color color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: CircularProgressIndicator(
          color: color,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

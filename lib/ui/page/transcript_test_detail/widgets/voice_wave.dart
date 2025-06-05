import 'package:flutter/material.dart';
import 'dart:math' as math;

class VoiceWave extends StatelessWidget {
  final List<double> levels;
  final double width;
  final double height;

  const VoiceWave({
    super.key,
    required this.levels,
    this.width = 320,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _VoiceBarWavePainter(levels: levels),
      ),
    );
  }
}

class _VoiceBarWavePainter extends CustomPainter {
  final List<double> levels;
  static const int barCount = 48;
  static const double minBarHeight = 10;
  static const double maxBarHeight = 64;
  static const double barWidth = 4;
  static const double barSpacing = 2;

  _VoiceBarWavePainter({required this.levels});

  @override
  void paint(Canvas canvas, Size size) {
    final double centerY = size.height / 2;
    const double totalWidth = barCount * barWidth + (barCount - 1) * barSpacing;
    final double startX = (size.width - totalWidth) / 2;

    for (int i = 0; i < barCount; i++) {
      final double t = (i - (barCount - 1) / 2) / ((barCount - 1) / 2);
      // Gaussian bell curve for smooth tapering
      final double bell = math.exp(-t * t * 2.5);
      final double normalizedLevel =
          (levels.length > i ? levels[i].clamp(0, 100) / 100 : 0.0);
      final double dynamicHeight = minBarHeight +
          bell * (maxBarHeight - minBarHeight) * (0.5 + 0.5 * normalizedLevel);
      final double barHeight = dynamicHeight;
      final double x = startX + i * (barWidth + barSpacing);
      final double y = centerY - barHeight / 2;

      // Fade out edge bars
      final double edgeFade = math.max(0.2, bell);

      // Vertical gradient for each bar
      final Rect barRect = Rect.fromLTWH(x, y, barWidth, barHeight);
      final Paint paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.yellow.withOpacity(edgeFade),
            Colors.green.withOpacity(edgeFade),
          ],
        ).createShader(barRect)
        ..style = PaintingStyle.fill;

      final RRect rrect =
          RRect.fromRectAndRadius(barRect, const Radius.circular(barWidth));
      canvas.drawRRect(rrect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _VoiceBarWavePainter oldDelegate) {
    return oldDelegate.levels != levels;
  }
}

class Math {
  static double sin(double radians) =>
      double.parse((Math._sin(radians)).toStringAsFixed(6));
  static double _sin(double radians) =>
      radians == 0 ? 0 : (radians - (radians * radians * radians) / 6);
}

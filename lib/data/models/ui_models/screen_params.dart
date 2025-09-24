import 'dart:math';
import 'dart:ui';

/// Singleton to record size related data
class ScreenParams {
  // by defaults sets to zero
  static Size screenSize = Size.zero;
  static Size? previewSize;

  static double get previewRatio {
    final size = previewSize;
    if (size == null) return 1;
    final height = size.height;
    final width = size.width;
    final maxValue = max(height, width);
    return maxValue == height ? maxValue / width : width / maxValue;
  }

  static Size get screenPreviewSize =>
      Size(screenSize.width, screenSize.width * previewRatio);
}

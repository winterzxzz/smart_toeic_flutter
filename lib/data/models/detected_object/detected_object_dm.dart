import 'package:flutter/cupertino.dart';
import 'package:toeic_desktop/common/utils/constants.dart';
import 'package:toeic_desktop/data/models/ui_models/screen_params.dart';

/// Represents the recognition output from the model
class DetectedObjectDm {
  const DetectedObjectDm({
    required this.label,
    required this.score,
    required this.location,
  });

  /// Label of the result
  final String label;

  /// Confidence [0.0, 1.0]
  final num score;

  /// Location of bounding box rect
  ///
  /// The rectangle corresponds to the raw input image
  /// passed for inference
  final Rect location;

  /// Returns bounding box rectangle corresponding to the
  /// displayed image on screen
  ///
  /// This is the actual location where rectangle is rendered on
  /// the screen
  Rect get renderLocation {
    final previewSize = ScreenParams.screenPreviewSize;
    final double scaleX =
        previewSize.width / Constants.ssdCompatibleImageWidth;
    final double scaleY =
        previewSize.height / Constants.ssdCompatibleImageHeight;
    return Rect.fromLTWH(
      location.left * scaleX,
      location.top * scaleY,
      location.width * scaleX,
      location.height * scaleY,
    );
  }

  @override
  String toString() {
    return 'DetectedObjectDm(label: $label, score: $score, location: $location)';
  }
}

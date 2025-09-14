import 'dart:ui';

import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:toeic_desktop/common/utils/constants.dart';
import 'package:toeic_desktop/data/models/detected_object/detected_object_dm.dart';
import 'package:toeic_desktop/data/models/ui_models/typedefs.dart';

class TensorflowHelper {
  const TensorflowHelper._();

  static List<String> getClassification({
    required int numberOfDetections,
    required List<int> classes,
    required List<String>? labelList,
  }) {
    final labels = labelList ?? [];
    final actualLabelLength = labels.length - 1;

    final classification = <String>[];

    for (var i = 0; i < numberOfDetections; i++) {
      final classificationLabelIndex = classes[i];
      final label = classificationLabelIndex > actualLabelLength
          // ??? --> if the respective label not found
          ? '???'
          : labels[classificationLabelIndex];
      classification.add(label);
    }

    return classification;
  }

  static List<Rect> getLocationsInRect(List<List<num>> locationsRaw) {
    final locations = <Rect>[];
    final locationsRawLength = locationsRaw.length;
    for (var i = 0; i < locationsRawLength; i++) {
      // locations in raw: [yMin, xMin, yMax, xMax]
      final raw = locationsRaw[i];

      // Convert normalized coordinates to pixel values

      // Top
      final yMin = (raw[0] * Constants.ssdCompatibleImageHeight).toDouble();

      // Left
      final xMin = (raw[1] * Constants.ssdCompatibleImageWidth).toDouble();

      // Bottom
      final yMax = (raw[2] * Constants.ssdCompatibleImageHeight).toDouble();

      // Right
      final xMax = (raw[3] * Constants.ssdCompatibleImageWidth).toDouble();

      // Add Rect object for bounding box
      locations.add(Rect.fromLTRB(xMin, yMin, xMax, yMax));
    }
    return locations;
  }

  static void drawOnImage({
    required img.Image imageInput,
    required Rect rect,
    required num score,
    String? classification,
    img.Color? color,
  }) {
    final drawColor = color ?? img.ColorRgb8(255, 255, 255);

    final top = rect.top.toInt();
    final left = rect.left.toInt();

    // Rectangle drawing
    img.drawRect(
      imageInput,
      // xMin
      x1: left,
      // yMin
      y1: top,
      // xMax
      x2: rect.right.toInt(),
      // yMax
      y2: rect.bottom.toInt(),
      color: drawColor,
      thickness: 3,
    );

    // Label drawing
    if (classification == null) return;
    img.drawString(
      imageInput,
      '$classification $score',
      font: img.arial14,
      x: left + 1,
      y: top + 1,
      color: drawColor,
    );
  }

  static AnalyseImageCallback analyseImage(
    img.Image image, {
    required Interpreter interpreter,
    required List<String> label,
    bool returnDetectedImage = true,
    bool drawObjectOnImage = true,
  }) {
    final resizedImage = img.copyResize(
      image,
      width: Constants.ssdCompatibleImageWidth,
      height: Constants.ssdCompatibleImageHeight,
    );

    /// Code continues below
    /// ... follow image (1.2 analyseImage)

    /// Continuation from Image 1.1

    final generatedOutput = _runInference(resizedImage, interpreter);

    final locationsRaw = generatedOutput[0].first as List<List<num>>;
    final classesRaw = generatedOutput[1].first as List<num>;
    final scores = generatedOutput[2].first as List<num>;
    final numberOfDetectionsRaw = generatedOutput[3].first as double;

    // Location
    final locationsInRect = getLocationsInRect(locationsRaw);

    // Classes
    final classes = classesRaw.map((e) => e.toInt()).toList();

    // Number of detections
    final numberOfDetections = numberOfDetectionsRaw.toInt();

    /// Code continues below
    /// ... follow image (1.3 analyseImage)

    /// Continuation from Image 1.2

    final classication = getClassification(
      numberOfDetections: numberOfDetections,
      classes: classes,
      labelList: label,
    );

    final detectedObjectList = <DetectedObjectDm>[];

    for (var i = 0; i < numberOfDetections; i++) {
      final score = scores[i];
      final detectedObjectName = classication[i];

      if (score > 0.5) {
        final location = locationsInRect[i];
        detectedObjectList.add(
          DetectedObjectDm(
            label: detectedObjectName,
            score: score,
            location: location,
          ),
        );
        if (!drawObjectOnImage) continue;
        drawOnImage(
          classification: detectedObjectName,
          imageInput: resizedImage,
          rect: location,
          score: score,
        );
      }
    }

    final imageOutput = returnDetectedImage
        ? img.encodeJpg(
            img.copyResize(
              resizedImage,
              height: image.height,
              width: image.width,
            ),
          )
        : null;

    /// end of analyseImage()

    return (imageBytes: imageOutput, detectedObjects: detectedObjectList);
  }

  static List<List<Object>> _runInference(
    img.Image image,
    Interpreter interpreter,
  ) {
    // Creating matrix representation, [300, 300, 3] from the [resizedImage]
    final imageMatrix = List.generate(
      image.height,
      (y) => List.generate(
        image.width,
        (x) {
          final pixel = image.getPixel(x, y);
          return [pixel.r, pixel.g, pixel.b];
        },
      ),
    );

    // Set input tensor [1, 300, 300, 3]
    final input = [imageMatrix];

    /// Code continues below
    /// ... follow image (1.2 _runInference)

    /// Continuation from Image _runInference 1.1

    // Set output tensor
    // Locations: [1, 10, 4]
    // Classes: [1, 10],
    // Scores: [1, 10],
    // Number of detections: [1]
    final output = {
      0: [List<List<num>>.filled(10, List<num>.filled(4, 0))],
      1: [List<num>.filled(10, 0)],
      2: [List<num>.filled(10, 0)],
      3: [0.0],
    };

    /// Code continues below
    /// ... follow image (1.3 _runInference)

    /// Continuation from Image _runInference 1.2
    interpreter.runForMultipleInputs([input], output);
    return output.values.toList();

    /// end of _runInference()
  }
}

import 'dart:typed_data';

import 'package:toeic_desktop/data/models/detected_object/detected_object_dm.dart';

typedef AnalyseImageCallback = ({
  Uint8List? imageBytes,
  List<DetectedObjectDm> detectedObjects
});

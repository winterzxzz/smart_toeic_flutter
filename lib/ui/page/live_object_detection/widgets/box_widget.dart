import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/detected_object/detected_object_dm.dart';


class BoxWidget extends StatelessWidget {
  const BoxWidget({
    required this.label,
    required this.score,
    this.width,
    this.height,
    super.key,
  });

  final double? width;
  final double? height;
  final String label;
  final num score;

  BoxWidget.fromDetectedObject(DetectedObjectDm recognition, {super.key})
      : label = recognition.label,
        score = recognition.score,
        width = recognition.renderLocation.width,
        height = recognition.renderLocation.height;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      width: width,
      height: height,
      decoration: const BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(color: Colors.white, width: 3),
        ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          bottomRight: Radius.circular(12),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 4),
          child: Container(
            color: Colors.white54,
            padding: const EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 12,
            ),
            child: FittedBox(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    score.toStringAsFixed(2),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

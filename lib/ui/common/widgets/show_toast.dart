import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showToast({
  required String title,
  String? description,
  required ToastificationType type,
}) {
  toastification.show(
      type: type,
      description: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        maxLines: 3,
        textAlign: TextAlign.start,
      ),
      primaryColor: Colors.white,
      alignment: Alignment.bottomCenter,
      pauseOnHover: false,
      autoCloseDuration: const Duration(seconds: 2),
      progressBarTheme: ProgressIndicatorThemeData(
        color: type == ToastificationType.success
            ? Colors.green
            : type == ToastificationType.info
                ? Colors.blue
                : type == ToastificationType.warning
                    ? Colors.orange
                    : Colors.red,
      ),
      showProgressBar: false,
      backgroundColor: type == ToastificationType.success
          ? Colors.green
          : type == ToastificationType.info
              ? Colors.blue
              : type == ToastificationType.warning
                  ? Colors.orange
                  : Colors.red,
      foregroundColor: Colors.white,
      closeButtonShowType: CloseButtonShowType.none);
}

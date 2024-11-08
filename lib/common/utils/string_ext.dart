import 'package:flutter/material.dart';
import 'package:iscanner_app/data/models/enums/start_with.dart';

extension StringExt on String {
  // from string convert to ThemeMode
  ThemeMode toThemeMode() {
    switch (this) {
      case 'system':
        return ThemeMode.system;
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  // from string convert to start with
  StartWith toStartWith() {
    switch (this) {
      case 'Home':
        return StartWith.home;
      case 'My files':
        return StartWith.myFiles;
      default:
        return StartWith.home;
    }
  }
}

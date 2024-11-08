import 'package:flutter/material.dart';

class BottomTabItem {
  final String title;
  final Function(BuildContext context)? onTap;

  BottomTabItem({required this.title, this.onTap});
}

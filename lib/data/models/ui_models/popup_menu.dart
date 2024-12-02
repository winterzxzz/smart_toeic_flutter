import 'package:flutter/material.dart';

class PopupMenu {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  PopupMenu({
    required this.title,
    required this.icon,
    required this.onPressed,
  });
}

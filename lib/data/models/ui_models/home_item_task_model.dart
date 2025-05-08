import 'package:flutter/material.dart';

class HomeItemTaskModel {
  final String title;
  final String image;
  final double? progress;
  final Function(BuildContext context)? onNavigate;
  final Function()? onTap;

  HomeItemTaskModel({
    required this.title,
    required this.image,
    this.progress,
    this.onNavigate,
    this.onTap,
  });
}

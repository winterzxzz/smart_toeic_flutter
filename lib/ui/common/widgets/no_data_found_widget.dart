import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/common/app_images.dart';

class NotDataFoundWidget extends StatelessWidget {
  const NotDataFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImages.notDataFound,
      fit: BoxFit.contain,
    );
  }
}

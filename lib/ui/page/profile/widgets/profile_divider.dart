import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

class ProfileDivider extends StatelessWidget {
  const ProfileDivider(
      {super.key, this.height = 32, this.color = AppColors.gray1});

  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: height),
        Divider(
          height: 1,
          color: color,
        ),
        SizedBox(height: height),
      ],
    );
  }
}



import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/common/app_images.dart';

class AvatarHeading extends StatelessWidget {
  const AvatarHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return   Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Profile Avatar',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text(
                        'Update your profile avatar and then choose where you want it to display',
                        style:
                            TextStyle(color: Colors.grey[500], fontSize: 14)),
                  ],
                ),
              ),
              Expanded(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(AppImages.profileBackground),
                ),
              ),
              const Expanded(child: SizedBox()),
      ],
    );
  }
}

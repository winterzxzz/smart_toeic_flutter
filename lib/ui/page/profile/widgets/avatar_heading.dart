import 'dart:developer';

import 'package:flutter/material.dart';

class AvatarHeading extends StatelessWidget {
  const AvatarHeading({super.key, required this.avatar});

  final String avatar;

  @override
  Widget build(BuildContext context) {
    log('AvatarHeading build: $avatar');
    return Row(
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
                  style: TextStyle(color: Colors.grey[500], fontSize: 14)),
            ],
          ),
        ),
        Expanded(
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            child: Text(avatar,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}

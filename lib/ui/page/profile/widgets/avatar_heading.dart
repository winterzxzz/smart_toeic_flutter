import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toeic_desktop/common/configs/app_configs.dart';
import 'package:toeic_desktop/data/models/entities/profile/user_entity.dart';
import 'package:toeic_desktop/ui/page/profile/profile_cubit.dart';

class AvatarHeading extends StatefulWidget {
  const AvatarHeading({super.key, required this.user});

  final UserEntity user;

  @override
  State<AvatarHeading> createState() => _AvatarHeadingState();
}

class _AvatarHeadingState extends State<AvatarHeading> {
  @override
  Widget build(BuildContext context) {
    String avatar = widget.user.avatar;
    if (avatar.isEmpty) {
      avatar = widget.user.name.characters.first.toUpperCase();
    }
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
          child: Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              backgroundImage: widget.user.avatar.isEmpty
                  ? null
                  : Image.network('${AppConfigs.baseUrl}/${widget.user.avatar}')
                      .image,
              child: Stack(
                children: [
                  Column(
                    children: [
                      if (widget.user.avatar.isNotEmpty)
                        Container(
                          color: Colors.transparent,
                        )
                      else
                        Text(widget.user.name.characters.first.toUpperCase(),
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: () {
                        _pickImage();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.camera_alt, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final file = File(image.path);
    if (mounted) {
      context.read<ProfileCubit>().updateProfileAvatar(file);
    }
  }
}

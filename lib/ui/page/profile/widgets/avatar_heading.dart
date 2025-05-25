import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/configs/app_configs.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/data/models/entities/profile/user_entity.dart';

class AvatarHeading extends StatefulWidget {
  const AvatarHeading({super.key, required this.user});

  final UserEntity? user;

  @override
  State<AvatarHeading> createState() => _AvatarHeadingState();
}

class _AvatarHeadingState extends State<AvatarHeading> {
  late final UserCubit profileCubit;
  @override
  void initState() {
    super.initState();
    profileCubit = injector<UserCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: CircleAvatar(
        radius: 48,
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        backgroundImage: widget.user?.avatar.isEmpty ?? true
            ? null
            : Image.network(
                    '${AppConfigs.baseUrl.replaceAll('/api', '')}${widget.user?.avatar}')
                .image,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.user?.avatar.isNotEmpty ?? true)
                  Container(
                    color: Colors.transparent,
                  )
                else
                  Text(widget.user?.name.characters.first.toUpperCase() ?? 'U',
                      style: const TextStyle(
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
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final file = File(image.path);
    profileCubit.updateProfileAvatar(file);
  }
}

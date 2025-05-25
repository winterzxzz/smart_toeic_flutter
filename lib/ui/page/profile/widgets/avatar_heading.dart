import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/configs/app_configs.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/data/models/entities/profile/user_entity.dart';

class AvatarHeading extends StatefulWidget {
  const AvatarHeading({super.key});


  @override
  State<AvatarHeading> createState() => _AvatarHeadingState();
}

class _AvatarHeadingState extends State<AvatarHeading> {
  late final UserCubit userCubit;
  @override
  void initState() {
    super.initState();
    userCubit = injector<UserCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: BlocSelector<UserCubit, UserState, UserEntity?>(
        selector: (state) {
          return state.user;
        },
        builder: (context, user) {
          return CircleAvatar(
            radius: 48,
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            backgroundImage: user?.avatar.isEmpty ?? true
                ? null
                : Image.network(
                        '${AppConfigs.baseUrl.replaceAll('/api', '')}${user?.avatar}')
                    .image,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (user?.avatar.isNotEmpty ?? true)
                      Container(
                        color: Colors.transparent,
                      )
                    else
                      Text(
                          user?.name.characters.first.toUpperCase() ??
                              'U',
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
          );
        },
      ),
    );
  }

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final file = File(image.path);
    userCubit.updateProfileAvatar(file);
  }
}

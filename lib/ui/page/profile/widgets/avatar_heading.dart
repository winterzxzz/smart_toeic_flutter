import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/configs/app_configs.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/data/models/entities/profile/user_entity.dart';
import 'package:toeic_desktop/ui/common/app_images.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_cached_image.dart';

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
    final theme = Theme.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        BlocSelector<UserCubit, UserState, UserEntity?>(
          selector: (state) {
            return state.user;
          },
          builder: (context, user) {
            final bool hasAvatar = user?.avatar.isNotEmpty ?? false;

            return CircleAvatar(
              radius: 48,
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              backgroundImage: hasAvatar ? null : null,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (hasAvatar)
                    ClipOval(
                      child: CustomCachedImage(
                        imageUrl:
                            '${AppConfigs.baseUrl.replaceAll('/api', '')}${user?.avatar}',
                        width: 96,
                        height: 96,
                        fit: BoxFit.cover,
                        errorWidget: Container(
                          width: 96,
                          height: 96,
                          color: Theme.of(context).secondaryHeaderColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                user?.name.characters.first.toUpperCase() ??
                                    'U',
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          user?.name.characters.first.toUpperCase() ?? 'U',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        ),
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
        BlocSelector<UserCubit, UserState, bool>(
          selector: (state) {
            return state.user?.isPremium() ?? false;
          },
          builder: (context, isPremium) {
            return Positioned(
              top: -28,
              left: 0,
              right: 0,
              child: SvgPicture.asset(
                AppImages.icPremium,
                width: 32,
                height: 32,
                colorFilter: ColorFilter.mode(
                  isPremium ? theme.colorScheme.primary : Colors.grey,
                  BlendMode.srcIn,
                ),
              ),
            );
          },
        ),
      ],
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

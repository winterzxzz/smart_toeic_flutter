import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toeic_desktop/common/configs/app_configs.dart';
import 'package:toeic_desktop/data/models/entities/profile/user_entity.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_images.dart';
import 'package:toeic_desktop/ui/page/profile/profile_cubit.dart';

class AvatarHeading extends StatefulWidget {
  const AvatarHeading({super.key, required this.user});

  final UserEntity? user;

  @override
  State<AvatarHeading> createState() => _AvatarHeadingState();
}

class _AvatarHeadingState extends State<AvatarHeading> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Profile Avatar',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 8),
              Text(
                  'Update your profile avatar and then choose where you want it to display',
                  style: TextStyle(color: Colors.grey[500], fontSize: 10)),
            ],
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              backgroundImage: widget.user?.avatar.isEmpty ?? true
                  ? null
                  // remove first and last character from the string
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
                        Text(
                            widget.user?.name.characters.first.toUpperCase() ??
                                'U',
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
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
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
          ),
        ),
        Expanded(
          child: widget.user?.isPremium() ?? false
              ? SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Membership Level',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              AppImages.icPremium,
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(
                                AppColors.textWhite,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('Premium',
                                style: TextStyle(
                                    color: AppColors.textWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
        )
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

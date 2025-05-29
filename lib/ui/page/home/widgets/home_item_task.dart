import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toeic_desktop/data/models/ui_models/home_item_task_model.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

class HomeItemTask extends StatelessWidget {
  const HomeItemTask({
    super.key,
    required this.homeItemTaskModel,
  });

  final HomeItemTaskModel homeItemTaskModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            if (homeItemTaskModel.onNavigate != null) {
              homeItemTaskModel.onNavigate!(context);
            } else {
              if (homeItemTaskModel.onTap != null) {
                homeItemTaskModel.onTap!();
              }
            }
          },
          child: Container(
            height: 90,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: theme.appBarTheme.backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: AppColors.backgroundBlur.withValues(alpha: 0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  SvgPicture.asset(
                      width: 32,
                      height: 32,
                      homeItemTaskModel.image,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      )),
                  const Spacer(),
                  if (homeItemTaskModel.progress != null)
                    LinearProgressIndicator(
                      value: homeItemTaskModel.progress,
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.primary,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.3),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          homeItemTaskModel.title,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textBlack,
          ),
        ),
      ],
    );
  }
}

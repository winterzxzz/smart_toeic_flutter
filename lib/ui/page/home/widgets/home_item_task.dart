import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toeic_desktop/data/models/ui_models/home_item_task_model.dart';

class HomeItemTask extends StatelessWidget {
  const HomeItemTask({
    super.key,
    required this.homeItemTaskModel,
  });

  final HomeItemTaskModel homeItemTaskModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        if (homeItemTaskModel.onNavigate != null) {
          homeItemTaskModel.onNavigate!(context);
        } else {
          if (homeItemTaskModel.onTap != null) {
            homeItemTaskModel.onTap!();
          }
        }
      },
      child: Column(
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: SizedBox(
              height: 90,
              width: 80,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    SvgPicture.asset(
                      width: 32,
                      height: 32,
                      homeItemTaskModel.image,
                      colorFilter: ColorFilter.mode(
                        theme.colorScheme.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    const Spacer(),
                    if (homeItemTaskModel.progress != null)
                      LinearProgressIndicator(
                        value: homeItemTaskModel.progress,
                        borderRadius: BorderRadius.circular(8),
                        color: theme.colorScheme.primary,
                        backgroundColor:
                            theme.colorScheme.primary.withValues(alpha: 0.3),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            homeItemTaskModel.title,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

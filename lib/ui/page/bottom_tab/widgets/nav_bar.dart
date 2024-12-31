import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/common/utils/constants.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_images.dart';
import 'package:toeic_desktop/ui/page/bottom_tab/bottom_tab.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
    required this.widget,
  });

  final BottomTabPage widget;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 60,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                GoRouter.of(context).go(AppRouter.home);
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset(
                  width: 24,
                  height: 24,
                  AppImages.icHome,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).brightness == Brightness.dark
                        ? AppColors.textWhite
                        : AppColors.textBlack,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),

            const Divider(
              height: 1,
            ),
            const SizedBox(height: 16),
            // Center - Navigation
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: Constants.bottomTabs
                  .map(
                    (item) => Column(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            GoRouter.of(context).go(item.route);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: widget.navigationShell.currentIndex ==
                                      Constants.bottomTabs.indexOf(item) + 1
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.transparent,
                            ),
                            child: SvgPicture.asset(
                              width: 24,
                              height: 24,
                              item.icon,
                              colorFilter: ColorFilter.mode(
                                widget.navigationShell.currentIndex ==
                                        Constants.bottomTabs.indexOf(item) + 1
                                    ? AppColors.textWhite
                                    : Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColors.textWhite
                                        : AppColors.textBlack,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  )
                  .toList(),
            ),

            const Spacer(),

            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                GoRouter.of(context).go(AppRouter.setting);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: widget.navigationShell.currentIndex == 8
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset(
                  width: 24,
                  height: 24,
                  AppImages.icSetting,
                  colorFilter: ColorFilter.mode(
                    widget.navigationShell.currentIndex == 8
                        ? AppColors.textWhite
                        : Theme.of(context).brightness == Brightness.dark
                            ? AppColors.textWhite
                            : AppColors.textBlack,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

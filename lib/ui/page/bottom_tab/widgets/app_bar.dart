import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/configs/app_configs.dart';
import 'package:toeic_desktop/common/global_blocs/setting/app_setting_cubit.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/database/share_preferences_helper.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_images.dart';
import 'package:toeic_desktop/ui/common/widgets/confirm_dia_log.dart';
import 'package:toeic_desktop/ui/page/test_online/test_online_cubit.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          final navigationKey = AppRouter.navigationKey;
          if (navigationKey.currentState != null &&
              navigationKey.currentState!.context.canPop()) {
            injector<AppSettingCubit>().removeNavigationHistory();
            GoRouter.of(navigationKey.currentState!.context).pop();
          }
        },
        icon: const Icon(
          Icons.arrow_back_ios_new,
          size: 20,
        ),
      ),
      title: BlocSelector<AppSettingCubit, AppSettingState, String>(
        selector: (state) {
          return state.currentPath;
        },
        builder: (context, currentPath) {
          return Text(currentPath);
        },
      ),
      actions: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: BlocSelector<AppSettingCubit, AppSettingState, ThemeMode>(
            selector: (state) {
              return state.themeMode;
            },
            builder: (context, themeMode) {
              final isDarkMode = themeMode == ThemeMode.dark;
              return IconButton(
                key: ValueKey<bool>(isDarkMode),
                onPressed: () {
                  injector<AppSettingCubit>().changeThemeMode(
                    themeMode: isDarkMode ? ThemeMode.light : ThemeMode.dark,
                  );
                },
                icon: SvgPicture.asset(
                  isDarkMode
                      ? AppImages.icDarkModeActive
                      : AppImages.icDarkModeInactive,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    isDarkMode
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).brightness == Brightness.dark
                            ? AppColors.textWhite
                            : AppColors.textBlack,
                    BlendMode.srcIn,
                  ),
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
        IconButton(
          onPressed: () {
            GoRouter.of(context).go(AppRouter.upgradeAccount);
          },
          icon: BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              final isPremium = state.user?.isPremium() ?? false;
              return SvgPicture.asset(
                AppImages.icPremium,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  isPremium
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).brightness == Brightness.dark
                          ? AppColors.textWhite
                          : AppColors.textBlack,
                  BlendMode.srcIn,
                ),
              );
            },
          ),
        ),
        Builder(
          builder: (context) {
            final cookies = SharedPreferencesHelper().getCookies();
            if (cookies != null) {
              return IconButton(
                onPressed: () {
                  _showMenu(context);
                },
                icon: BlocBuilder<UserCubit, UserState>(
                  builder: (context, state) {
                    return CircleAvatar(
                      radius: 16,
                      backgroundColor: Theme.of(context).cardColor,
                      backgroundImage: state.user?.avatar.isEmpty ?? true
                          ? null
                          : Image.network(
                              '${AppConfigs.baseUrl.replaceAll('/api', '')}${state.user!.avatar}',
                            ).image,
                      child: state.user?.avatar.isEmpty ?? true
                          ? Text(
                              state.user?.name.substring(0, 1) ?? 'U',
                            )
                          : null,
                    );
                  },
                ),
              );
            }
            return TextButton(
              onPressed: () {
                GoRouter.of(context).go(AppRouter.login);
              },
              child: const Text('Login'),
            );
          },
        ),
      ],
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                // GoRouter.of(context).go(AppRouter.bottomTab);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Setting'),
              onTap: () {
                Navigator.pop(context);
                GoRouter.of(context).go(AppRouter.setting);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                showConfirmDialog(
                  context,
                  'Logout',
                  'Are you sure?',
                  () {
                    injector<UserCubit>().removeUser(context).then((_) {
                      injector.resetLazySingleton<DeThiOnlineCubit>();
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

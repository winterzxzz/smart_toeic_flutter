import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/setting/app_setting_cubit.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/common/utils/constants.dart';
import 'package:toeic_desktop/data/database/share_preferences_helper.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_images.dart';
import 'package:toeic_desktop/ui/common/widgets/confirm_dia_log.dart';
import 'package:toeic_desktop/ui/page/test_online/test_online_cubit.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 16),
          IconButton(
            onPressed: () {
              final navigationKey = AppRouter.navigationKey;
              if (navigationKey.currentState != null &&
                  navigationKey.currentState!.context.canPop()) {
                injector<AppSettingCubit>().removeNavigationHistory();
                GoRouter.of(navigationKey.currentState!.context).pop();
              }
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 20,
            ),
          ),
          const SizedBox(width: 32),
          BlocSelector<AppSettingCubit, AppSettingState, String>(
            selector: (state) {
              return state.currentPath;
            },
            builder: (context, currentPath) {
              return Text(currentPath);
            },
          ),
          Spacer(),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: BlocSelector<AppSettingCubit, AppSettingState, ThemeMode>(
              selector: (state) {
                return state.themeMode;
              },
              builder: (context, themeMode) {
                final isDarkMode = themeMode == ThemeMode.dark;
                return InkWell(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  key: ValueKey<bool>(isDarkMode),
                  onTap: () {
                    injector<AppSettingCubit>().changeThemeMode(
                      themeMode: isDarkMode ? ThemeMode.light : ThemeMode.dark,
                    );
                  },
                  child: SvgPicture.asset(
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
          const SizedBox(width: 32),
          InkWell(
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              GoRouter.of(context).go(AppRouter.upgradeAccount);
            },
            child: BlocBuilder<UserCubit, UserState>(
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
          const SizedBox(width: 16),
          Builder(
            builder: (context) {
              final cookies = SharedPreferencesHelper().getCookies();
              if (cookies != null) {
                return InkWell(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    _showMenu(context);
                  },
                  child: BlocBuilder<UserCubit, UserState>(
                    builder: (context, state) {
                      return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Theme.of(context).cardColor,
                              backgroundImage:
                                  state.user?.avatar.isEmpty ?? true
                                      ? null
                                      : Image.network(
                                          '${Constants.hostUrl}${state.user!.avatar}',
                                        ).image,
                              child: state.user?.avatar.isEmpty ?? true
                                  ? Text(
                                      state.user?.name.substring(0, 1) ?? 'U',
                                    )
                                  : null));
                    },
                  ),
                );
              }
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    GoRouter.of(context).go(AppRouter.login);
                  },
                  child: const Text(
                    'Login',
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showMenu(
      context: context,
      // right and top
      color: Theme.of(context).cardColor,
      position: RelativeRect.fromLTRB(
        MediaQuery.of(context).size.width - 100,
        50,
        MediaQuery.of(context).size.width,
        100,
      ),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      items: [
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.person),
              const SizedBox(width: 8),
              Text('Profile'),
            ],
          ),
          onTap: () {
            GoRouter.of(context).go(AppRouter.profile);
          },
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.settings),
              const SizedBox(width: 8),
              Text('Setting'),
            ],
          ),
          onTap: () {
            GoRouter.of(context).go(AppRouter.setting);
          },
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.logout),
              const SizedBox(width: 8),
              Text('Logout'),
            ],
          ),
          onTap: () {
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
    );
  }
}

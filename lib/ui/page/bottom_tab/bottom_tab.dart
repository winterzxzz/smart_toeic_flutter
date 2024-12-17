import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/configs/app_configs.dart';
import 'package:toeic_desktop/common/global_blocs/setting/app_setting_cubit.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/common/utils/constants.dart';
import 'package:toeic_desktop/data/database/share_preferences_helper.dart';
import 'package:toeic_desktop/data/models/ui_models/payment_return.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_images.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomTabPage extends StatefulWidget {
  const BottomTabPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<BottomTabPage> createState() => _BottomTabPageState();
}

class _BottomTabPageState extends State<BottomTabPage>
    with TickerProviderStateMixin {
  bool _isChatVisible = false;
  late AnimationController _animationController;
  final List<String> _messages = [
    "Hi! 👋 I'm Finch, and I'll be your guide to Sendbird today.",
    "Did you know in-app messages boost engagement rates by 131%?",
    "Tell me which of the following interests you in enhancing customer communication :)"
  ];
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _appLinks = AppLinks();

    initDeepLinks();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> initDeepLinks() async {
    // Handle links
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      debugPrint('onAppLink: $uri');
      final path = uri.pathSegments.first;
      final params = uri.queryParameters;
      final paymentReturn = PaymentReturn(
        amount: params['amount'] ?? '',
        appid: params['appid'] ?? '',
        apptransid: params['apptransid'] ?? '',
        bankcode: params['bankcode'] ?? '',
        checksum: params['checksum'] ?? '',
        discountamount: params['discountamount'] ?? '',
        pmcid: params['pmcid'] ?? '',
        status: params['status'] ?? '',
      );
      GoRouter.of(context).go('/$path', extra: {
        'paymentReturn': paymentReturn,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: Builder(builder: (context) {
        final isLogin = SharedPreferencesHelper().getCookies() != null;
        if (!isLogin) {
          return Container();
        }
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                setState(() {
                  _isChatVisible = !_isChatVisible;
                  if (_isChatVisible) {
                    _animationController.forward();
                  } else {
                    _animationController.reverse();
                  }
                });
              },
              icon: _isChatVisible
                  ? Icon(
                      Icons.close,
                    )
                  : Icon(
                      Icons.message,
                    ),
            ),
          ),
        );
      }),
      body: Stack(
        children: [
          Row(
            children: [
              NavBar(widget: widget),
              Expanded(
                  child: Column(
                children: [
                  AppBar(),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                        ),
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.gray3
                              : AppColors.inputBorder,
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                        ),
                        child: widget.navigationShell,
                      ),
                    ),
                  ),
                ],
              )),
            ],
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _isChatVisible ? 70 : -416,
            left: _isChatVisible
                ? MediaQuery.of(context).size.width - 416
                : MediaQuery.of(context).size.width,
            width: 400,
            child: ScaleTransition(
              scale: _isChatVisible
                  ? Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.easeInOut,
                      ),
                    )
                  : AlwaysStoppedAnimation(0.0),
              child: Card(
                elevation: 10,
                child: Container(
                  height: 500,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Finch from Sendbird",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _isChatVisible = false;
                              });
                            },
                          ),
                        ],
                      ),
                      Divider(),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(_messages[index]),
                            );
                          },
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Enter message",
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.send),
                        ),
                        onSubmitted: (text) {
                          setState(() {
                            _messages.add(text);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppBar extends StatelessWidget {
  const AppBar({
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
          const SizedBox(width: 16),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_forward_ios,
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
                  splashFactory: NoSplash.splashFactory,
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
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 32),
          InkWell(
            onTap: () {
              GoRouter.of(context).go(AppRouter.upgradeAccount);
            },
            child: SvgPicture.asset(
              AppImages.icPremium,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                Theme.of(context).brightness == Brightness.dark
                    ? AppColors.textWhite
                    : AppColors.textBlack,
                BlendMode.srcIn,
              ),
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
                                          '${AppConfigs.baseUrl}/${state.user?.avatar}',
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
          onTap: () {},
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
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Logout'),
                content: Text('Are you sure?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      injector<UserCubit>().removeUser(context).then((_) {});
                    },
                    child: Text('Logout'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

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
                                  ? AppColors.backgroundBottomTab
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
                  color: widget.navigationShell.currentIndex == 7
                      ? AppColors.backgroundBottomTab
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset(
                  width: 24,
                  height: 24,
                  AppImages.icSetting,
                  colorFilter: ColorFilter.mode(
                    widget.navigationShell.currentIndex == 7
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

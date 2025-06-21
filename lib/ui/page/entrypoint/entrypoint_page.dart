import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/utils/constants.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/keep_alive_page.dart';
import 'package:toeic_desktop/ui/page/blogs/blog_page.dart';
import 'package:toeic_desktop/ui/page/entrypoint/entrypoint_cubit.dart';
import 'package:toeic_desktop/ui/page/entrypoint/entrypoint_state.dart';
import 'package:toeic_desktop/ui/page/home/home_page.dart';
import 'package:toeic_desktop/ui/page/profile/profile_page.dart';
import 'package:toeic_desktop/ui/page/flash_card/set_flashcard/set_flash_card_page.dart';
import 'package:toeic_desktop/ui/page/test/tests/tests_page.dart';

class BottomTabPage extends StatefulWidget {
  const BottomTabPage({super.key});

  @override
  State<BottomTabPage> createState() => _BottomTabPageState();
}

class _BottomTabPageState extends State<BottomTabPage>
    with TickerProviderStateMixin {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  static const String _channel = 'com.example.toeic_desktop/deeplink';
  static const platform = MethodChannel(_channel);

  @override
  void initState() {
    super.initState();
    platform.setMethodCallHandler((call) async {
      if (call.method == 'onDeepLinkReceived') {
        final uri = Uri.parse(call.arguments);
        handleDeepLink(uri, isFromWidget: true);
      }
    });
    _appLinks = AppLinks();
    initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      handleDeepLink(uri);
    });
  }

  void handleDeepLink(Uri uri, {bool isFromWidget = false}) {
    if (!mounted) return;
    String path = uri.path;
    String? query = uri.hasQuery ? uri.query : null;
    if (uri.scheme == 'test' && uri.host == 'winter-toeic.com') {
      final pathWithQuery = path + (query != null ? '?$query' : '');
      GoRouter.of(context).go(pathWithQuery);
      if (isFromWidget) {
        injector<EntrypointCubit>().changeCurrentIndex(2);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<EntrypointCubit>(),
      child: Page(widget: widget),
    );
  }
}

class Page extends StatefulWidget {
  const Page({
    super.key,
    required this.widget,
  });

  final BottomTabPage widget;

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  late final EntrypointCubit _entrypointCubit;

  @override
  void initState() {
    super.initState();
    _entrypointCubit = injector<EntrypointCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OrientationBuilder(
      builder: (context, orientation) {
        return BlocBuilder<EntrypointCubit, EntrypointState>(
          builder: (context, state) {
            return Scaffold(
              body: Row(
                children: [
                  Visibility(
                    visible: orientation == Orientation.landscape,
                    child: NavigationRail(
                      minWidth: 50,
                      selectedIndex: state.currentIndex,
                      onDestinationSelected: (index) {
                        _entrypointCubit.changeCurrentIndex(index);
                      },
                      labelType: NavigationRailLabelType.none,
                      destinations: Constants.bottomTabs
                          .map(
                            (item) => NavigationRailDestination(
                              icon: SvgPicture.asset(
                                state.currentIndex ==
                                        Constants.bottomTabs.indexOf(item)
                                    ? item.iconFill
                                    : item.iconOutline,
                                width: 20,
                                height: 20,
                                colorFilter: state.currentIndex ==
                                        Constants.bottomTabs.indexOf(item)
                                    ? const ColorFilter.mode(
                                        AppColors.primary,
                                        BlendMode.srcIn,
                                      )
                                    : null,
                              ),
                              label: Text(item.title),
                              padding: const EdgeInsets.all(8),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _entrypointCubit.pageController,
                      onPageChanged: (index) =>
                          _entrypointCubit.changeCurrentIndex(index),
                      children: const [
                        KeepAlivePage(child: HomePage()),
                        KeepAlivePage(child: TestsPage()),
                        KeepAlivePage(child: SetFlashCardPage()),
                        KeepAlivePage(child: BlogPage()),
                        KeepAlivePage(child: ProfilePage()),
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: Visibility(
                visible: orientation == Orientation.portrait,
                child: Builder(builder: (context) {
                  final bottomTabs = Constants.bottomTabs;
                  return BottomNavigationBar(
                    useLegacyColorScheme: true,
                    selectedItemColor: theme.colorScheme.primary,
                    unselectedItemColor: AppColors.gray3,
                    selectedLabelStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    showUnselectedLabels: true,
                    iconSize: 20,
                    currentIndex: state.currentIndex,
                    onTap: (index) {
                      _entrypointCubit.changeCurrentIndex(index);
                    },
                    items: bottomTabs.map((tab) {
                      return BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          state.currentIndex == bottomTabs.indexOf(tab)
                              ? tab.iconFill
                              : tab.iconOutline,
                          width: 20,
                          height: 20,
                          colorFilter:
                              state.currentIndex == bottomTabs.indexOf(tab)
                                  ? ColorFilter.mode(
                                      theme.colorScheme.primary,
                                      BlendMode.srcIn,
                                    )
                                  : const ColorFilter.mode(
                                      AppColors.gray3,
                                      BlendMode.srcIn,
                                    ),
                        ),
                        label: tab.title,
                      );
                    }).toList(),
                  );
                }),
              ),
            );
          },
        );
      },
    );
  }
}

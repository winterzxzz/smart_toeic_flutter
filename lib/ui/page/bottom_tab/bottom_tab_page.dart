import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/ui_models/payment_return.dart';
import 'package:toeic_desktop/common/utils/constants.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/keep_alive_page.dart';
import 'package:toeic_desktop/ui/page/blog/blog_page.dart';
import 'package:toeic_desktop/ui/page/bottom_tab/bottom_tab_cubit.dart';
import 'package:toeic_desktop/ui/page/bottom_tab/bottom_tab_state.dart';
import 'package:toeic_desktop/ui/page/home/home_page.dart';
import 'package:toeic_desktop/ui/page/profile/profile_page.dart';
import 'package:toeic_desktop/ui/page/set_flashcard/set_flash_card_page.dart';
import 'package:toeic_desktop/ui/page/test_online/test_online_page.dart';

class BottomTabPage extends StatefulWidget {
  const BottomTabPage({super.key});

  @override
  State<BottomTabPage> createState() => _BottomTabPageState();
}

class _BottomTabPageState extends State<BottomTabPage>
    with TickerProviderStateMixin {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();

    initDeepLinks();
  }

  @override
  void dispose() {
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
      if (mounted) {
        GoRouter.of(context).go('/$path', extra: {
          'paymentReturn': paymentReturn,
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<BottomTabCubit>(),
      child: Page(widget: widget),
    );
  }
}

class Page extends StatelessWidget {
  const Page({
    super.key,
    required this.widget,
  });

  final BottomTabPage widget;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return BlocBuilder<BottomTabCubit, BottomTabState>(
          builder: (context, state) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Row(
                children: [
                  Visibility(
                    visible: orientation == Orientation.landscape,
                    child: NavigationRail(
                      minWidth: 50,
                      selectedIndex: state.currentIndex,
                      onDestinationSelected: (index) {
                        context
                            .read<BottomTabCubit>()
                            .changeCurrentIndex(index);
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
                      controller: context.read<BottomTabCubit>().pageController,
                      onPageChanged: (index) => context
                          .read<BottomTabCubit>()
                          .changeCurrentIndex(index),
                      children: const [
                        KeepAlivePage(child: HomePage()),
                        KeepAlivePage(child: SimulationTestScreen()),
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
                child: BottomNavigationBar(
                  useLegacyColorScheme: true,
                  backgroundColor: AppColors.backgroundLight,
                  selectedItemColor: AppColors.primary,
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
                    context.read<BottomTabCubit>().changeCurrentIndex(index);
                  },
                  items: Constants.bottomTabs.map((tab) {
                    return BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        state.currentIndex == Constants.bottomTabs.indexOf(tab)
                            ? tab.iconFill
                            : tab.iconOutline,
                        width: 20,
                        height: 20,
                        colorFilter: state.currentIndex ==
                                Constants.bottomTabs.indexOf(tab)
                            ? const ColorFilter.mode(
                                AppColors.primary,
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
                ),
              ),
            );
          },
        );
      },
    );
  }
}

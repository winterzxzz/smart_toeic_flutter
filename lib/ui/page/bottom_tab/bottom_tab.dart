import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/data/models/ui_models/payment_return.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/bottom_tab/widgets/app_bar.dart';
import 'package:toeic_desktop/common/utils/constants.dart';

class BottomTabPage extends StatefulWidget {
  const BottomTabPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarWidget(),
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: (index) {
          widget.navigationShell.goBranch(
            index,
            initialLocation: index == widget.navigationShell.currentIndex,
          );
        },
        destinations: Constants.bottomTabs.map((tab) {
          return NavigationDestination(
            icon: Image.asset(
              tab.icon,
              width: 24,
              height: 24,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textWhite
                  : AppColors.textBlack,
            ),
            label: tab.title,
          );
        }).toList(),
      ),
    );
  }
}

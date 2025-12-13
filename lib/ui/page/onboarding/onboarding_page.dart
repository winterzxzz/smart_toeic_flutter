import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/common/utils/constants.dart';
import 'package:toeic_desktop/data/database/share_preferences_helper.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/page/onboarding/widgets/onboarding_content.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: Constants.services.length + 1,
              onPageChanged: (value) {
                setState(() {
                  _currentPage = value;
                });
              },
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const OnboardingContent();
                } else {
                  return OnboardingContent(item: Constants.services[index - 1]);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_currentPage > 0)
                  InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: _onPrevious,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: colorScheme.primary, width: 2),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.arrow_back_ios,
                        weight: 2,
                        size: 16,
                        color: colorScheme.primary,
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 42),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      List.generate(Constants.services.length + 1, (index) {
                    return Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == _currentPage
                            ? colorScheme.primary
                            : colorScheme.primary.withValues(alpha: 0.2),
                      ),
                    );
                  }),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: _onNext,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _onPrevious() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onNext() {
    if (_currentPage < Constants.services.length) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _onToLogin();
    }
  }

  void _onToLogin() async {
    await injector<SharedPreferencesHelper>()
        .setFirstRun(isFirstRun: false)
        .then((value) {
      if (mounted) {
        GoRouter.of(context).goNamed(AppRouter.login);
      }
    });
  }
}

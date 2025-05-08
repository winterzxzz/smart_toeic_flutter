import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/common/utils/constants.dart';
import 'package:toeic_desktop/data/database/share_preferences_helper.dart';
import 'package:toeic_desktop/data/models/ui_models/service_item.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_images.dart';
import 'package:toeic_desktop/ui/common/app_text_styles.dart';

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
    return Scaffold(
      backgroundColor: AppColors.background,
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
                  return OnboardingContentFirst();
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
                        border: Border.all(color: AppColors.primary, width: 2),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.primary,
                        weight: 2,
                        size: 16,
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
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: 0.2),
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
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
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
      setState(() {
        _currentPage--;
      });
    }
  }

  void _onNext() {
    if (_currentPage < Constants.services.length) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage++;
      });
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

class OnboardingContentFirst extends StatelessWidget {
  const OnboardingContentFirst({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: 'app_logo',
          child: Image.asset(
            AppImages
                .appLogo, // Replace with your onboarding illustration asset
            width: 180,
            height: 180,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Thank You For Trusting TOEIC Test Pro',
            style: AppTextStyle.blackS18Bold.copyWith(fontSize: 22),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'The best app for TOEIC test-takers',
            style: AppTextStyle.grayS16,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    super.key,
    required this.item,
  });

  final ServiceItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FaIcon(
          item.icon,
          size: 180,
          color: AppColors.primary,
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            item.title,
            style: AppTextStyle.blackS18Bold.copyWith(fontSize: 22),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            item.desciption,
            style: AppTextStyle.grayS16,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

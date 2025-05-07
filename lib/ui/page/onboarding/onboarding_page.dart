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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          // Placeholder for the heart-in-hand illustration
          Builder(builder: (context) {
            if (_currentPage == 0) {
              return OnboardingContentFirst();
            } else {
              return OnboardingContent(
                  item: Constants.services[_currentPage - 1]);
            }
          }),
          const Spacer(flex: 3),
          // Page indicator
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(Constants.services.length + 1, (index) {
                return Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == _currentPage
                        ? AppColors.textBlue
                        : AppColors.textBlue.withValues(alpha: 0.2),
                  ),
                );
              }),
            ),
          ),
          // Next button
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 24, bottom: 24),
              child: Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage < (Constants.services.length)) {
                      setState(() {
                        _currentPage++;
                      });
                    } else {
                      _onToLogin();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: AppColors.textBlue,
                    elevation: 0,
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
          color: AppColors.textBlue,
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

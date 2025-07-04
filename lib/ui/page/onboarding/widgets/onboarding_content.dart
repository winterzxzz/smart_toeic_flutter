import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toeic_desktop/data/models/ui_models/service_item.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/app_images.dart';

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    super.key,
    this.item,
  });

  final ServiceItem? item;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return Column(
      children: [
        if (item == null)
          Hero(
            tag: 'app_logo',
            child: Image.asset(
              AppImages
                  .appLogo, // Replace with your onboarding illustration asset
              width: 180,
              height: 180,
              fit: BoxFit.contain,
            ),
          )
        else
          FaIcon(
            item!.icon,
            size: 180,
            color: colorScheme.primary,
          ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            item == null ? S.current.onboarding_title : item!.title,
            style: textTheme.titleLarge?.copyWith(
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            item == null ? S.current.onboarding_description : item!.desciption,
            style: textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

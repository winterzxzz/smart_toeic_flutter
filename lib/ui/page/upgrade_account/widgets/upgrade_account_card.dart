import 'package:flutter/material.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';

class UpgradeAccountCard extends StatelessWidget {
  const UpgradeAccountCard({
    super.key,
    required this.title,
    required this.price,
    required this.features,
    required this.available,
    required this.isCurrentPlan,
    required this.isPremium,
    this.onPressed,
  });

  final String title;
  final String price;
  final List<String> features;
  final List<bool> available;
  final bool isCurrentPlan;
  final bool isPremium;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color backgroundColor = theme.brightness == Brightness.light
        ? AppColors.backgroundLight
        : AppColors.backgroundDarkSub;
    final Color textColor = theme.brightness == Brightness.light
        ? AppColors.textBlack
        : AppColors.textWhite;
    final inactiveBorderColor = theme.brightness == Brightness.light
        ? Colors.grey[300]!
        : Colors.grey[600]!;
    final activeBorderColor = theme.brightness == Brightness.light
        ? theme.colorScheme.primary
        : theme.colorScheme.primary;
    final Color borderColor =
        isCurrentPlan ? activeBorderColor : inactiveBorderColor;
    BoxBorder border = isCurrentPlan
        ? Border(
            left: BorderSide(color: borderColor, width: 5), // Left border
            top: BorderSide(color: borderColor, width: 1), // Top border
            right: BorderSide(color: borderColor, width: 1), // Right border
            bottom: BorderSide(color: borderColor, width: 1), // Bottom border
          )
        : Border.all(color: borderColor);
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: border,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      backgroundColor: Colors.grey,
                      color: textColor,
                      value: features
                              .where((element) =>
                                  available[features.indexOf(element)])
                              .length /
                          features.length,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: List.generate(features.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Icon(
                            available[index] ? Icons.check : Icons.close,
                            color: available[index] ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              features[index],
                              style: theme.textTheme.bodyMedium!.copyWith(
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 8),
              if (onPressed == null)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  child: CustomButton(
                    height: 50,
                    onPressed: null,
                    child: Text(S.current.free),
                  ),
                )
              else
                IgnorePointer(
                  ignoring: isPremium,
                  child: Opacity(
                    opacity: isPremium ? 0 : 1,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      width: double.infinity,
                      child: CustomButton(
                        height: 50,
                        onPressed: onPressed,
                        child: Text(S.current.upgrade),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        if (onPressed != null)
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                S.current.recommend,
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  color: AppColors.textWhite,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

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
    final Color backgroundColor =
        Theme.of(context).brightness == Brightness.light
            ? AppColors.backgroundLight
            : AppColors.backgroundDark;
    final Color textColor = Theme.of(context).brightness == Brightness.light
        ? AppColors.textBlack
        : AppColors.textWhite;
    final inactiveBorderColor = Theme.of(context).brightness == Brightness.light
        ? Colors.grey[300]!
        : Colors.grey[600]!;
    final activeBorderColor = Theme.of(context).brightness == Brightness.light
        ? AppColors.primary
        : AppColors.backgroundLight;
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
                              style: TextStyle(
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
                  child: ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(),
                    child: const Text('Free'),
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
                      child: ElevatedButton(
                        onPressed: onPressed,
                        child: const Text('Upgrade'),
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
                color: Theme.of(context).brightness == Brightness.light
                    ? AppColors.primary
                    : AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Recommend',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.white
                          : Colors.black,
                    ),
              ),
            ),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';

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
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    final backgroundColor =
        isDark ? AppColors.backgroundDarkSub : AppColors.backgroundLight;
    final textColor = isDark ? AppColors.textWhite : AppColors.textBlack;
    final primaryColor = colorScheme.primary;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isCurrentPlan
              ? primaryColor
              : isDark
                  ? Colors.grey[700]!
                  : Colors.grey[200]!,
          width: isCurrentPlan ? 2.w : 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: isCurrentPlan
                ? primaryColor.withOpacity(0.15)
                : Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 8.h),
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isCurrentPlan ? primaryColor : textColor,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  price,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontSize: 32.sp,
                    letterSpacing: -1,
                  ),
                ),
                SizedBox(height: 24.h),
                Container(
                  width: double.infinity,
                  height: 1.h,
                  color: isDark ? Colors.grey[700] : Colors.grey[100],
                ),
                SizedBox(height: 24.h),
                ...List.generate(features.length, (index) {
                  final isIncluded = available[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          isIncluded
                              ? Icons.check_circle_rounded
                              : Icons.cancel_outlined,
                          size: 20.sp,
                          color: isIncluded
                              ? Colors.green
                              : isDark
                                  ? Colors.grey[600]
                                  : Colors.grey[300],
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            features[index],
                            style: textTheme.bodyMedium?.copyWith(
                              color: isIncluded
                                  ? textColor
                                  : isDark
                                      ? Colors.grey[500]
                                      : Colors.grey[400],
                              height: 1.4,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: isCurrentPlan ? null : onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      disabledBackgroundColor:
                          isDark ? Colors.grey[800] : Colors.grey[200],
                      foregroundColor: Colors.white,
                      disabledForegroundColor:
                          isDark ? Colors.grey[500] : Colors.grey[500],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: isCurrentPlan ? 0 : 2,
                    ),
                    child: Text(
                      isCurrentPlan
                          ? "Current Plan"
                          : onPressed == null
                              ? S.current.free
                              : S.current.upgrade,
                      style: textTheme.titleSmall?.copyWith(
                        color: isCurrentPlan
                            ? (isDark ? Colors.grey[500] : Colors.grey[500])
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isCurrentPlan && onPressed != null)
            Positioned(
              top: -12.h,
              right: 0,
              left: 0,
              child: Center(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primaryColor,
                        primaryColor.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 8.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: Text(
                    S.current.recommend,
                    style: textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                      letterSpacing: 0.5,
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

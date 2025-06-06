import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final void Function()? onPressed;
  final bool isLoading;
  final double height;
  final double width;
  const CustomButton({
    super.key,
    required this.child,
    this.onPressed,
    this.isLoading = false,
    this.height = 55,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          disabledBackgroundColor: theme.disabledColor,
          foregroundColor: AppColors.textWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Center(
          child: isLoading
              ? const LoadingCircle(
                  size: 16,
                  color: AppColors.textWhite,
                )
              : child,
        ),
      ),
    );
  }
}

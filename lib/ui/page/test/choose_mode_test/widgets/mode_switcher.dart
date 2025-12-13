import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toeic_desktop/data/models/enums/mode_test.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';

class ModeSwitcher extends StatelessWidget {
  final ModeTest currentMode;
  final ValueChanged<ModeTest> onModeChanged;

  const ModeSwitcher({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return Container(
      width: double.infinity,
      height: 48.w,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.gray2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray1.withValues(alpha: 0.5)),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            alignment: currentMode == ModeTest.practice
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: ModeTest.values.map((mode) {
              final isSelected = currentMode == mode;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onModeChanged(mode),
                  child: Container(
                    color: Colors.transparent, // Hit test target
                    alignment: Alignment.center,
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: textTheme.titleSmall!.copyWith(
                        color:
                            isSelected ? AppColors.primary : AppColors.textGray,
                      ),
                      child: Text(mode.name),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

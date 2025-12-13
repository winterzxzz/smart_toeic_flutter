import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';

class CustomDropdownExample<T> extends StatefulWidget {
  const CustomDropdownExample({
    super.key,
    required this.data,
    required this.dataString,
    required this.onChanged,
  });

  final List<T> data;
  final List<String> dataString;
  final Function(T) onChanged;

  @override
  State<CustomDropdownExample<T>> createState() =>
      _CustomDropdownExampleState<T>();
}

class _CustomDropdownExampleState<T> extends State<CustomDropdownExample<T>> {
  late SingleSelectController<T> jobRoleCtrl;

  @override
  void initState() {
    super.initState();
    jobRoleCtrl = SingleSelectController(widget.data.first);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final color = colorScheme.brightness == Brightness.dark
        ? AppColors.appBarDark
        : AppColors.appBarLight;
    return CustomDropdown<T>(
      items: widget.data,
      hintText: widget.dataString.first,
      decoration: CustomDropdownDecoration(
        closedBorder: Border.all(
          color: AppColors.gray1,
        ),
        closedBorderRadius: BorderRadius.circular(12),
        expandedBorderRadius: BorderRadius.circular(12),
        closedFillColor: color,
        expandedFillColor: color,
        headerStyle: textTheme.bodyMedium,
        hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.textGray),
        listItemStyle: textTheme.bodyMedium,
        closedSuffixIcon: const FaIcon(
          FontAwesomeIcons.chevronDown,
          size: 14,
          color: AppColors.textGray,
        ),
        expandedSuffixIcon: const FaIcon(
          FontAwesomeIcons.chevronUp,
          size: 14,
          color: AppColors.textGray,
        ),
      ),
      hintBuilder: (context, hint, enabled) {
        final index = widget.data.indexOf(jobRoleCtrl.value as T);
        return Text(
          widget.dataString[index],
          style: textTheme.bodyMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      },
      onChanged: (value) {
        if (value == null) return;
        widget.onChanged(value);
      },
      controller: jobRoleCtrl,
    );
  }
}

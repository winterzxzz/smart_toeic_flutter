import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

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
    final theme = Theme.of(context);
    final color = theme.brightness == Brightness.dark
        ? AppColors.appBarDark
        : AppColors.appBarLight;
    return CustomDropdown<T>(
      items: widget.data,
      hintText: widget.dataString.first,
      decoration: CustomDropdownDecoration(
        closedBorder: Border.all(color: theme.colorScheme.primary),
        closedFillColor: color,
        expandedFillColor: color,
        headerStyle: const TextStyle(
          fontSize: 12,
          height: 0.5,
        ),
        hintStyle: const TextStyle(fontSize: 12),
        listItemStyle: const TextStyle(fontSize: 12),
        closedSuffixIcon: const FaIcon(
          FontAwesomeIcons.chevronDown,
          size: 10,
        ),
      ),
      hintBuilder: (context, hint, enabled) {
        final index = widget.data.indexOf(jobRoleCtrl.value as T);
        return Text(
          widget.dataString[index],
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

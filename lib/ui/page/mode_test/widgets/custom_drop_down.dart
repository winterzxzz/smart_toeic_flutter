import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

class CustomDropdownExample extends StatefulWidget {
  const CustomDropdownExample(
      {super.key, required this.data, required this.onChanged});
  final List<String> data;
  final Function(String) onChanged;

  @override
  State<CustomDropdownExample> createState() => _CustomDropdownExampleState();
}

class _CustomDropdownExampleState extends State<CustomDropdownExample> {
  late SingleSelectController<String?> jobRoleCtrl;

  @override
  void initState() {
    super.initState();
    jobRoleCtrl = SingleSelectController(widget.data.first);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).brightness == Brightness.dark
        ? AppColors.backgroundDark
        : AppColors.backgroundLight;
    return CustomDropdown(
      items: widget.data,
      hintText: widget.data.first,
      decoration: CustomDropdownDecoration(
        closedBorder: Border.all(color: Colors.grey.shade300),
        closedFillColor: color,
        expandedFillColor: color,
      ),
      hintBuilder: (context, hint, enabled) {
        return Text(
          hint,
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

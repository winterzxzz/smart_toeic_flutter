import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/ui_models/home_item_task_model.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/home/widgets/home_item_task.dart';

class HomeSectionTask extends StatelessWidget {
  const HomeSectionTask({
    super.key,
    required this.sectionTitle,
    required this.tasks,
  });

  final String sectionTitle;
  final List<HomeItemTaskModel> tasks;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.textBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Wrap(
          spacing: 12,
          runSpacing: 16,
          children: tasks
              .map((e) => HomeItemTask(
                    homeItemTaskModel: e,
                  ))
              .toList(),
        )
      ],
    );
  }
}

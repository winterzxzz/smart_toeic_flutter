import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/common/utils/constants.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/data/models/enums/test_show.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';
import 'package:toeic_desktop/ui/page/test/choose_mode_test/widgets/custom_drop_down.dart';
import 'package:toeic_desktop/ui/page/test/choose_mode_test/widgets/protip_widget.dart';
import 'package:toeic_desktop/ui/page/test/choose_mode_test/widgets/question_parts.dart';

class PracticeMode extends StatefulWidget {
  const PracticeMode({
    super.key,
    required this.testId,
    required this.title,
  });

  final String testId;
  final String title;

  @override
  State<PracticeMode> createState() => _PracticeModeState();
}

class _PracticeModeState extends State<PracticeMode> {
  List<PartEnum> selectedParts = [];
  String? duration;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;  
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProtipWidget(
            text: S.current.practive_part_tips,
            backgroundColor: Colors.green,
            textColor: Colors.green),
        const SizedBox(height: 16),
        Text(
          S.current.select_part_to_practice,
          style: textTheme.bodyMedium,
        ),
        ...Constants.parts.map((part) => QuestionPart(
            part: part,
            isSelected: selectedParts.contains(part.partEnum),
            onChanged: (part) {
              // exist in selectedParts
              if (selectedParts.contains(part.partEnum)) {
                selectedParts.remove(part.partEnum);
              } else {
                selectedParts.add(part.partEnum);
              }
              setState(() {});
            })),
        const SizedBox(height: 16),
        CustomDropdownExample<String>(
          data: Constants.timeLimit,
          dataString: Constants.timeLimit,
          onChanged: (value) {
            duration = value;
            setState(() {});
          },
        ),
        const SizedBox(height: 8),
        Text(
          '${S.current.limit_time} (${S.current.limit_time_hint})',
          style: textTheme.bodySmall?.copyWith(
            color: AppColors.textGray,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          child: CustomButton(
            height: 50,
            width: double.infinity,
            onPressed: selectedParts.isEmpty
                ? null
                : () {
                    final sortedParts = selectedParts.toList();
                    sortedParts.sort((a, b) => a.index - b.index);
                    GoRouter.of(context)
                        .pushReplacementNamed(AppRouter.practiceTest, extra: {
                      'title': widget.title,
                      'testShow': TestShow.test,
                      'testId': widget.testId,
                      'parts': sortedParts,
                      'duration':
                          ConstantsExtension.getTimeLimit(duration ?? ''),
                    });
                  },
            child: Text(
              S.current.practice_button,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/common/utils/constants.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/data/models/enums/test_show.dart';
import 'package:toeic_desktop/ui/page/choose_mode_test/widgets/custom_drop_down.dart';
import 'package:toeic_desktop/ui/page/choose_mode_test/widgets/protip_widget.dart';
import 'package:toeic_desktop/ui/page/choose_mode_test/widgets/question_parts.dart';

class PracticeMode extends StatefulWidget {
  const PracticeMode({
    super.key,
    required this.testId,
  });

  final String testId;

  @override
  State<PracticeMode> createState() => _PracticeModeState();
}

class _PracticeModeState extends State<PracticeMode> {
  List<PartEnum> selectedParts = [];
  String? duration;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ProtipWidget(
            text:
                'Pro tips: Hình thức luyện tập từng phần và chọn mức thời gian phù hợp sẽ giúp bạn tập trung vào giải đúng các câu hỏi thay vì phải chịu áp lực hoàn thành bài thi.',
            backgroundColor: Colors.green,
            textColor: Colors.green),
        SizedBox(height: 16),
        Text(
          'Chọn phần thi bạn muốn làm',
          style: TextStyle(fontSize: 14),
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
        SizedBox(height: 16),
        Text(
          'Giới hạn thời gian (Để trống để làm bài không giới hạn)',
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 16),
        CustomDropdownExample<String>(
          data: Constants.timeLimit,
          dataString: Constants.timeLimit,
          onChanged: (value) {
            duration = value;
            setState(() {});
          },
        ),
        SizedBox(height: 16),
        SizedBox(
          width: 150,
          child: ElevatedButton(
            onPressed: selectedParts.isEmpty
                ? null
                : () {
                    final sortedParts = selectedParts.toList();
                    sortedParts.sort((a, b) => a.index - b.index);
                    GoRouter.of(context)
                        .pushReplacementNamed(AppRouter.practiceTest, extra: {
                      'testShow': TestShow.test,
                      'testId': widget.testId,
                      'parts': sortedParts,
                      'duration':
                          ConstantsExtension.getTimeLimit(duration ?? ''),
                    });
                  },
            style: ElevatedButton.styleFrom(
              disabledForegroundColor: Colors.white.withValues(alpha: 0.5),
            ),
            child: Text(
              'Luyện tập'.toUpperCase(),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

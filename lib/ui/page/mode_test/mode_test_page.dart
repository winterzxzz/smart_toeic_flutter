import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/common/utils/constants.dart';
import 'package:toeic_desktop/data/models/entities/test/test.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/data/models/enums/test_show.dart';
import 'package:toeic_desktop/data/models/ui_models/part_model.dart';
import 'package:toeic_desktop/ui/page/mode_test/widgets/custom_drop_down.dart';

class ModeTestpage extends StatefulWidget {
  const ModeTestpage({super.key, required this.test});

  final Test test;

  @override
  State<ModeTestpage> createState() => _ModeTestpageState();
}

class _ModeTestpageState extends State<ModeTestpage> {
  bool isPracticeMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 2,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                widget.test.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 16),
              ToggleButtons(
                borderRadius: BorderRadius.circular(8),
                isSelected: [isPracticeMode, !isPracticeMode],
                onPressed: (index) {
                  setState(() {
                    isPracticeMode = index == 0;
                  });
                },
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Text('Practice'),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Text('Test'),
                  ),
                ],
              ),
              SizedBox(height: 16),
              isPracticeMode
                  ? PracticeMode(testId: widget.test.id)
                  : FullTestMode(widget: widget),
            ],
          ),
        ),
      ),
    );
  }
}

class FullTestMode extends StatelessWidget {
  const FullTestMode({
    super.key,
    required this.widget,
  });

  final ModeTestpage widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.yellowAccent.withOpacity(.2)),
            child: Text(
              'Pro tips: Hình thức luyện tập từng phần và chọn mức thời gian phù hợp sẽ giúp bạn tập trung vào giải đúng các câu hỏi thay vì phải chịu áp lực hoàn thành bài thi.',
              style: TextStyle(color: Colors.orange),
            ),
          ),
          SizedBox(height: 32),
          SizedBox(
            width: 150,
            height: 45,
            child: ElevatedButton(
              onPressed: () {
                GoRouter.of(context)
                    .pushReplacementNamed(AppRouter.practiceTest, extra: {
                  'testShow': TestShow.test,
                  'testId': widget.test.id,
                  'parts':
                      Constants.parts.map((part) => part.partEnum).toList(),
                  'duration': Duration(minutes: 120),
                });
              },
              child: Text(
                'Bắt đầu thi'.toUpperCase(),
              ),
            ),
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.green.withOpacity(.3)),
          child: Text(
            'Pro tips: Hình thức luyện tập từng phần và chọn mức thời gian phù hợp sẽ giúp bạn tập trung vào giải đúng các câu hỏi thay vì phải chịu áp lực hoàn thành bài thi.',
            style: TextStyle(color: Colors.green),
          ),
        ),
        SizedBox(height: 32),
        Text(
          'Chọn phần thi bạn muốn làm',
          style: TextStyle(fontSize: 16),
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
        SizedBox(height: 32),
        Text(
          'Giới hạn thời gian (Để trống để làm bài không giới hạn)',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 16),
        CustomDropdownExample(
          data: Constants.timeLimit,
          onChanged: (value) {
            duration = value;
            setState(() {});
          },
        ),
        SizedBox(height: 16),
        SizedBox(
          width: 150,
          height: 45,
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
            child: Text(
              'Luyện tập'.toUpperCase(),
            ),
          ),
        ),
        SizedBox(height: 32),
      ],
    );
  }
}

class QuestionPart extends StatefulWidget {
  final PartModel part;
  final Function(PartModel) onChanged;
  final bool isSelected;

  const QuestionPart({
    super.key,
    required this.part,
    required this.onChanged,
    required this.isSelected,
  });

  @override
  State<QuestionPart> createState() => _QuestionPartState();
}

class _QuestionPartState extends State<QuestionPart> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              shape: CircleBorder(),
              value: widget.isSelected,
              onChanged: (value) {
                widget.onChanged(widget.part);
              },
            ),
            Expanded(
              child: Text(
                widget.part.partEnum.name,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List<Widget>.generate(
            widget.part.tags.length,
            (index) => Chip(
              label: Text(widget.part.tags[index]),
              side: BorderSide(color: Colors.blue.withOpacity(0.1)),
              backgroundColor: Colors.blue.withOpacity(0.1),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

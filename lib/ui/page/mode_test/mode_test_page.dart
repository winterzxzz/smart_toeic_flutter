import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/common/utils/constants.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/data/models/ui_models/part_model.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

class ModeTestpage extends StatefulWidget {
  const ModeTestpage({super.key, required this.testId});

  final String testId;

  @override
  State<ModeTestpage> createState() => _ModeTestpageState();
}

class _ModeTestpageState extends State<ModeTestpage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: TabBar(
            splashBorderRadius: BorderRadius.circular(10),
            dividerHeight: 0,
            tabAlignment: TabAlignment.center,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.blue, // Replace AppColors.primary
            indicatorColor: Colors.blue, // Replace AppColors.primary
            unselectedLabelColor: Colors.grey, // Replace AppColors.textGray
            tabs: const [
              Tab(
                height: 35,
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Icon(Icons.list),
                      SizedBox(width: 4),
                      Text('Luyện tập'),
                    ],
                  ),
                ),
              ),
              Tab(
                height: 35,
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Icon(Icons.book),
                      SizedBox(width: 4),
                      Text('Làm full test'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Specify height for TabBarView
              Expanded(
                child: TabBarView(
                  children: [
                    PracticeMode(testId: widget.testId),
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                          InkWell(
                            onTap: () {
                              GoRouter.of(context).pushReplacementNamed(
                                  AppRouter.practiceTest,
                                  extra: {
                                    'testId': widget.testId,
                                    'parts': Constants.parts
                                        .map((part) => part.partEnum)
                                        .toList(),
                                    'duration': Duration(minutes: 120),
                                  });
                            },
                            child: Container(
                              width: 150,
                              height: 45,
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Bắt đầu thi'.toUpperCase(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
    return SingleChildScrollView(
      child: Column(
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
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[100],
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButton<String>(
              underline: Container(),
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down),
              borderRadius: BorderRadius.circular(10),
              items: Constants.timeLimit
                  .map((time) => DropdownMenuItem<String>(
                        value: time,
                        child: Text(time),
                      ))
                  .toList(),
              hint: Text(Constants.timeLimit.first),
              value: duration,
              onChanged: (value) {
                duration = value;
                setState(() {});
              },
            ),
          ),
          SizedBox(height: 16),
          InkWell(
            onTap: selectedParts.isEmpty
                ? null
                : () {
                    final sortedParts = selectedParts.toList();
                    sortedParts.sort((a, b) => a.index - b.index);
                    GoRouter.of(context)
                        .pushReplacementNamed(AppRouter.practiceTest, extra: {
                      'testId': widget.testId,
                      'parts': sortedParts,
                      'duration':
                          ConstantsExtension.getTimeLimit(duration ?? ''),
                    });
                  },
            child: Container(
              width: 150,
              height: 45,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: selectedParts.isEmpty
                    ? Colors.grey[500]
                    : AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                'Luyện tập'.toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 32),
        ],
      ),
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
              backgroundColor: Colors.blue[50],
              labelStyle: TextStyle(color: Colors.blue),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

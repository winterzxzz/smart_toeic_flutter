import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

final List<Map<String, dynamic>> parts = [
  {
    "title": "Part 1 (6 câu hỏi)",
    "tags": [
      "#[Part 1] Tranh tái người",
      "#[Part 1] Tranh tái vật",
    ],
  },
  {
    "title": "Part 2 (25 câu hỏi)",
    "tags": [
      "#[Part 2] Câu hỏi WHAT",
      "#[Part 2] Câu hỏi WHO",
      "#[Part 2] Câu hỏi WHERE",
      "#[Part 2] Câu hỏi WHEN",
      "#[Part 2] Câu hỏi HOW",
      "#[Part 2] Câu hỏi YES/NO",
      "#[Part 2] Câu hỏi đuôi",
      "#[Part 2] Câu hỏi lựa chọn",
      "#[Part 2] Câu yêu cầu, đề nghị",
      "#[Part 2] Câu trần thuật",
    ],
  },
  {
    "title": "Part 3 (39 câu hỏi)",
    "tags": [
      "#[Part 3] Câu hỏi về chủ đề, mục đích",
      "#[Part 3] Câu hỏi về danh tính người nói",
      "#[Part 3] Câu hỏi về chi tiết cuộc hội thoại",
      "#[Part 3] Câu hỏi kết hợp bảng biểu",
      "#[Part 3] Chủ đề: Company - General Office Work",
      "#[Part 3] Chủ đề: Company - Personnel",
      "#[Part 3] Chủ đề: Company - Event, Project",
      "#[Part 3] Chủ đề: Transportation",
      "#[Part 3] Chủ đề: Shopping, Service",
      "#[Part 3] Chủ đề: Order, delivery",
    ],
  },
  {
    "title": "Part 4 (20 câu hỏi)",
    "tags": [
      "#[Part 4] Câu hỏi về chủ đề, mục đích",
      "#[Part 4] Câu hỏi về chủ đề, mục đích",
      "#[Part 4] Câu hỏi về chủ đề, mục đích",
      "#[Part 4] Câu hỏi về chủ đề, mục đích",
      "#[Part 4] Câu hỏi về chủ đề, mục đích",
      "#[Part 4] Câu hỏi về chủ đề, mục đích",
      "#[Part 4] Câu hỏi về chủ đề, mục đích",
      "#[Part 4] Câu hỏi về chủ đề, mục đích",
      "#[Part 4] Câu hỏi về chủ đề, mục đích",
      "#[Part 4] Câu hỏi về chủ đề, mục đích",
      "#[Part 4] Câu hỏi về chủ đề, mục đích",
      "#[Part 4] Câu hỏi về chủ đề, mục đích",
      "#[Part 4] Câu hỏi về chủ đề, mục đích",
      "#[Part 4] Câu hỏi về chủ đề, mục đích",
      "#[Part 4] Câu hỏi về chủ đề, mục đích",
      "#[Part 4] Câu hỏi về chủ đề, mục đích",
      "#[Part 4] Câu hỏi về chủ đề, mục đích",
      "#[Part 4] Câu hỏi về chủ đề, mục đích",
    ],
  },
  {
    "title": "Part 5 (10 câu hỏi)",
    "tags": [
      "#[Part 5] Câu hỏi về chủ đề, mục đích",
      "#[Part 5] Câu hỏi về chủ đề, mục đích",
      "#[Part 5] Câu hỏi về chủ đề, mục đích",
      "#[Part 5] Câu hỏi về chủ đề, mục đích",
      "#[Part 5] Câu hỏi về chủ đề, mục đích",
      "#[Part 5] Câu hỏi về chủ đề, mục đích",
      "#[Part 5] Câu hỏi về chủ đề, mục đích",
      "#[Part 5] Câu hỏi về chủ đề, mục đích",
      "#[Part 5] Câu hỏi về chủ đề, mục đích",
    ],
  },
  {
    "title": "Part 6 (10 câu hỏi)",
    "tags": [
      "#[Part 6] Câu hỏi về chủ đề, mục đích",
      "#[Part 6] Câu hỏi về chủ đề, mục đích",
      "#[Part 6] Câu hỏi về chủ đề, mục đích",
      "#[Part 6] Câu hỏi về chủ đề, mục đích",
      "#[Part 6] Câu hỏi về chủ đề, mục đích",
      "#[Part 6] Câu hỏi về chủ đề, mục đích",
      "#[Part 6] Câu hỏi về chủ đề, mục đích",
      "#[Part 6] Câu hỏi về chủ đề, mục đích",
    ],
  },
  {
    "title": "Part 7 (10 câu hỏi)",
    "tags": [
      "#[Part 7] Câu hỏi về chủ đề, mục đích",
      "#[Part 7] Câu hỏi về chủ đề, mục đích",
      "#[Part 7] Câu hỏi về chủ đề, mục đích",
      "#[Part 7] Câu hỏi về chủ đề, mục đích",
      "#[Part 7] Câu hỏi về chủ đề, mục đích",
      "#[Part 7] Câu hỏi về chủ đề, mục đích",
      "#[Part 7] Câu hỏi về chủ đề, mục đích",
    ],
  },
  // Add more parts as needed
];

final List<String> timeLimit = [
  '-- Chọn thời gian --',
  '10 phút',
  '20 phút',
  '30 phút',
  '40 phút',
  '50 phút',
  '60 phút',
  'Không giới hạn',
];

class TestDetailPage extends StatelessWidget {
  const TestDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // TabBar
              TabBar(
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
              const SizedBox(height: 16),
              // Specify height for TabBarView
              Expanded(
                child: TabBarView(
                  children: [
                    PracticeMode(),
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
                            onTap: () {},
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

class PracticeMode extends StatelessWidget {
  const PracticeMode({
    super.key,
  });

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
          ...parts.map((part) => QuestionPart(part: part)),
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
              items: timeLimit
                  .map((time) => DropdownMenuItem<String>(
                        value: time,
                        child: Text(time),
                      ))
                  .toList(),
              value: timeLimit.first,
              onChanged: (value) {},
            ),
          ),
          SizedBox(height: 16),
          InkWell(
            onTap: () {
              GoRouter.of(context).pushNamed(AppRouter.practiceTest);
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
  final Map<String, dynamic> part;

  const QuestionPart({super.key, required this.part});

  @override
  State<QuestionPart> createState() => _QuestionPartState();
}

class _QuestionPartState extends State<QuestionPart> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: isChecked,
              onChanged: (value) {
                setState(() {
                  isChecked = value!;
                });
              },
            ),
            Expanded(
              child: Text(
                widget.part["title"],
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List<Widget>.generate(
            widget.part["tags"].length,
            (index) => Chip(
              label: Text(widget.part["tags"][index]),
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

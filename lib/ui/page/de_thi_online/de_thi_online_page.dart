import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/router/route_config.dart';

class SimulationTestScreen extends StatelessWidget {
  const SimulationTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(20),
            child: TabBar(
              splashBorderRadius: BorderRadius.circular(10),
              dividerHeight: 0,
              tabAlignment: TabAlignment.center,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue,
              ),
              tabs: const [
                Tab(
                  icon: Icon(Icons.list),
                  text: 'Tất cả',
                ),
                Tab(
                  icon: Icon(Icons.book),
                  text: 'Rút gọn',
                ),
              ],
            ),
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 32),
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.2),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                mainAxisExtent: 300),
            itemCount: 8, // Number of tests (replace as needed)
            itemBuilder: (context, index) {
              return SimulationTestCard(
                testNumber: index + 1,
                duration: "40 phút",
                views: (100000 * (index + 1)).toString(),
                comments: (100 * (index + 1)).toString(),
                tags: const ["#IELTS Academic", "#Listening"],
              );
            },
          ),
        ),
      ),
    );
  }
}

class SimulationTestCard extends StatelessWidget {
  final int testNumber;
  final String duration;
  final String views;
  final String comments;
  final List<String> tags;

  const SimulationTestCard({
    super.key,
    required this.testNumber,
    required this.duration,
    required this.views,
    required this.comments,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "IELTS Simulation Listening test $testNumber",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text("$duration | 📄 $views | 💬 $comments"),
            SizedBox(height: 8),
            Text(
              "4 phần thi | 40 câu hỏi",
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 4,
              children: tags
                  .map((tag) => Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        child: Chip(
                          label: Text(tag),
                          backgroundColor: Colors.blue[50],
                          labelStyle: TextStyle(color: Colors.blue),
                        ),
                      ))
                  .toList(),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.blue,
                ),
                onPressed: () {
                  GoRouter.of(context).pushNamed(AppRouter.testDetail);
                },
                child: Text("Chi tiết"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

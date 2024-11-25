import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/page/flashcard/widgets/flash_card_grid.dart';
import 'package:toeic_desktop/ui/page/flashcard/widgets/flash_card_my_list.dart';

class FlashCardPage extends StatefulWidget {
  const FlashCardPage({super.key});

  @override
  State<FlashCardPage> createState() => _FlashCardPageState();
}

class _FlashCardPageState extends State<FlashCardPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 40,
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
                      Text('My list'),
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
                      Text('Studying'),
                    ],
                  ),
                ),
              ),
              Tab(
                height: 35,
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Row(children: [Icon(Icons.explore), Text('Discover')]),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Expanded(
                child: TabBarView(
                  children: const [
                    MyListFlashCardPage(),
                    StudyingFlashCardPage(),
                    DiscoverFlashCardPage(),
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

class StudyingFlashCardPage extends StatefulWidget {
  const StudyingFlashCardPage({
    super.key,
  });

  @override
  State<StudyingFlashCardPage> createState() => _StudyingFlashCardPageState();
}

class _StudyingFlashCardPageState extends State<StudyingFlashCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.5,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          _showCreateFlashcardDialog();
                        },
                        child: Text('Tạo flashcard')),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                'Đang học',
                              ))),
                      const SizedBox(width: 16),
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () {}, child: Text('Khám phá'))),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 32),
            FlashcardGrid(),
          ],
        ),
      ),
    );
  }

  void _showCreateFlashcardDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tạo Flashcard'),
        content: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.5,
          height: MediaQuery.sizeOf(context).width * 0.5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Từ vựng',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nghĩa',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Tạo'),
          ),
        ],
      ),
    );
  }
}

class DiscoverFlashCardPage extends StatefulWidget {
  const DiscoverFlashCardPage({super.key});

  @override
  State<DiscoverFlashCardPage> createState() => _DiscoverFlashCardPageState();
}

class _DiscoverFlashCardPageState extends State<DiscoverFlashCardPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

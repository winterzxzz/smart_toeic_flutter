import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/flashcard/widgets/flash_card_discover.dart';
import 'package:toeic_desktop/ui/page/flashcard/widgets/flash_card_my_list.dart';
import 'package:toeic_desktop/ui/page/flashcard/widgets/flash_card_studying.dart';

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
          centerTitle: false,
          title: PreferredSize(
            preferredSize: Size.fromHeight(20),
            child: TabBar(
              isScrollable: true,
              splashBorderRadius: BorderRadius.circular(10),
              dividerHeight: 0,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: AppColors.primary, // Replace AppColors.primary
              indicatorColor: AppColors.primary, // Replace AppColors.primary
              unselectedLabelColor: Colors.grey,
              tabAlignment: TabAlignment.start,
              tabs: const [
                Tab(
                  height: 35,
                  child: Row(
                    children: [
                      Icon(Icons.list),
                      SizedBox(width: 4),
                      Text('My list'),
                    ],
                  ),
                ),
                Tab(
                  height: 35,
                  child: Row(
                    children: [
                      Icon(Icons.book),
                      SizedBox(width: 4),
                      Text('Studying'),
                    ],
                  ),
                ),
                Tab(
                  height: 35,
                  child: Row(
                    children: [
                      Icon(Icons.explore),
                      SizedBox(width: 4),
                      Text('Discover'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: const [
            MyListFlashCardPage(),
            StudyingFlashCardPage(),
            DiscoverFlashCardPage(),
          ],
        ),
      ),
    );
  }
}

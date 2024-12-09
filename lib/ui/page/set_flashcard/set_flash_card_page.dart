import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/ui/page/set_flashcard/set_flash_card_cubit.dart';
import 'package:toeic_desktop/ui/page/set_flashcard/widgets/set_flash_card_discover.dart';
import 'package:toeic_desktop/ui/page/set_flashcard/widgets/set_flash_card_learning.dart';
import 'package:toeic_desktop/ui/page/set_flashcard/widgets/set_flash_card_my_list.dart';

class SetFlashCardPage extends StatefulWidget {
  const SetFlashCardPage({super.key});

  @override
  State<SetFlashCardPage> createState() => _SetFlashCardPageState();
}

class _SetFlashCardPageState extends State<SetFlashCardPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<FlashCardCubit>()..fetchFlashCardSets(),
      child: const Page(),
    );
  }
}

class Page extends StatelessWidget {
  const Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      animationDuration: const Duration(milliseconds: 500),
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: PreferredSize(
            preferredSize: Size.fromHeight(20),
            child: TabBar(
              dividerHeight: 0,
              tabAlignment: TabAlignment.center,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Colors.deepOrangeAccent,
              labelColor: Colors.deepOrangeAccent, // Replace AppColors.primary
              unselectedLabelColor: Colors.grey, // Replace AppColors.textGray
              onTap: (index) {
                if (index == 1) {
                  context.read<FlashCardCubit>().fetchFlashCardSetsLearning();
                } else {
                  context.read<FlashCardCubit>().fetchFlashCardSets();
                }
              },
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
            SetFlashCardMyListPage(),
            SetFlashCardLearningPage(),
            DiscoverFlashCardPage(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/ui/common/widgets/keep_alive_page.dart';
import 'package:toeic_desktop/ui/page/set_flashcard/set_flash_card_cubit.dart';
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
      create: (context) => injector<FlashCardCubit>(),
      child: const Page(),
    );
  }
}

class Page extends StatefulWidget {
  const Page({
    super.key,
  });

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      animationDuration: const Duration(milliseconds: 200),
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Set Flash Cards'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: TabBar(
              controller: _tabController,
              dividerHeight: 0,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Theme.of(context).primaryColor,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.list),
                      SizedBox(width: 8),
                      Text('My list'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.book),
                      SizedBox(width: 8),
                      Text('Studying'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: const [
              KeepAlivePage(child: SetFlashCardMyListPage()),
              KeepAlivePage(child: SetFlashCardLearningPage()),
            ],
          ),
        ),
      ),
    );
  }
}

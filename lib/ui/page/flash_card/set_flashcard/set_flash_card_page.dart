import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/widgets/keep_alive_page.dart';
import 'package:toeic_desktop/ui/page/flash_card/set_flashcard/set_flash_card_cubit.dart';
import 'package:toeic_desktop/ui/page/flash_card/set_flashcard/widgets/set_flash_card_learning.dart';
import 'package:toeic_desktop/ui/page/flash_card/set_flashcard/widgets/set_flash_card_my_list.dart';

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
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    return DefaultTabController(
      animationDuration: const Duration(milliseconds: 200),
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            S.current.set_flashcard_title,
            style: textTheme.titleMedium,
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(56.w),
            child: Container(
              height: 40,
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: TabBar(
                controller: _tabController,
                dividerHeight: 0,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                labelColor: colorScheme.primary,
                unselectedLabelColor: Colors.grey,
                labelStyle:
                    textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                unselectedLabelStyle: textTheme.titleSmall,
                padding: const EdgeInsets.all(4),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.list,
                          size: 16.spMin,
                        ),
                        SizedBox(width: 8.w),
                        Text(S.current.my_list),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.book,
                          size: 16.spMin,
                        ),
                        SizedBox(width: 8.w),
                        Text(S.current.studying),
                      ],
                    ),
                  ),
                ],
              ),
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

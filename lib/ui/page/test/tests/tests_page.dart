import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/enums/test_type.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';
import 'package:toeic_desktop/ui/page/test/tests/choose_mode_test/widgets/custom_drop_down.dart';
import 'package:toeic_desktop/ui/page/test/tests/tests_cubit.dart';
import 'package:toeic_desktop/ui/page/test/tests/tests_state.dart';
import 'package:toeic_desktop/ui/page/test/tests/widgets/test_card.dart';

class TestsPage extends StatelessWidget {
  const TestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<TestsCubit>()..fetchTests(),
      child: const Page(),
    );
  }
}

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  late final TestsCubit _testsCubit;

  @override
  void initState() {
    super.initState();
    _testsCubit = injector<TestsCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: BlocConsumer<TestsCubit, TestsState>(
        listenWhen: (previous, current) {
          return previous.loadStatus != current.loadStatus;
        },
        listener: (context, state) {
          if (state.loadStatus == LoadStatus.failure) {
            AppNavigator(context: context).error(state.message);
          }
        },
        buildWhen: (previous, current) {
          return previous.filteredTests != current.filteredTests ||
              previous.loadStatus != current.loadStatus;
        },
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                toolbarHeight: 55,
                title: Text(
                  S.current.tests,
                  style: theme.textTheme.titleMedium,
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 150,
                    child: CustomDropdownExample<String>(
                      data: TestType.values.map((e) => e.name).toList(),
                      dataString: TestType.values.map((e) => e.name).toList(),
                      onChanged: (value) {
                        _testsCubit.filterTests(value);
                      },
                    ),
                  ),
                ],
              ),
              if (state.loadStatus == LoadStatus.loading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: LoadingCircle(),
                )
              else if (state.loadStatus == LoadStatus.success)
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  sliver: SliverList.separated(
                    itemCount: state.filteredTests.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return TestCard(
                        key: ValueKey(state.filteredTests[index].id),
                        test: state.filteredTests[index],
                      );
                    },
                  ),
                )
              else
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: SizedBox(),
                ),
            ],
          );
        },
      ),
    );
  }
}

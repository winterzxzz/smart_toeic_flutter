import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/enums/test_type.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/page/choose_mode_test/widgets/custom_drop_down.dart';
import 'package:toeic_desktop/ui/page/tests/tests_cubit.dart';
import 'package:toeic_desktop/ui/page/tests/tests_state.dart';
import 'package:toeic_desktop/ui/page/tests/widgets/test_card.dart';

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
    return Scaffold(
      body: BlocConsumer<TestsCubit, TestsState>(
        listener: (context, state) {
          if (state.loadStatus == LoadStatus.failure) {
            AppNavigator(context: context).error(state.message);
          }
        },
        builder: (context, state) {
          if (state.loadStatus == LoadStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.loadStatus == LoadStatus.success) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  title: const Text('Tests'),
                  actions: [
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      height: 40,
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
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  sliver: SliverList.separated(
                    itemCount: state.filteredTests.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      return TestCard(
                        test: state.filteredTests[index],
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/enums/test_type.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/page/tests/test_online_cubit.dart';
import 'package:toeic_desktop/ui/page/tests/test_online_state.dart';
import 'package:toeic_desktop/ui/page/mode_test/widgets/custom_drop_down.dart';
import 'package:toeic_desktop/ui/page/tests/widgets/test_card.dart';

class TestsPage extends StatelessWidget {
  const TestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<DeThiOnlineCubit>()..fetchTests(),
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
    return Scaffold(
      body: BlocConsumer<DeThiOnlineCubit, DeThiOnlineState>(
        listener: (context, state) {
          if (state.loadStatus == LoadStatus.failure) {
            AppNavigator(context: context).error(state.message);
          }
        },
        builder: (context, state) {
          if (state.loadStatus == LoadStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.loadStatus == LoadStatus.success) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      // Full width dropdown for mobile
                      SizedBox(
                        width: double.infinity,
                        child: CustomDropdownExample<String>(
                          data: TestType.values.map((e) => e.name).toList(),
                          dataString:
                              TestType.values.map((e) => e.name).toList(),
                          onChanged: (value) {
                            context.read<DeThiOnlineCubit>().filterTests(value);
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Vertical list of test cards
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.filteredTests.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return TestCard(
                            test: state.filteredTests[index],
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

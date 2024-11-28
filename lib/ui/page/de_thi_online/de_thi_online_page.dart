import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/entities/test.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/page/de_thi_online/de_thi_online_cubit.dart';
import 'package:toeic_desktop/ui/page/de_thi_online/de_thi_online_state.dart';

class SimulationTestScreen extends StatelessWidget {
  const SimulationTestScreen({super.key});

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
      appBar: AppBar(
        centerTitle: false,
        title: PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: DropdownButton<String>(
            value: "all",
            items: [
              DropdownMenuItem<String>(
                value: "all",
                child: Text("Tất cả"),
              ),
              DropdownMenuItem<String>(
                value: "short",
                child: Text("Rút gọn"),
              ),
            ],
            onChanged: (value) {},
          ),
        ),
      ),
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
            return SingleChildScrollView(
              child: Column(
                children: [
                  Wrap(
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(state.tests.length, (index) {
                      // Number of tests (replace as needed)
                      return SizedBox(
                        height: 200,
                        width: 300,
                        child: SimulationTestCard(
                          test: state.tests[index],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class SimulationTestCard extends StatelessWidget {
  const SimulationTestCard({
    super.key,
    required this.test,
  });

  final Test test;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              test.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "${test.duration} | 📄 ${test.attempts.length} attempts | ${test.type}",
            ),
            SizedBox(height: 8),
            Text(
              "${test.numberOfParts} phần thi | ${test.numberOfQuestions} câu hỏi",
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).pushNamed(AppRouter.modeTest, extra: {
                    'testId': test.id,
                  });
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

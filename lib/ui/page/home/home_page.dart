import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/page/home/home_cubit.dart';
import 'package:toeic_desktop/ui/page/home/home_state.dart';
import 'package:toeic_desktop/ui/page/home/widgets/blog_section.dart';
import 'package:toeic_desktop/ui/page/home/widgets/result_section.dart';
import 'package:toeic_desktop/ui/page/home/widgets/service_section.dart';
import 'package:toeic_desktop/ui/page/home/widgets/test_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeCubit _homeCubit;

  @override
  void initState() {
    super.initState();
    _homeCubit = injector<HomeCubit>()..init();
  }

  @override
  void dispose() {
    _homeCubit.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _homeCubit,
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
    final navigator = AppNavigator(context: context);
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state.loadStatus == LoadStatus.loading) {
              navigator.showLoadingOverlay(
                message: "Loading...",
              );
            } else {
              navigator.hideLoadingOverlay();
              if (state.loadStatus == LoadStatus.failure) {
                navigator.error(state.message);
              }
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  // Toeic exam section
                  if (state.tests.isNotEmpty) TestSection(tests: state.tests),
                  const SizedBox(height: 16),
                  // Result section
                  if (state.resultTests.isNotEmpty)
                    ResultSection(results: state.resultTests),
                  const SizedBox(height: 16),
                  ServiceSection(),
                  if (state.blogs.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    BlogSection(blogs: state.blogs),
                  ],
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

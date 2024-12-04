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
import 'package:toeic_desktop/ui/page/home/widgets/slider_section.dart';
import 'package:toeic_desktop/ui/page/home/widgets/test_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<HomeCubit>()..init(),
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
      body: SingleChildScrollView(
        child: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state.loadStatus == LoadStatus.loading) {
              AppNavigator(context: context).showLoadingOverlay(
                message: "Loading...",
              );
            } else if (state.loadStatus == LoadStatus.failure) {
              AppNavigator(context: context).error(state.message);
            }
          },
          builder: (context, state) {
            if (state.loadStatus == LoadStatus.success) {
              return Column(
                children: [
                  // Slider background images
                  SliderSection(),
                  const SizedBox(height: 32),
                  // Toeic exam section
                  TestSection(tests: state.tests),
                  const SizedBox(height: 32),
                  ResultSection(results: state.resultTests),
                  const SizedBox(height: 32),
                  ServiceSection(),
                  const SizedBox(height: 32),
                  BlogSection(),
                  const SizedBox(height: 32),
                ],
              );
            }
            return Column(
              children: [
                // Slider background images
                SliderSection(),
                const SizedBox(height: 32),
                // Toeic exam section
                const SizedBox(height: 32),
                ServiceSection(),
                const SizedBox(height: 32),
                BlogSection(),
                const SizedBox(height: 32),
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/common/utils/constants.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/app_images.dart';
import 'package:toeic_desktop/ui/page/home/widgets/home_section_task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage(AppImages.banner1), context);
    precacheImage(const AssetImage(AppImages.banner), context);
    precacheImage(const AssetImage(AppImages.banner3), context);
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.current.app_name, style: textTheme.titleMedium),
        actions: [
          IconButton(
            onPressed: () {
              GoRouter.of(context).push(AppRouter.upgradeAccount);
            },
            icon: BlocSelector<UserCubit, UserState, bool>(
              selector: (state) {
                return state.user?.isPremium() ?? false;
              },
              builder: (context, isPremium) {
                return SvgPicture.asset(
                  AppImages.icPremium,
                  width: 24.w,
                  height: 24.w,
                  colorFilter: ColorFilter.mode(
                    isPremium ? colorScheme.primary : Colors.grey,
                    BlendMode.srcIn,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              CarouselSlider(
                options: CarouselOptions(
                  height: 200.h,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                items: [
                  AppImages.banner1,
                  AppImages.banner,
                  AppImages.banner3,
                ].map((banner) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      banner,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                    ),
                  );
                }).toList(),
              ),
              8.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppImages.banner1,
                  AppImages.banner2,
                  AppImages.banner3,
                ].asMap().entries.map((entry) {
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : colorScheme.primary)
                          .withValues(
                              alpha: _currentIndex == entry.key ? 0.9 : 0.4),
                    ),
                  );
                }).toList(),
              ),
              16.verticalSpace,
              HomeSectionTask(
                sectionTitle: S.current.practice,
                tasks: Constants.homePracticeTasks,
              ),
              16.verticalSpace,
              HomeSectionTask(
                sectionTitle: S.current.exam_preparation,
                tasks: Constants.homeExamPreparationTasks,
              ),
              16.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}

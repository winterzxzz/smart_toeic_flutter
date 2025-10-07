import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/common/utils/constants.dart';
import 'package:toeic_desktop/data/services/ad_service.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'dart:developer';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/app_images.dart';
import 'package:toeic_desktop/ui/page/home/widgets/home_section_task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AdService _adService;

  @override
  void initState() {
    super.initState();
    _adService = injector<AdService>();
    // Check ad status after a delay to see if it's loaded
    Future.delayed(const Duration(seconds: 3), () {
      log('HomePage: Native ad ready: ${_adService.isNativeAdReady}');
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final size = context.sizze;
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
                  width: 24,
                  height: 24,
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
              Container(
                constraints: BoxConstraints(
                  maxHeight: size.width * 0.6,
                  maxWidth: size.width,
                ),
                child: CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration: const Duration(seconds: 1),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    viewportFraction: 1,
                  ),
                  items: [
                    Image.asset(
                      width: size.width,
                      height: size.width * 0.6,
                      AppImages.banner1,
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      width: size.width,
                      height: size.width * 0.6,
                      AppImages.banner2,
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      width: size.width,
                      height: size.width * 0.6,
                      AppImages.banner3,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              HomeSectionTask(
                sectionTitle: S.current.practice,
                tasks: Constants.homePracticeTasks,
              ),
              const SizedBox(
                height: 16,
              ),
              if (_adService.isNativeAdReady)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    height: 330,
                    child: AdWidget(ad: _adService.nativeAd!),
                  ),
                ),
              HomeSectionTask(
                sectionTitle: S.current.exam_preparation,
                tasks: Constants.homeExamPreparationTasks,
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


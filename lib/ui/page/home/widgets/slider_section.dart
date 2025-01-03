import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

class SliderSection extends StatefulWidget {
  const SliderSection({super.key});

  @override
  State<SliderSection> createState() => _SliderSectionState();
}

class _SliderSectionState extends State<SliderSection> {
  late CarouselSliderController _carouselController;
  int currentIndex = 0;
  List<String> images = [
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSCFwiOk1DeEmRzq_PDSV0TFlMynCWTm4iFcg&s",
    "https://i.ytimg.com/vi/7wqBQ4cdrhw/maxresdefault.jpg",
    "https://dbkpop.com/wp-content/uploads/2022/07/aespa_Girls_Winter_6.jpg",
  ];

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselSliderController();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.5,
      child: Stack(
        children: [
          CarouselSlider(
            carouselController: _carouselController,
            disableGesture: true,
            options: CarouselOptions(
              viewportFraction: 1,
              height: MediaQuery.sizeOf(context).height * 0.5,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
            items: images.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: CachedNetworkImage(
                      imageUrl: i,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              );
            }).toList(),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      _carouselController.previousPage();
                      setState(() {
                        if (currentIndex > 0) {
                          currentIndex--;
                        } else {
                          currentIndex = images.length - 1;
                        }
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 100),
                      const Spacer(),
                      Text(
                        "Master TOEIC Listening",
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .apply(color: AppColors.textWhite),
                      ),
                      Text(
                        "Enhance your TOEIC Listening skills with our comprehensive audio exercises and practice tests.",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .apply(color: AppColors.textWhite),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Button
                          ElevatedButton(
                            onPressed: () {
                              GoRouter.of(context).go(AppRouter.onlineTest);
                            },
                            child: const Text(
                              "Start Free Trial",
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Button
                          ElevatedButton(
                            onPressed: () {
                              GoRouter.of(context).go(AppRouter.introduction);
                            },
                            child: const Text(
                              "Learn More",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // slider indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: images.map((i) {
                          return Container(
                            width: 16,
                            height: 16,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: currentIndex == images.indexOf(i)
                                  ? AppColors.textWhite
                                  : AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                    ],
                  )),
                  InkWell(
                    onTap: () {
                      _carouselController.nextPage();
                      setState(() {
                        if (currentIndex < images.length - 1) {
                          currentIndex++;
                        } else {
                          currentIndex = 0;
                        }
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

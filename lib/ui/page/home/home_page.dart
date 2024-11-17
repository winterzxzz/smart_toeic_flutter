import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/home/widgets/blog_card.dart';
import 'package:toeic_desktop/ui/page/home/widgets/exam_card.dart';
import 'package:toeic_desktop/ui/page/home/widgets/result_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Slider background images
            _buildSliderSection(),
            const SizedBox(height: 32),
            // Toeic exam section
            // heading
            _buildExamSection(),
            const SizedBox(height: 32),
            _buildResultSection(),
            const SizedBox(height: 32),
            _buildBlogSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildBlogSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
      child: Column(
        children: [
          Text(
            "Blog Knowledge",
            style: Theme.of(context).textTheme.headlineMedium!.apply(
                  color: AppColors.textBlack,
                  fontWeightDelta: 2,
                ),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: BlogCard(
                  imageUrl:
                      'https://i.pinimg.com/736x/72/d5/67/72d56749e83ccd1199706bd20032c2c0.jpg',
                  title: 'TOEIC Listening and Reading',
                  author: 'John Doe',
                  content:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                ),
              ),
              Expanded(
                child: BlogCard(
                  imageUrl:
                      'https://i.pinimg.com/736x/af/2b/07/af2b07652c61cc94a1753ce8b9e8ac1d.jpg',
                  title: 'TOEIC Speaking',
                  author: 'John Doe',
                  content:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                ),
              ),
              Expanded(
                child: BlogCard(
                  imageUrl:
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcROSZmC9xziv7Jzsk0FHro4jDX832AcovE1SfVAZ3WzTZuncC5CD6QpcICHC1MSiIUpFRs&usqp=CAU',
                  title: 'TOEIC Writing',
                  author: 'John Doe',
                  content:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildResultSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
      child: Column(
        children: [
          Text(
            "Your Exam Results",
            style: Theme.of(context).textTheme.headlineMedium!.apply(
                  color: AppColors.textBlack,
                  fontWeightDelta: 2,
                ),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ExamResultCard(
                  title: 'TOEIC Listening and Reading',
                  date: '2024-03-15',
                  time: '2 hours',
                  correct: 180,
                  attempted: 195,
                  total: 200,
                ),
              ),
              Expanded(
                child: ExamResultCard(
                  title: 'TOEIC Speaking',
                  date: '2024-03-20',
                  time: '20 minutes',
                  correct: 160,
                  attempted: 170,
                  total: 200,
                ),
              ),
              Expanded(
                child: ExamResultCard(
                  title: 'TOEIC Writing',
                  date: '2024-03-25',
                  time: '60 minutes',
                  correct: 140,
                  attempted: 150,
                  total: 200,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildExamSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(
            "TOEIC Exam",
            style: Theme.of(context).textTheme.headlineMedium!.apply(
                  color: AppColors.textBlack,
                  fontWeightDelta: 2,
                ),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ExamCard(
                  title: 'TOEIC Listening',
                  description: 'Test your English listening skills',
                  time: '45 min',
                  questions: '100 questions',
                  comments: '24 comments',
                  parts: '4 parts',
                ),
              ),
              Expanded(
                child: ExamCard(
                  title: 'TOEIC Reading',
                  description: 'Assess your English reading comprehension',
                  time: '75 min',
                  questions: '100 questions',
                  comments: '32 comments',
                  parts: '3 parts',
                ),
              ),
              Expanded(
                child: ExamCard(
                  title: 'TOEIC Speaking',
                  description: 'Evaluate your English speaking abilities',
                  time: '20 min',
                  questions: '11 questions',
                  comments: '18 comments',
                  parts: '6 parts',
                ),
              ),
              Expanded(
                child: ExamCard(
                  title: 'TOEIC Writing',
                  description: 'Measure your English writing skills',
                  time: '60 min',
                  questions: '8 questions',
                  comments: '22 comments',
                  parts: '2 parts',
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSliderSection() {
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
                            .bodySmall!
                            .apply(color: AppColors.textWhite),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Button
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text(
                              "Start Free Trial",
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Button
                          ElevatedButton(
                            onPressed: () {},
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

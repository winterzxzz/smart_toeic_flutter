import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/ui/common/app_audios.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/practice_test/widgets/question.dart';
import 'package:toeic_desktop/ui/page/practice_test/widgets/question_index.dart';

class PracticeTestPage extends StatefulWidget {
  const PracticeTestPage({super.key});

  @override
  State<PracticeTestPage> createState() => _PracticeTestPageState();
}

class _PracticeTestPageState extends State<PracticeTestPage> {
  List<String> parts = [
    'Part 1',
    'Part 2',
    'Part 3',
    'Part 4',
    'Part 5',
    'Part 6',
    'Part 7'
  ];

  String selectedPart = 'Part 1';

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool result) {
        // show popup to confirm exit
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Bạn có chắc chắn muốn thoát?'),
            actions: [
              TextButton(
                onPressed: () {
                  // Perform the desired action here
                  result = true;
                  // Add any additional logic for "Thoát" action
                },
                child: Text('Thoát'),
              ),
              TextButton(
                onPressed: () {
                  result = false;
                  // Add any additional logic for "Tiếp tục" action if needed
                },
                child: Text('Tiếp tục'),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 16,
                  ),
                  Text('New Economy TOEIC Test 1 ',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Bạn có chắc chắn muốn thoát?'),
                          actions: [
                            TextButton(onPressed: () {}, child: Text('Thoát')),
                            TextButton(
                                onPressed: () {}, child: Text('Tiếp tục')),
                          ],
                        ),
                      );
                    },
                    child: Text(
                      'Thoát',
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        // Select part
                        Row(
                          children: parts
                              .map((part) => InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedPart = part;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      margin: EdgeInsets.only(right: 16),
                                      decoration: BoxDecoration(
                                        color: part == selectedPart
                                            ? AppColors.primary
                                            : Colors.white,
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(part,
                                          style: TextStyle(
                                              color: part == selectedPart
                                                  ? Colors.white
                                                  : Colors.black)),
                                    ),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        SelectionArea(
                          child: Builder(builder: (context) {
                            switch (selectedPart) {
                              case 'Part 1':
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    6,
                                    (index) => QuestionWidget(
                                      startNumber: 1,
                                      urlAudio: AppAudios.part1,
                                      indexQuestion: index,
                                    ),
                                  ),
                                );
                              case 'Part 2':
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    25,
                                    (index) => QuestionWidget(
                                      startNumber: 7,
                                      urlAudio: AppAudios.part1,
                                      indexQuestion: index,
                                    ),
                                  ),
                                );
                              case 'Part 3':
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    39,
                                    (index) => QuestionWidget(
                                      startNumber: 32,
                                      urlAudio: AppAudios.part1,
                                      indexQuestion: index,
                                      questionContent:
                                          'What most likely will the man do first tomorrow?',
                                      options: [
                                        'Order a replacement part.',
                                        'Consult an instruction manual.',
                                        'Contact the manufacturer.',
                                        'Contact the store where the part was purchased.',
                                      ],
                                    ),
                                  ),
                                );
                              case 'Part 4':
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    30,
                                    (index) => QuestionWidget(
                                      startNumber: 71,
                                      urlAudio: AppAudios.part1,
                                      indexQuestion: index,
                                      questionContent:
                                          'What most likely will the man do first tomorrow?',
                                      options: [
                                        'Order a replacement part.',
                                        'Consult an instruction manual.',
                                        'Contact the manufacturer.',
                                        'Contact the store where the part was purchased.',
                                      ],
                                    ),
                                  ),
                                );
                              case 'Part 5':
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    30,
                                    (index) => QuestionWidget(
                                      startNumber: 71,
                                      urlAudio: AppAudios.part1,
                                      indexQuestion: index,
                                      questionContent:
                                          'When filling out the order form, please _____ your address clearly to prevent delays.',
                                      options: [
                                        'fix',
                                        'write',
                                        'send',
                                        'direct',
                                      ],
                                    ),
                                  ),
                                );
                              case 'Part 6':
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    30,
                                    (index) => Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          'Business Contract Dear Mr. Smith, I am Sharron Biggs, CEO and founder of BiggsGraphics. I recently came across your advertisement _____(131) the partnership of a graphic design company for a number of your projects. BiggsGraphics has _____(132) experience working with various small businesses and companies in designing advertising campaigns, logos, and websites. _____(133). Our website www.biggs-graphics.com also has some information about our company. I\'m interested in working with your company on your projects and hope we can build a beneficial partnership. I look forward _____(134) your reply. Sincerely, Sharron Biggs CEO, BiggsGraphics',
                                          style: TextStyle(color: Colors.black),
                                        )),
                                        const SizedBox(
                                          width: 32,
                                        ),
                                        SizedBox(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.3,
                                          child: QuestionWidget(
                                            startNumber: 71,
                                            indexQuestion: index,
                                            questionContent:
                                                'When filling out the order form, please _____ your address clearly to prevent delays.',
                                            options: [
                                              'fix',
                                              'write',
                                              'send',
                                              'direct',
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              case 'Part 7':
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    54,
                                    (index) => Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          'Business Contract Dear Mr. Smith, I am Sharron Biggs, CEO and founder of BiggsGraphics. I recently came across your advertisement _____(131) the partnership of a graphic design company for a number of your projects. BiggsGraphics has _____(132) experience working with various small businesses and companies in designing advertising campaigns, logos, and websites. _____(133). Our website www.biggs-graphics.com also has some information about our company. I\'m interested in working with your company on your projects and hope we can build a beneficial partnership. I look forward _____(134) your reply. Sincerely, Sharron Biggs CEO, BiggsGraphics',
                                          style: TextStyle(color: Colors.black),
                                        )),
                                        const SizedBox(
                                          width: 32,
                                        ),
                                        SizedBox(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.3,
                                          child: QuestionWidget(
                                            startNumber: 147,
                                            indexQuestion: index,
                                            questionContent:
                                                'When filling out the order form, please _____ your address clearly to prevent delays.',
                                            options: [
                                              'fix',
                                              'write',
                                              'send',
                                              'direct',
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              default:
                                return Container();
                            }
                          }),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(
                    width: 16,
                  ),
                  QuestionIndex(),
                  const SizedBox(
                    width: 16,
                  ),
                ],
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

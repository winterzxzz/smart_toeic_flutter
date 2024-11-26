// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/flashcard/widgets/flash_card_grid.dart';

class MyListFlashCardPage extends StatefulWidget {
  const MyListFlashCardPage({super.key});

  @override
  State<MyListFlashCardPage> createState() => _MyListFlashCardPageState();
}

class _MyListFlashCardPageState extends State<MyListFlashCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Row(
                children: [
                  FlashCardMyListItem(),
                  const SizedBox(width: 16),
                  FlashCardMyListItem(),
                  const SizedBox(width: 16),
                  FlashCardMyListItem(),
                ],
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () {},
                child: Container(
                  width: 150,
                  height: 45,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      Text(
                        'Create Flashcard',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Flashcard Categories ',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              FlashcardGrid(),
            ],
          ),
        ),
      ),
    );
  }
}

class FlashCardMyListItem extends StatelessWidget {
  const FlashCardMyListItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Card(
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gray2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Word learned'),
                  Icon(Icons.check_circle_outline_outlined,
                      color: Colors.green),
                ],
              ),
              Text(
                '1,234',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                'You\'ve learned 1,234 words so far',
                style: TextStyle(color: AppColors.textGray),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

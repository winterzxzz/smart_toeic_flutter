import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/entities/flash_card.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/flash_card_quizz_cubit.dart';

class FlashCardQuizPage extends StatelessWidget {
  const FlashCardQuizPage(
      {super.key, required this.title, required this.flashCards});

  final String title;
  final List<FlashCard> flashCards;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          injector<FlashCardQuizzCubit>()..fetchFlashCardQuizzs(flashCards),
      child: Page(title: title),
    );
  }
}

class Page extends StatelessWidget {
  const Page({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    log('build');
    return Scaffold(
      appBar: AppBar(
        title: Text('Flash Card Quiz: $title'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.sizeOf(context).width * 0.6,
          height: MediaQuery.sizeOf(context).height * 0.7,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('Kết thúc'),
                    ),
                  ),
                ],
              ),
              Text(
                'winter',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Bạn đã thuộc từ này ở mức nào?',
                style: TextStyle(fontSize: 18),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildRadioOption('Khó nhớ'),
                    _buildRadioOption('Tương đối khó'),
                    _buildRadioOption('Dễ nhớ'),
                    _buildRadioOption('Rất dễ nhớ'),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: null,
                      child: Text('Trước'),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('Tiếp theo'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioOption(String text) {
    return InkWell(
      highlightColor: Colors.red,
      hoverColor: Colors.red,
      splashColor: Colors.red,
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.gray1, width: 1),
        ),
        child: Row(
          children: [
            Radio(
              value: text,
              groupValue: 'winter',
              onChanged: (value) {},
            ),
            Text(
              text,
            )
          ],
        ),
      ),
    );
  }
}

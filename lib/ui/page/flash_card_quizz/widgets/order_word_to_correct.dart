import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_learning.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

class OrderWordToCorrect extends StatefulWidget {
  const OrderWordToCorrect({super.key, required this.fcLearning});

  final FlashCardLearning fcLearning;

  @override
  State<OrderWordToCorrect> createState() => _OrderWordToCorrectState();
}

class _OrderWordToCorrectState extends State<OrderWordToCorrect> {
  List<String> shuffledWords = [];
  List<String> selectedWords = [];
  bool isCorrect = false;
  bool isShowAnswer = false;

  @override
  void initState() {
    super.initState();
    shuffledWords = [
      ...widget.fcLearning.flashcardId!.exampleSentence.first.split(' ')
    ];
    shuffledWords.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      key: widget.key,
      children: [
        Text('Sắp xếp các từ để tạo thành câu đúng',
            style: TextStyle(fontSize: 18)),
        SizedBox(height: 32),
        Row(
          children: [
            ...shuffledWords.map((word) {
              return Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedWords.add(word);
                        shuffledWords.remove(word);
                      });
                    },
                    child: Container(
                      height: 35,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.gray2,
                        border: Border.all(color: AppColors.gray1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        word,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                ],
              );
            }),
          ],
        ),
        SizedBox(height: 16),
        Container(
          height: 100,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.gray2,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 8),
            scrollDirection: Axis.horizontal,
            itemCount: selectedWords.length,
            separatorBuilder: (_, __) => SizedBox(width: 4),
            itemBuilder: (context, index) {
              return Center(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      shuffledWords.add(selectedWords[index]);
                      selectedWords.removeAt(index);
                    });
                  },
                  child: Container(
                    height: 35,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.gray2,
                      border: Border.all(color: AppColors.gray1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      selectedWords[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Kiểm tra'),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isShowAnswer = true;
                    });
                  },
                  child: Text('Xem đáp án'),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 32),
        if (isCorrect)
          Text(
            'Bạn đã trả lời đúng!',
            style: TextStyle(fontSize: 18),
          ),
        if (isShowAnswer)
          Text(
            'Đáp án: ${widget.fcLearning.flashcardId!.exampleSentence.first}',
            style: TextStyle(fontSize: 18, color: AppColors.error),
          ),
      ],
    );
  }
}

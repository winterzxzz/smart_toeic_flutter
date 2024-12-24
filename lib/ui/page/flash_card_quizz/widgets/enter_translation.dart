import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_learning.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

class EnterTranslation extends StatefulWidget {
  const EnterTranslation({super.key, required this.fcLearning});

  final FlashCardLearning fcLearning;

  @override
  State<EnterTranslation> createState() => _EnterTranslationState();
}

class _EnterTranslationState extends State<EnterTranslation> {
  late final TextEditingController _controller;
  bool isCorrect = false;
  bool isShowAnswer = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      key: widget.key,
      children: [
        Text.rich(
          style: TextStyle(fontSize: 18),
          TextSpan(
            children: [
              TextSpan(text: 'Nhập từ tiếng Việt có nghĩa là '),
              TextSpan(
                text: "'${widget.fcLearning.flashcardId!.translation}'",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.error),
              ),
              TextSpan(text: ' ?'),
            ],
          ),
        ),
        SizedBox(height: 32),
        TextField(
          controller: _controller,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: 'Nhập từ tiếng Việt',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.purple),
            ),
          ),
        ),
        SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isCorrect = _controller.text ==
                          widget.fcLearning.flashcardId!.translation;
                    });
                  },
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
        const SizedBox(height: 32),
        if (isCorrect)
          Text(
            'Bạn đã trả lời đúng!',
            style: TextStyle(fontSize: 18),
          ),
        if (isShowAnswer)
          Text(
            'Đáp án: ${widget.fcLearning.flashcardId!.word}',
            style: TextStyle(fontSize: 18, color: AppColors.error),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_learning.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/flash_card_quizz_cubit.dart';

class EnterWord extends StatefulWidget {
  const EnterWord({super.key, required this.fcLearning});

  final FlashCardLearning fcLearning;

  @override
  State<EnterWord> createState() => _EnterWordState();
}

class _EnterWordState extends State<EnterWord> {
  late final TextEditingController _controller;
  bool isCheck = false;

  @override
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
                text: "'${widget.fcLearning.flashcardId!.word}'",
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
          autofocus: true,
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
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                isCheck = true;
              });
              context.read<FlashCardQuizzCubit>().answer(
                  widget.fcLearning.flashcardId!.word,
                  _controller.text.toLowerCase() ==
                      widget.fcLearning.flashcardId!.translation.toLowerCase());
            },
            child: Text('Kiểm tra'),
          ),
        ),
        const SizedBox(height: 32),
        if (isCheck)
          Builder(builder: (context) {
            return Column(
              children: [
                SizedBox(height: 8),
                Text(
                  'Đáp án: ${widget.fcLearning.flashcardId!.translation}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            );
          }),
      ],
    );
  }
}

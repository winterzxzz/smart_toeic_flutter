import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_learning.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/flash_card_quizz_cubit.dart';

class EnterTranslation extends StatefulWidget {
  const EnterTranslation({super.key, required this.fcLearning});

  final FlashCardLearning fcLearning;

  @override
  State<EnterTranslation> createState() => _EnterTranslationState();
}

class _EnterTranslationState extends State<EnterTranslation> {
  late final TextEditingController _controller;
  bool isCheck = false;

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
          style: const TextStyle(fontSize: 18),
          TextSpan(
            children: [
              const TextSpan(text: 'Nhập từ tiếng anh có nghĩa là '),
              TextSpan(
                text: "'${widget.fcLearning.flashcardId!.translation}'",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.error),
              ),
              const TextSpan(text: ' ?'),
            ],
          ),
        ),
        const SizedBox(height: 32),
        TextField(
          controller: _controller,
          textAlign: TextAlign.center,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Nhập từ tiếng anh',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.purple),
            ),
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                isCheck = true;
              });
              FocusScope.of(context).unfocus();
              Future.delayed(const Duration(milliseconds: 100), () {
                if (context.mounted) {
                  context.read<FlashCardQuizzCubit>().answer(
                      widget.fcLearning.flashcardId!.word,
                      _controller.text.toLowerCase() ==
                          widget.fcLearning.flashcardId!.word.toLowerCase());
                }
              });
              // hide keyboard
            },
            child: const Text('Kiểm tra'),
          ),
        ),
        const SizedBox(height: 32),
        if (isCheck)
          Builder(builder: (context) {
            final isCorrect = _controller.text.toLowerCase() ==
                widget.fcLearning.flashcardId!.word.toLowerCase();
            return Column(
              children: [
                if (!isCorrect) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Đáp án: ${widget.fcLearning.flashcardId!.word}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ],
            );
          }),
      ],
    );
  }
}

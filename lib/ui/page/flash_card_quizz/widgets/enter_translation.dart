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

class _EnterTranslationState extends State<EnterTranslation>
    with TickerProviderStateMixin {
  late final TextEditingController _controller;
  bool isCheck = false;

  late AnimationController _timerController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _timerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timerController.dispose();
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
              TextSpan(text: 'Nhập từ tiếng anh có nghĩa là '),
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
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Nhập từ tiếng anh',
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
              _timerController.forward();
              Future.delayed(const Duration(seconds: 3), () {
                context.read<FlashCardQuizzCubit>().next();
              });
            },
            child: Text('Kiểm tra'),
          ),
        ),
        const SizedBox(height: 32),
        if (isCheck)
          Builder(builder: (context) {
            final isCorrect = _controller.text.toLowerCase() ==
                widget.fcLearning.flashcardId!.word.toLowerCase();
            return Column(
              children: [
                Text(
                  isCorrect ? 'Bạn đã trả lời đúng!' : 'Bạn đã trả lời sai!',
                  style: TextStyle(
                    fontSize: 18,
                    color: isCorrect ? AppColors.success : AppColors.error,
                  ),
                ),
                if (!isCorrect) ...[
                  SizedBox(height: 8),
                  Text(
                    'Đáp án: ${widget.fcLearning.flashcardId!.word}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
                SizedBox(height: 16),
                AnimatedBuilder(
                  animation: _timerController,
                  builder: (context, child) {
                    return _timerController.value > 0
                        ? SizedBox(
                            width: 100,
                            child: LinearProgressIndicator(
                              value: 1 - _timerController.value,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary),
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
              ],
            );
          }),
      ],
    );
  }
}

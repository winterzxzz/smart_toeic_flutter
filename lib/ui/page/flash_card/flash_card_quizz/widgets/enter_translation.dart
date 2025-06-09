import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_learning.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/capitalize_first_letter_input.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_quizz/flash_card_quizz_cubit.dart';

class EnterTranslation extends StatefulWidget {
  const EnterTranslation({super.key, required this.fcLearning});

  final FlashCardLearning fcLearning;

  @override
  State<EnterTranslation> createState() => _EnterTranslationState();
}

class _EnterTranslationState extends State<EnterTranslation> {
  late final TextEditingController _controller;
  bool isCheck = false;
  late final FlashCardQuizzCubit _cubit;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _cubit = context.read<FlashCardQuizzCubit>();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      key: widget.key,
      children: [
        Text.rich(
          style: const TextStyle(fontSize: 18),
          TextSpan(
            children: [
              TextSpan(
                text: S.current.enter_english_word,
                style: theme.textTheme.bodyLarge,
              ),
              TextSpan(
                text: " '${widget.fcLearning.flashcardId!.translation}'",
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.error,
                ),
              ),
              const TextSpan(text: ' ?'),
            ],
          ),
        ),
        const SizedBox(height: 32),
        TextField(
          controller: _controller,
          textAlign: TextAlign.center,
          inputFormatters: [CapitalizeFirstLetterFormatter()],
          autofocus: true,
          decoration: InputDecoration(
            hintText: S.current.enter_english_word,
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
          height: 50,
          child: CustomButton(
            onPressed: () {
              setState(() {
                isCheck = true;
              });
              FocusScope.of(context).unfocus();
              Future.delayed(const Duration(milliseconds: 200), () {
                if (context.mounted) {
                  _cubit.answer(
                      widget.fcLearning.flashcardId!.word,
                      _controller.text.toLowerCase() ==
                          widget.fcLearning.flashcardId!.word.toLowerCase());
                }
              });
              // hide keyboard
            },
            child: Text(S.current.check),
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
                    '${S.current.answer}: ${widget.fcLearning.flashcardId!.word}',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ],
            );
          }),
      ],
    );
  }
}

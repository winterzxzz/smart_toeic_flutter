import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/request/flash_card_request.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/flash_card_detail/flash_card_detail_cubit.dart';
import 'package:toeic_desktop/ui/page/flash_card_detail/flash_card_detail_state.dart';

void showCreateFlashCardDialog(BuildContext widgetContext,
    {FlashCard? flashCard, required Function(FlashCardRequest) onSave}) {
  // Create controllers for the text fields
  final TextEditingController titleController =
      TextEditingController(text: flashCard?.word);
  final TextEditingController descriptionController =
      TextEditingController(text: flashCard?.translation);
  final TextEditingController definitionController =
      TextEditingController(text: flashCard?.definition);
  final TextEditingController example1SentenceController =
      TextEditingController(text: flashCard?.exampleSentence[0]);
  final TextEditingController example2SentenceController =
      TextEditingController(text: flashCard?.exampleSentence[1]);
  final TextEditingController noteController =
      TextEditingController(text: flashCard?.note);
  final TextEditingController partOfSpeechController =
      TextEditingController(text: flashCard?.partOfSpeech.join(', '));
  final TextEditingController pronunciationController =
      TextEditingController(text: flashCard?.pronunciation);

  showDialog(
    context: widgetContext,
    builder: (context) {
      return AlertDialog(
        scrollable: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Thêm từ mới',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                IconButton(
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                  icon: Icon(
                    Icons.close,
                    color: AppColors.gray3,
                  ),
                ),
              ],
            ),
            Text(
              'Thêm từ mới vào danh sách từ',
              style: TextStyle(fontSize: 12, color: AppColors.textGray),
            ),
          ],
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormItem(
                  title: 'Từ', controller: titleController, isRequired: true),
              FormItem(title: 'Nghĩa', controller: descriptionController),
              FormItem(title: 'Định nghĩa', controller: definitionController),
              FormItem(
                  title: 'Ví dụ 1', controller: example1SentenceController),
              FormItem(
                  title: 'Ví dụ 2', controller: example2SentenceController),
              FormItem(title: 'Ghi chú', controller: noteController),
              FormItem(title: 'Phát âm', controller: partOfSpeechController),
              FormItem(title: 'Phần từ', controller: pronunciationController),
            ],
          ),
        ),
        actions: [
          BlocConsumer<FlashCardDetailCubit, FlashCardDetailState>(
            listener: (context, state) {
              if (state.loadStatusAiGen == LoadStatus.success) {
                final flashCardAiGen = state.flashCardAiGen;
                if (flashCardAiGen != null) {
                  titleController.text = flashCardAiGen.word;
                  descriptionController.text = flashCardAiGen.translation;
                  definitionController.text = flashCardAiGen.definition;
                  example1SentenceController.text = flashCardAiGen.example1;
                  example2SentenceController.text = flashCardAiGen.example2;
                  noteController.text = flashCardAiGen.note;
                  partOfSpeechController.text =
                      flashCardAiGen.partOfSpeech.join(', ');
                  pronunciationController.text = flashCardAiGen.pronunciation;
                }
              }
            },
            bloc: BlocProvider.of<FlashCardDetailCubit>(widgetContext),
            buildWhen: (previous, current) =>
                previous.loadStatusAiGen != current.loadStatusAiGen,
            builder: (context, state) {
              final isLoading = state.loadStatusAiGen == LoadStatus.loading;
              return SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          widgetContext
                              .read<FlashCardDetailCubit>()
                              .getFlashCardInforByAI(titleController.text);
                        },
                  child: isLoading
                      ? Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.textWhite,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text('AI đang điền'),
                          ],
                        )
                      : const Text('Điền bằng AI'),
                ),
              );
            },
          ),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                final flashCardRequest = FlashCardRequest(
                  word: titleController.text,
                  translation: descriptionController.text,
                  definition: definitionController.text,
                  exampleSentence: [
                    example1SentenceController.text,
                    example2SentenceController.text,
                  ],
                  note: noteController.text,
                  partOfSpeech: partOfSpeechController.text.split(', '),
                  pronunciation: pronunciationController.text,
                  setFlashcardId: flashCard?.setFlashcardId ?? '',
                );
                onSave(flashCardRequest);
                GoRouter.of(context).pop();
              },
              child: const Text('Lưu'),
            ),
          ),
        ],
      );
    },
  );
}

class FormItem extends StatelessWidget {
  const FormItem({
    super.key,
    required this.title,
    required this.controller,
    this.isRequired = false,
  });
  final String title;
  final TextEditingController controller;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.end,
                ),
                // required
                if (isRequired) Text('*', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: controller, // Attach controller
              autofocus: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.gray1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.gray3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

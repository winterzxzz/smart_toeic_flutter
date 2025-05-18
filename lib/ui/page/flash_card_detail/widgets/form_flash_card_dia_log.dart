import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card.dart';
import 'package:toeic_desktop/data/models/entities/profile/user_entity.dart';
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

  showModalBottomSheet(
    context: widgetContext,
    isScrollControlled: true,
    showDragHandle: false,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 1,
      minChildSize: 1,
      maxChildSize: 1,
      builder: (context, scrollController) {
        final theme = Theme.of(context);
        return Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 44,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add new word',
                            style: theme.textTheme.titleLarge,
                          ),
                          Text(
                            'Add new word to the list',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      FormItem(
                        title: 'Word',
                        controller: titleController,
                        isRequired: true,
                      ),
                      FormItem(
                        title: 'Meaning',
                        controller: descriptionController,
                      ),
                      FormItem(
                        title: 'Definition',
                        controller: definitionController,
                      ),
                      FormItem(
                        title: 'Example 1',
                        controller: example1SentenceController,
                      ),
                      FormItem(
                        title: 'Example 2',
                        controller: example2SentenceController,
                      ),
                      FormItem(
                        title: 'Note',
                        controller: noteController,
                      ),
                      FormItem(
                        title: 'Pronunciation',
                        controller: partOfSpeechController,
                      ),
                      FormItem(
                        title: 'Part of speech',
                        controller: pronunciationController,
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom actions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: BlocConsumer<FlashCardDetailCubit,
                          FlashCardDetailState>(
                        listener: (context, state) {
                          if (state.loadStatusAiGen == LoadStatus.success) {
                            final flashCardAiGen = state.flashCardAiGen;
                            if (flashCardAiGen != null) {
                              titleController.text = flashCardAiGen.word;
                              descriptionController.text =
                                  flashCardAiGen.translation;
                              definitionController.text =
                                  flashCardAiGen.definition;
                              example1SentenceController.text =
                                  flashCardAiGen.example1;
                              example2SentenceController.text =
                                  flashCardAiGen.example2;
                              noteController.text = flashCardAiGen.note;
                              partOfSpeechController.text =
                                  flashCardAiGen.partOfSpeech.join(', ');
                              pronunciationController.text =
                                  flashCardAiGen.pronunciation;
                            }
                          }
                        },
                        bloc: BlocProvider.of<FlashCardDetailCubit>(
                            widgetContext),
                        buildWhen: (previous, current) =>
                            previous.loadStatusAiGen != current.loadStatusAiGen,
                        builder: (context, state) {
                          final isLoading =
                              state.loadStatusAiGen == LoadStatus.loading;
                          return BlocSelector<UserCubit, UserState,
                              UserEntity?>(
                            selector: (state) => state.user,
                            builder: (context, user) {
                              final isPremium = user?.isPremium();
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  disabledBackgroundColor:
                                      AppColors.gray1.withValues(alpha: 0.5),
                                ),
                                onPressed: isPremium == true
                                    ? isLoading
                                        ? null
                                        : () async {
                                            widgetContext
                                                .read<FlashCardDetailCubit>()
                                                .getFlashCardInforByAI(
                                                    titleController.text);
                                          }
                                    : null,
                                child: isLoading
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Theme.of(context)
                                                          .brightness !=
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          const Text('AI is filling...'),
                                        ],
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (isPremium == false) ...[
                                            const FaIcon(FontAwesomeIcons.lock),
                                            const SizedBox(width: 8),
                                          ] else ...[
                                            const FaIcon(
                                                FontAwesomeIcons.robot),
                                            const SizedBox(width: 8),
                                          ],
                                          const Text('Fill by AI'),
                                        ],
                                      ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
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
                            partOfSpeech:
                                partOfSpeechController.text.split(', '),
                            pronunciation: pronunciationController.text,
                            setFlashcardId: flashCard?.setFlashcardId ?? '',
                          );
                          onSave(flashCardRequest);
                          Navigator.pop(context);
                        },
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
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
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
                // required
                if (isRequired)
                  const Text('*', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller, // Attach controller
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.gray1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.gray3),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

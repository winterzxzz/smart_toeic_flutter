import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card.dart';
import 'package:toeic_desktop/data/models/entities/profile/user_entity.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/request/flash_card_request.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_detail/flash_card_detail_cubit.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_detail/flash_card_detail_state.dart';

enum FlashCardDetailFormType {
  create,
  edit,
}

class FlashCardDetailFormArgs {
  final FlashCardDetailFormType type;
  final FlashCard? flashCard;
  final Function(FlashCardRequest) onSave;

  const FlashCardDetailFormArgs({
    required this.type,
    this.flashCard,
    required this.onSave,
  });
}

class FlashCardDetailForm extends StatefulWidget {
  const FlashCardDetailForm({
    super.key,
    required this.args,
  });

  final FlashCardDetailFormArgs args;

  @override
  State<FlashCardDetailForm> createState() => _FlashCardDetailFormState();
}

class _FlashCardDetailFormState extends State<FlashCardDetailForm> {
  late final TextEditingController wordController;
  late final TextEditingController meaningController;
  late final TextEditingController definitionController;
  late final TextEditingController example1SentenceController;
  late final TextEditingController example2SentenceController;
  late final TextEditingController noteController;
  late final TextEditingController pronunciationController;
  late final TextEditingController partOfSpeechController;
  late final FlashCardDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    wordController = TextEditingController(text: widget.args.flashCard?.word);
    meaningController =
        TextEditingController(text: widget.args.flashCard?.translation);
    definitionController =
        TextEditingController(text: widget.args.flashCard?.definition);
    example1SentenceController =
        TextEditingController(text: widget.args.flashCard?.exampleSentence[0]);
    example2SentenceController =
        TextEditingController(text: widget.args.flashCard?.exampleSentence[1]);
    noteController = TextEditingController(text: widget.args.flashCard?.note);
    pronunciationController =
        TextEditingController(text: widget.args.flashCard?.pronunciation);
    partOfSpeechController = TextEditingController(
        text: widget.args.flashCard?.partOfSpeech.join(', '));
    _cubit = context.read<FlashCardDetailCubit>();
  }

  @override
  void dispose() {
    wordController.dispose();
    meaningController.dispose();
    definitionController.dispose();
    example1SentenceController.dispose();
    example2SentenceController.dispose();
    noteController.dispose();
    pronunciationController.dispose();
    partOfSpeechController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                FormItem(
                  title: S.current.word,
                  controller: wordController,
                  isRequired: true,
                ),
                FormItem(
                  title: S.current.meaning,
                  controller: meaningController,
                ),
                FormItem(
                  title: S.current.definition,
                  controller: definitionController,
                ),
                FormItem(
                  title: '${S.current.example} 1',
                  controller: example1SentenceController,
                ),
                FormItem(
                  title: '${S.current.example} 2',
                  controller: example2SentenceController,
                ),
                FormItem(
                  title: S.current.note,
                  controller: noteController,
                ),
                FormItem(
                  title: S.current.pronunciation,
                  controller: pronunciationController,
                ),
                FormItem(
                  title: S.current.part_of_speech,
                  controller: partOfSpeechController,
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
                child: BlocConsumer<FlashCardDetailCubit, FlashCardDetailState>(
                  listener: (context, state) {
                    if (state.loadStatusAiGen == LoadStatus.success) {
                      final flashCardAiGen = state.flashCardAiGen;
                      if (flashCardAiGen != null) {
                        wordController.text = flashCardAiGen.word;
                        meaningController.text = flashCardAiGen.translation;
                        definitionController.text = flashCardAiGen.definition;
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
                  bloc: BlocProvider.of<FlashCardDetailCubit>(context),
                  buildWhen: (previous, current) =>
                      previous.loadStatusAiGen != current.loadStatusAiGen,
                  builder: (context, state) {
                    final isLoading =
                        state.loadStatusAiGen == LoadStatus.loading;
                    return BlocSelector<UserCubit, UserState, UserEntity?>(
                      selector: (state) => state.user,
                      builder: (context, user) {
                        final isPremium = user?.isPremium();
                        return CustomButton(
                          height: 50,
                          onPressed: isPremium == true
                              ? isLoading
                                  ? null
                                  : () async {
                                      _cubit.getFlashCardInforByAI(
                                          wordController.text);
                                    }
                              : null,
                          child: isLoading
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const LoadingCircle(
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(S.current.ai_filling),
                                  ],
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (isPremium == false) ...[
                                      const FaIcon(FontAwesomeIcons.lock),
                                      const SizedBox(width: 8),
                                    ] else ...[
                                      const FaIcon(FontAwesomeIcons.robot),
                                      const SizedBox(width: 8),
                                    ],
                                    Text(S.current.fill_by_ai),
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
                child: CustomButton(
                  onPressed: () {
                    final flashCardRequest = FlashCardRequest(
                      word: wordController.text,
                      translation: meaningController.text,
                      definition: definitionController.text,
                      exampleSentence: [
                        example1SentenceController.text,
                        example2SentenceController.text,
                      ],
                      note: noteController.text,
                      partOfSpeech: partOfSpeechController.text.split(', '),
                      pronunciation: pronunciationController.text,
                      setFlashcardId:
                          widget.args.flashCard?.setFlashcardId ?? '',
                    );
                    widget.args.onSave(flashCardRequest);
                    GoRouter.of(context).pop();
                  },
                  child: Text(S.current.save_button),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
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
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.end,
              ),
              // required
              if (isRequired)
                const Text('*', style: TextStyle(color: Colors.red)),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller, // Attach controller
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.gray1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: theme.colorScheme.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

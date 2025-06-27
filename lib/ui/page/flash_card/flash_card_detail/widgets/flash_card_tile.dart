import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toeic_desktop/common/utils/utils.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/confirm_dia_log.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_detail/flash_card_detail_cubit.dart';
import 'package:toeic_desktop/ui/page/flash_card/flash_card_detail/widgets/form_flash_card_dia_log.dart';

class FlashcardTile extends StatefulWidget {
  final FlashCard flashcard;

  const FlashcardTile({super.key, required this.flashcard});

  @override
  State<FlashcardTile> createState() => _FlashcardTileState();
}

class _FlashcardTileState extends State<FlashcardTile>
    with TickerProviderStateMixin {
  late FlutterTts flutterTts;
  bool isPlaying = false;
  bool isExpanded = false;
  late final FlashCardDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<FlashCardDetailCubit>();
    flutterTts = FlutterTts()
      ..setVolume(1.0)
      ..setLanguage('en-US');
  }

  Future _speak(String word) async {
    await flutterTts.speak(word);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        Text(
                          widget.flashcard.word,
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        // Add a button to play the pronunciation
                        InkWell(
                          onTap: () {
                            _speak(widget.flashcard.word);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary
                                    .withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.volume_up_outlined,
                                color: theme.colorScheme.primary,
                              )),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.flashcard.partOfSpeech.join(', '),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.textWhite,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        PopupMenuButton(
                          icon: const Icon(Icons.more_vert, size: 16),
                          color: theme.appBarTheme.backgroundColor,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onSelected: (value) {
                            switch (value) {
                              case 'edit':
                                Utils.showModalBottomSheetForm(
                                  context: context,
                                  title: S.current.edit,
                                  child: BlocProvider.value(
                                    value: _cubit,
                                    child: FlashCardDetailForm(
                                      args: FlashCardDetailFormArgs(
                                        type: FlashCardDetailFormType.edit,
                                        flashCard: widget.flashcard,
                                        onSave: (flashCardRequest) {
                                          _cubit.updateFlashCard(
                                            widget.flashcard.id,
                                            flashCardRequest.word,
                                            flashCardRequest.translation,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                                break;
                              case 'delete':
                                showConfirmDialog(
                                  context,
                                  S.current.delete,
                                  S.current.are_you_sure_delete_flashcard,
                                  () {
                                    context
                                        .read<FlashCardDetailCubit>()
                                        .deleteFlashCard(
                                          widget.flashcard.id,
                                        );
                                  },
                                );
                                break;
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.penToSquare,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    S.current.edit,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.trash,
                                    size: 14,
                                    color: theme.colorScheme.error,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    S.current.delete,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.error,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildPronunciation(widget.flashcard.pronunciation, 'UK'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${S.current.translate}: ',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: widget.flashcard.translation,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const FaIcon(
                          FontAwesomeIcons.chevronDown,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isExpanded) ...[
                          const SizedBox(height: 8),
                          Text(
                            '${S.current.definition}:',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.flashcard.definition,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Text(
                            '${S.current.example_sentences}:',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (widget.flashcard.exampleSentence.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            ...widget.flashcard.exampleSentence
                                .map((example) => Text(
                                      '- $example',
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        fontStyle: FontStyle.italic,
                                      ),
                                    )),
                          ],
                          const SizedBox(height: 4),
                          Text(
                            '${S.current.note}:',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.flashcard.note,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ]
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPronunciation(String pronunciation, String label) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          '$label:',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          pronunciation,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

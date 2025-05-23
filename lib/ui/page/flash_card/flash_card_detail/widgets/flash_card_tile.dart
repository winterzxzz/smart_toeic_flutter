import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toeic_desktop/common/utils/utils.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card.dart';
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
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
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
                                color: Colors.blue.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.volume_up_outlined,
                                color: AppColors.primary,
                              )),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.flashcard.partOfSpeech.join(', '),
                          style: const TextStyle(
                              color: AppColors.textWhite,
                              fontWeight: FontWeight.w500),
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
                                title: 'Edit Flashcard',
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
                                'Delete Flashcard',
                                'Are you sure you want to delete this flashcard?',
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
                                  'Edit',
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
                                  'Delete',
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
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Translate: ${widget.flashcard.translation}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16),
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
                          const Text(
                            'Definition:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.flashcard.definition,
                          ),
                          const Text('Example Sentences:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          if (widget.flashcard.exampleSentence.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            ...widget.flashcard.exampleSentence
                                .map((example) => Text(
                                      '- $example',
                                      style: TextStyle(color: Colors.grey[700]),
                                    )),
                          ],
                          const SizedBox(height: 8),
                          const Text('Note:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(widget.flashcard.note),
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
    return Row(
      children: [
        Text(
          '$label:',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 4),
        Text(
          pronunciation,
          style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}

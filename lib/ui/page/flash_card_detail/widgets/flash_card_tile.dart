import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card.dart';
import 'package:toeic_desktop/data/models/ui_models/popup_menu.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/confirm_dia_log.dart';
import 'package:toeic_desktop/ui/common/widgets/show_pop_over.dart';
import 'package:toeic_desktop/ui/page/flash_card_detail/flash_card_detail_cubit.dart';
import 'package:toeic_desktop/ui/page/flash_card_detail/widgets/form_flash_card_dia_log.dart';
import 'package:toeic_desktop/ui/page/set_flashcard/widgets/set_flash_card_learning_item.dart';

class FlashcardTile extends StatefulWidget {
  final FlashCard flashcard;

  const FlashcardTile({super.key, required this.flashcard});

  @override
  State<FlashcardTile> createState() => _FlashcardTileState();
}

class _FlashcardTileState extends State<FlashcardTile> {
  late FlutterTts flutterTts;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts()
      ..setVolume(1.0)
      ..setLanguage('en-US');
  }

  Future _speak(String word) async {
    await flutterTts.speak(word);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.8,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.flashcard.word,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
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
                        child: Icon(
                          Icons.volume_up_outlined,
                          color: AppColors.primary,
                        )),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      widget.flashcard.partOfSpeech.join(', '),
                      style: TextStyle(
                          color: AppColors.textWhite,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: _showMenuDialog,
                    icon: Icon(Icons.more_vert),
                  )
                ],
              ),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildPronunciation(
                                widget.flashcard.pronunciation, 'UK'),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Translate: ${widget.flashcard.translation}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Definition:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.flashcard.definition,
                        ),
                        Text('Example Sentences:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        if (widget.flashcard.exampleSentence.isNotEmpty) ...[
                          SizedBox(height: 8),
                          ...widget.flashcard.exampleSentence
                              .map((example) => Text(
                                    '- $example',
                                    style: TextStyle(color: Colors.grey[700]),
                                  )),
                        ],
                        SizedBox(height: 8),
                        Text('Note:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(widget.flashcard.note),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMenuDialog() {
    showPopMenuOver(
      context,
      ListItems(
        popupMenus: [
          PopupMenu(
            title: 'Update',
            icon: Icons.update,
            onPressed: () async {
              GoRouter.of(context).pop();
              await Future.delayed(Duration(milliseconds: 100));
              if (mounted) {
                showCreateFlashCardDialog(context, flashCard: widget.flashcard,
                    onSave: (flashCardRequest) {
                  context.read<FlashCardDetailCubit>().updateFlashCard(
                      widget.flashcard.id,
                      flashCardRequest.word,
                      flashCardRequest.translation);
                });
              }
            },
          ),
          PopupMenu(
            title: 'Delete',
            icon: Icons.delete,
            onPressed: () {
              GoRouter.of(context).pop();
              showConfirmDialog(context, 'Bạn có chắc chắn muốn xóa không?',
                  'Hành động này không thể hoàn tác. Điều này sẽ xóa vĩnh viễn dữ liệu của bạn.',
                  () {
                context
                    .read<FlashCardDetailCubit>()
                    .deleteFlashCard(widget.flashcard.id);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPronunciation(String pronunciation, String label) {
    return Row(
      children: [
        Text(
          '$label:',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 4),
        Text(
          pronunciation,
          style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}

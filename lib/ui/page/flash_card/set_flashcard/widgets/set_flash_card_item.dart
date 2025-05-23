import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/common/utils/utils.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/set_flash_card/set_flash_card.dart';
import 'package:toeic_desktop/ui/common/widgets/confirm_dia_log.dart';
import 'package:toeic_desktop/ui/common/widgets/tag_widget.dart';
import 'package:toeic_desktop/ui/page/flash_card/set_flashcard/set_flash_card_cubit.dart';
import 'package:toeic_desktop/ui/page/flash_card/set_flashcard/widgets/form_set_flash_card_dia_log.dart';

class SetFlashCardItem extends StatefulWidget {
  final SetFlashCard flashcard;

  const SetFlashCardItem({super.key, required this.flashcard});

  @override
  State<SetFlashCardItem> createState() => _SetFlashCardItemState();
}

class _SetFlashCardItemState extends State<SetFlashCardItem> {
  late final FlashCardCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<FlashCardCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tags = [
      TagWidget(
          icon: FontAwesomeIcons.bookBookmark,
          text: '${widget.flashcard.numberOfFlashcards} flashcards'),
      TagWidget(
          icon: FontAwesomeIcons.calendar,
          text: DateFormat('dd/MM/yyyy').format(widget.flashcard.createdAt)),
      TagWidget(
          icon: widget.flashcard.isPublic
              ? FontAwesomeIcons.globe
              : FontAwesomeIcons.lock,
          text: widget.flashcard.isPublic ? 'Public' : 'Private'),
    ];

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          GoRouter.of(context).pushNamed(AppRouter.flashCardDetail, extra: {
            'title': widget.flashcard.title,
            'setId': widget.flashcard.id,
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.flashcard.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert, size: 16),
                    color: theme.appBarTheme.backgroundColor,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          showEditSetFlashCardBottomSheet(context);
                          break;
                        case 'delete':
                          showConfirmDialog(
                            context,
                            'Delete Flashcard',
                            'Are you sure you want to delete this flashcard?',
                            () {
                              _cubit.deleteFlashCardSet(widget.flashcard.id);
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
                  ),
                ],
              ),
              Text(
                widget.flashcard.description,
                style: theme.textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 24,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: tags.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return tags[index];
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showEditSetFlashCardBottomSheet(BuildContext context) {
    Utils.showModalBottomSheetForm(
      context: context,
      title: 'Edit flashcard set',
      child: FormFlashCard(
        args: FormFlashCardArgs(
          title: widget.flashcard.title,
          description: widget.flashcard.description,
          type: FormFlashCardType.edit,
          onSave: (title, description) {
            _cubit.updateFlashCardSet(
              widget.flashcard.id,
              title,
              description,
            );
          },
        ),
      ),
    );
  }
}

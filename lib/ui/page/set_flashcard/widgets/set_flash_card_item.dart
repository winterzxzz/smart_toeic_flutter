import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/set_flash_card/set_flash_card.dart';
import 'package:toeic_desktop/data/models/ui_models/popup_menu.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/confirm_dia_log.dart';
import 'package:toeic_desktop/ui/common/widgets/show_pop_over.dart';
import 'package:toeic_desktop/ui/page/set_flashcard/set_flash_card_cubit.dart';
import 'package:toeic_desktop/ui/page/set_flashcard/widgets/form_set_flash_card_dia_log.dart';

class SetFlashCardItem extends StatefulWidget {
  final SetFlashCard flashcard;

  const SetFlashCardItem({super.key, required this.flashcard});

  @override
  State<SetFlashCardItem> createState() => _SetFlashCardItemState();
}

class _SetFlashCardItemState extends State<SetFlashCardItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.flashcard.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: _showMenuDialog,
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
            if (widget.flashcard.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                widget.flashcard.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person_outline, color: AppColors.textGray, size: 20),
                const SizedBox(width: 8),
                Text(
                  'winter',
                  style: TextStyle(
                    color: AppColors.textGray,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_month_outlined,
                    color: AppColors.textGray, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Created at ${DateFormat('dd/MM/yyyy').format(widget.flashcard.createdAt)}',
                  style: TextStyle(
                    color: AppColors.textGray,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.flashcard.numberOfFlashcards} flashcards',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    GoRouter.of(context)
                        .pushNamed(AppRouter.flashCardDetail, extra: {
                      'title': widget.flashcard.title,
                      'setId': widget.flashcard.id,
                    });
                  },
                  child: const Text('View'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showMenuDialog() {
    final List<PopupMenu> popupMenus = [
      PopupMenu(
        title: 'Edit',
        icon: Icons.edit,
        onPressed: () {
          showCreateSetFlashCardDialog(
            context,
            title: widget.flashcard.title,
            description: widget.flashcard.description,
            onSave: (title, description) {
              context.read<FlashCardCubit>().updateFlashCardSet(
                    widget.flashcard.id,
                    title,
                    description,
                  );
            },
          );
        },
      ),
      PopupMenu(
        title: 'Delete',
        icon: Icons.delete,
        onPressed: () {
          showConfirmDialog(
            context,
            'Delete Flashcard',
            'Are you sure you want to delete this flashcard?',
            () {
              context.read<FlashCardCubit>().deleteFlashCardSet(
                    widget.flashcard.id,
                  );
            },
          );
        },
      ),
    ];

    showPopMenuOver(
      context,
      ListItems(popupMenus: popupMenus),
    );
  }
}

class ListItems extends StatelessWidget {
  final List<PopupMenu> popupMenus;
  const ListItems({super.key, required this.popupMenus});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: popupMenus
            .map((e) => Column(
                  children: [
                    InkWell(
                      onTap: e.onPressed,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.primary,
                        ),
                        height: 40,
                        child: Row(
                          children: [
                            Icon(e.icon, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              e.title,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (popupMenus.indexOf(e) != popupMenus.length - 1)
                      const Divider(),
                  ],
                ))
            .toList(),
      ),
    );
  }
}

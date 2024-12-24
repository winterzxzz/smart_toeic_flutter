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
      child: Container(
        constraints: const BoxConstraints(maxHeight: 250),
        width: (MediaQuery.sizeOf(context).width - 60) * 0.23,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.flashcard.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
            Text(
              widget.flashcard.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.person_outline, color: AppColors.textGray),
                const SizedBox(width: 8),
                Text(
                  'winter',
                  style: TextStyle(color: AppColors.textGray),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.calendar_month_outlined, color: AppColors.textGray),
                const SizedBox(width: 8),
                Text(
                  'Created at ${DateFormat('dd/MM/yyyy').format(widget.flashcard.createdAt)}',
                  style: TextStyle(color: AppColors.textGray),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.flashcard.numberOfFlashcards} flashcards',
                ),
                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context)
                        .pushNamed(AppRouter.flashCardDetail, extra: {
                      'title': widget.flashcard.title,
                      'setId': widget.flashcard.id,
                    });
                  },
                  child: Text('View'),
                ),
              ],
            ),
          ],
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
                showCreateSetFlashCardDialog(context,
                    title: widget.flashcard.title,
                    description: widget.flashcard.description,
                    onSave: (title, description) {
                  context.read<FlashCardCubit>().updateFlashCardSet(
                      widget.flashcard.id, title, description);
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
                    .read<FlashCardCubit>()
                    .deleteFlashCardSet(widget.flashcard.id);
              });
            },
          ),
        ],
      ),
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
                              style: TextStyle(color: Colors.white),
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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/set_flash_card/set_flash_card_learning.dart';
import 'package:toeic_desktop/data/models/ui_models/popup_menu.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

class SetFlashCardLearningItem extends StatelessWidget {
  final SetFlashCardLearning flashcard;

  const SetFlashCardLearningItem({super.key, required this.flashcard});

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
            if (_getNumberOfQuestionsReview(flashcard) > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_getNumberOfQuestionsReview(flashcard)} to reviews',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 8),
            Text(
              flashcard.setFlashcardId.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              flashcard.setFlashcardId.description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.document_scanner_outlined,
                    color: AppColors.textGray, size: 20),
                const SizedBox(width: 8),
                Text(
                  '${flashcard.setFlashcardId.numberOfFlashcards} flashcards',
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
                  'Created at ${DateFormat('dd/MM/yyyy').format(flashcard.createdAt)}',
                  style: TextStyle(
                    color: AppColors.textGray,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  GoRouter.of(context).pushNamed(
                    AppRouter.flashCardLearningDetail,
                    extra: {
                      'setFlashCardLearning': flashcard,
                    },
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow_outlined),
                    SizedBox(width: 8),
                    Text(
                      'Start Learning',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getNumberOfQuestionsReview(SetFlashCardLearning flashcard) {
    return flashcard.learningFlashcards
        .where((element) => element < 0.2)
        .length;
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

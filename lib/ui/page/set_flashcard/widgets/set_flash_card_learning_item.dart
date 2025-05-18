import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/set_flash_card/set_flash_card_learning.dart';
import 'package:toeic_desktop/data/models/ui_models/popup_menu.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/tag_widget.dart';

class SetFlashCardLearningItem extends StatelessWidget {
  final SetFlashCardLearning flashcard;

  const SetFlashCardLearningItem({super.key, required this.flashcard});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tags = [
      TagWidget(
        icon: FontAwesomeIcons.bookBookmark,
        text: '${flashcard.setFlashcardId.numberOfFlashcards} flashcards',
      ),
      TagWidget(
        icon: FontAwesomeIcons.calendar,
        text: DateFormat('dd/MM/yyyy').format(flashcard.createdAt),
      ),
      TagWidget(
        icon: FontAwesomeIcons.clock,
        text:
            'Last studied: ${DateFormat('dd/MM/yyyy').format(flashcard.lastStudied)}',
      ),
    ];
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          GoRouter.of(context).pushNamed(
            AppRouter.flashCardLearningDetail,
            extra: {'setFlashCardLearning': flashcard},
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      flashcard.setFlashcardId.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${_getNumberOfQuestionsReview(flashcard)} to reviews',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
              Text(
                flashcard.setFlashcardId.description,
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

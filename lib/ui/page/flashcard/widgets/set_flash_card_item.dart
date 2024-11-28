import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/entities/set_flash_card.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

class FlashcardItem extends StatelessWidget {
  final SetFlashCard flashcard;

  const FlashcardItem({super.key, required this.flashcard});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: () {
          GoRouter.of(context).pushNamed(AppRouter.flashCardDetail, extra: {
            'setId': flashcard.id,
          });
        },
        overlayColor: WidgetStatePropertyAll(Colors.pink.withOpacity(0.1)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                flashcard.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${flashcard.numberOfFlashcards} flashcards',
                  ),
                  const SizedBox(width: 16),
                  Container(
                    height: 16,
                    width: 1,
                    color: AppColors.textBlack,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '👥 ${flashcard.description}',
                  ),
                ],
              ),
              Row(
                children: [const SizedBox(width: 16), Text(flashcard.userId)],
              ), // Placeholder for the icon/logo
            ],
          ),
        ),
      ),
    );
  }
}

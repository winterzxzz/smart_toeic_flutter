import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/set_flash_card/set_flash_card_learning.dart';
import 'package:toeic_desktop/data/models/ui_models/popup_menu.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/widgets/tag_widget.dart';

class SetFlashCardLearningItem extends StatelessWidget {
  final SetFlashCardLearning flashcard;

  const SetFlashCardLearningItem({super.key, required this.flashcard});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final tags = [
      TagWidget(
        icon: FontAwesomeIcons.bookBookmark,
        text:
            '${flashcard.setFlashcardId.numberOfFlashcards} ${S.current.flashcards.toLowerCase()}',
      ),
      TagWidget(
        icon: FontAwesomeIcons.calendar,
        text: DateFormat('dd/MM/yyyy').format(flashcard.createdAt),
      ),
      TagWidget(
        icon: FontAwesomeIcons.clock,
        text:
            '${S.current.last_studied}: ${DateFormat('dd/MM/yyyy').format(flashcard.lastStudied)}',
      ),
    ];
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              GoRouter.of(context).pushNamed(
                AppRouter.flashCardLearningDetail,
                extra: {'setFlashCardLearning': flashcard},
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: colorScheme.primary,
                    width: 4.w,
                  ),
                ),
              ),
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          flashcard.setFlashcardId.title,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 18.sp,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (_getNumberOfQuestionsReview(flashcard) > 0)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            '${_getNumberOfQuestionsReview(flashcard)} ${S.current.to_reviews}',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    flashcard.setFlashcardId.description,
                    style: textTheme.bodySmall?.copyWith(
                      fontSize: 13.sp,
                      color: colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 16.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: tags.map((tag) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer
                              .withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(
                              tag.icon,
                              size: 12.spMin,
                              color: colorScheme.primary,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              tag.text,
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
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
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
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
                          color: colorScheme.primary,
                        ),
                        height: 40,
                        child: Row(
                          children: [
                            Icon(e.icon, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              e.title,
                              style: textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                              ),
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

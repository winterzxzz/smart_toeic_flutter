import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/common/utils/utils.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/set_flash_card/set_flash_card.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
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
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
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
              GoRouter.of(context).pushNamed(AppRouter.flashCardDetail, extra: {
                'title': widget.flashcard.title,
                'setId': widget.flashcard.id,
              });
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.flashcard.title,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 18.sp,
                                color: colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              widget.flashcard.description,
                              style: textTheme.bodySmall?.copyWith(
                                fontSize: 13.sp,
                                color: colorScheme.onSurfaceVariant,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),
                      PopupMenuButton(
                        icon: Icon(Icons.more_horiz,
                            size: 24.spMin, color: colorScheme.outline),
                        color: colorScheme.surface,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        offset: Offset(0, 8.h),
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
                                S.current.delete,
                                S.current.are_you_sure_delete_flashcard,
                                () {
                                  _cubit
                                      .deleteFlashCardSet(widget.flashcard.id);
                                },
                              );
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            height: 40.h,
                            child: Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.penToSquare,
                                  size: 14.spMin,
                                  color: colorScheme.onSurface,
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  S.current.edit,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            height: 40.h,
                            value: 'delete',
                            child: Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.trash,
                                  size: 14.spMin,
                                  color: colorScheme.error,
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  S.current.delete,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.error,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showEditSetFlashCardBottomSheet(BuildContext context) {
    Utils.showModalBottomSheetForm(
      context: context,
      title: S.current.edit_flashcard_set,
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

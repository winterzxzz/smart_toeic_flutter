import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toeic_desktop/common/utils/utils.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
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
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return Container(
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
              setState(() {
                isExpanded = !isExpanded;
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
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                widget.flashcard.word,
                                style: textTheme.titleMedium?.copyWith(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            InkWell(
                              onTap: () {
                                _speak(widget.flashcard.word);
                              },
                              borderRadius: BorderRadius.circular(16.r),
                              child: Container(
                                padding: EdgeInsets.all(6.w),
                                decoration: BoxDecoration(
                                  color: colorScheme.primaryContainer,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.volume_up_rounded,
                                  color: colorScheme.primary,
                                  size: 18.spMin,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          widget.flashcard.partOfSpeech.join(', '),
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      PopupMenuButton(
                        icon: Icon(Icons.more_vert_rounded,
                            size: 20.spMin, color: colorScheme.outline),
                        color: colorScheme.surface,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onSelected: (value) {
                          switch (value) {
                            case 'edit':
                              Utils.showModalBottomSheetForm(
                                context: context,
                                title: S.current.edit,
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
                                S.current.delete,
                                S.current.are_you_sure_delete_flashcard,
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
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            height: 40.h,
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
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPronunciation(widget.flashcard.pronunciation, 'UK'),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${S.current.translate}: ',
                                    style: textTheme.bodyMedium,
                                  ),
                                  TextSpan(
                                    text: widget.flashcard.translation,
                                    style: textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          AnimatedRotation(
                            turns: isExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 24.spMin,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isExpanded) ...[
                              SizedBox(height: 12.h),
                              Divider(
                                  height: 1, color: colorScheme.outlineVariant),
                              SizedBox(height: 12.h),
                              Text(
                                '${S.current.definition}:',
                                style: textTheme.labelLarge?.copyWith(
                                  color: colorScheme.primary,
                                ),
                              ),
                              Text(
                                widget.flashcard.definition,
                                style: textTheme.bodyMedium?.copyWith(
                                  height: 1.4,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                '${S.current.example_sentences}:',
                                style: textTheme.labelLarge?.copyWith(
                                  color: colorScheme.primary,
                                ),
                              ),
                              if (widget.flashcard.exampleSentence.isNotEmpty)
                                ...widget.flashcard.exampleSentence
                                    .map((example) => Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.h),
                                          child: Text(
                                            '- $example',
                                            style:
                                                textTheme.bodyMedium?.copyWith(
                                              fontStyle: FontStyle.italic,
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        )),
                              SizedBox(height: 8.h),
                              Text(
                                '${S.current.note}:',
                                style: textTheme.labelLarge?.copyWith(
                                  color: colorScheme.primary,
                                ),
                              ),
                              Text(
                                widget.flashcard.note,
                                style: textTheme.bodyMedium,
                              ),
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
        ),
      ),
    );
  }

  Widget _buildPronunciation(String pronunciation, String label) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          Text(
            '/$pronunciation/',
            style: textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
              fontFamily: 'Roboto', // Ensure support for phonetic chars
            ),
          ),
        ],
      ),
    );
  }
}

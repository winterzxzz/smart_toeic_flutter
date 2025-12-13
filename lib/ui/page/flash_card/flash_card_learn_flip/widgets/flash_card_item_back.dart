import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';

class FlashcardBack extends StatelessWidget {
  final FlashCard flashcard;

  const FlashcardBack({super.key, required this.flashcard});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      padding: EdgeInsets.all(24.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildSectionTitle(context, 'Translate'),
            Text(
              flashcard.translation,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            SizedBox(height: 16.h),
            _buildSectionTitle(context, 'Definition'),
            Text(
              flashcard.definition,
              style: textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
            if (flashcard.exampleSentence.isNotEmpty) ...[
              SizedBox(height: 16.h),
              _buildSectionTitle(context, 'Examples'),
              ...flashcard.exampleSentence.map((example) => Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: BoxDecoration(
                              color: colorScheme.secondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            example,
                            style: textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: colorScheme.onSurfaceVariant,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              SizedBox(height: 16.h),
              if (flashcard.note.isNotEmpty) ...[
                _buildSectionTitle(context, 'Note'),
                Text(
                  flashcard.note,
                  style: textTheme.bodyMedium,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Text(
        title,
        style: context.textTheme.labelLarge?.copyWith(
          color: context.colorScheme.tertiary,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

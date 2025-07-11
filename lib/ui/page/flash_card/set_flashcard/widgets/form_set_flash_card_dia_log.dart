import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/widgets/capitalize_first_letter_input.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';

enum FormFlashCardType {
  create,
  edit,
}

class FormFlashCardArgs {
  final String? title;
  final String? description;
  final FormFlashCardType type;
  final Function(String, String) onSave;

  const FormFlashCardArgs({
    this.title,
    this.description,
    required this.type,
    required this.onSave,
  });
}

class FormFlashCard extends StatefulWidget {
  const FormFlashCard({
    super.key,
    required this.args,
  });

  final FormFlashCardArgs args;

  @override
  State<FormFlashCard> createState() => _FormFlashCardState();
}

class _FormFlashCardState extends State<FormFlashCard> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.args.title);
    descriptionController =
        TextEditingController(text: widget.args.description ?? '');
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.current.title,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              inputFormatters: [CapitalizeFirstLetterFormatter()],
              controller: titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.textGray),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.primary),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              S.current.description,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              inputFormatters: [CapitalizeFirstLetterFormatter()],
              controller: descriptionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.textGray),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.primary),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => GoRouter.of(context).pop(),
                    child: Text(S.current.cancel, style: textTheme.bodyMedium),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      widget.args.onSave(
                        titleController.text,
                        descriptionController.text,
                      );
                      GoRouter.of(context).pop();
                    },
                    child: Text(S.current.save_button),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

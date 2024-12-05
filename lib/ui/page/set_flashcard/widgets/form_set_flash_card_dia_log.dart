import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

void showCreateSetFlashCardDialog(BuildContext widgetContext,
    {String? title,
    String? description,
    required Function(String, String) onSave}) {
  // Create controllers for the text fields
  final TextEditingController titleController =
      TextEditingController(text: title);
  final TextEditingController descriptionController =
      TextEditingController(text: description);

  showDialog(
    context: widgetContext,
    builder: (context) {
      return AlertDialog(
        scrollable: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tạo danh sách thẻ nhớ',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            IconButton(
              onPressed: () {
                GoRouter.of(context).pop();
              },
              icon: Icon(
                Icons.close,
                color: AppColors.gray3,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 70,
                    child: Text(
                      'Tiêu đề',
                      style: TextStyle(fontWeight: FontWeight.w500),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: titleController, // Attach controller
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.gray1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.gray3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 70,
                    child: Text(
                      'Mô tả',
                      style: TextStyle(fontWeight: FontWeight.w500),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: descriptionController, // Attach controller
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: AppColors.gray1.withOpacity(0.1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.gray3),
                        ),
                      ),
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              onSave(titleController.text, descriptionController.text);
              GoRouter.of(context).pop();
            },
            child: const Text('Lưu'),
          ),
        ],
      );
    },
  );
}

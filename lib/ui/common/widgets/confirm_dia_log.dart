import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';

void showConfirmDialog(
    BuildContext context, String title, String content, Function() onConfirm) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                  onPressed: () => GoRouter.of(context).pop(),
                  child: Text(S.current.cancel)),
              CustomButton(
                  width: 100,
                  onPressed: () {
                    GoRouter.of(context).pop();
                    onConfirm();
                  },
                  child: Text(S.current.confirm)),
            ],
          ));
}

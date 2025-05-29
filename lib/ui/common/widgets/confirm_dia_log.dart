import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';

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
              ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).pop();
                    onConfirm();
                  },
                  child: Text(S.current.confirm)),
            ],
          ));
}

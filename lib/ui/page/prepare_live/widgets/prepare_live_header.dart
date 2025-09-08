import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/widgets/confirm_dia_log.dart';

class PrepareLiveHeader extends StatelessWidget {
  final Function()? onClose;
  const PrepareLiveHeader({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(50)),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundImage:
                      Image.network('https://picsum.photos/200/300').image,
                ),
                const SizedBox(width: 4),
                Text('Live Stream',
                    style: textTheme.bodySmall?.copyWith(color: Colors.white)),
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                showConfirmDialog(
                    context, S.current.exit, S.current.are_you_sure_exit, () {
                  if (onClose != null) {
                    onClose!();
                  } else {
                    GoRouter.of(context).pop();
                  }
                });
              },
              icon: const Icon(Icons.close, color: Colors.white))
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/configs/app_configs.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/data/models/entities/profile/user_entity.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/widgets/confirm_dia_log.dart';

class PrepareLiveHeader extends StatelessWidget {
  final Function()? onClose;
  final int viewCount;
  const PrepareLiveHeader({super.key, this.onClose, this.viewCount = 0});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
                // color: colorScheme.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(50)),
            child: BlocSelector<UserCubit, UserState, UserEntity?>(
              selector: (state) {
                return state.user;
              },
              builder: (context, user) {
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: Image.network(
                              '${AppConfigs.baseUrl}${user?.avatar ?? ''}')
                          .image,
                    ),
                    const SizedBox(width: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(user?.name ?? 'No Name',
                            style: textTheme.titleSmall
                                ?.copyWith(color: Colors.white, fontSize: 12)),
                        // number of view
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.remove_red_eye, size: 12),
                            const SizedBox(width: 4),
                            Text(viewCount.toString(),
                                style: textTheme.bodySmall?.copyWith(
                                    color: Colors.white, fontSize: 12)),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(width: 16),
                  ],
                );
              },
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

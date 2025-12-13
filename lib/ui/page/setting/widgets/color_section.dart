import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/common/global_blocs/setting/app_setting_cubit.dart';
import 'package:toeic_desktop/common/utils/constants.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/app_style.dart';
import 'package:toeic_desktop/ui/page/setting/widgets/setting_card.dart';
import 'package:toeic_desktop/ui/page/setting/widgets/settting_switch.dart';

class ColorSection extends StatelessWidget {
  const ColorSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final cubit = context.read<AppSettingCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppStyle.edgeInsetsA12,
          child: Text(
            S.current.theme_color,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
            ),
          ),
        ),
        BlocBuilder<AppSettingCubit, AppSettingState>(
          buildWhen: (previous, current) {
            return previous.primaryColor != current.primaryColor ||
                previous.isDynamicColor != current.isDynamicColor;
          },
          builder: (context, state) {
            return SettingsCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SettingsSwitch(
                    value: state.isDynamicColor,
                    title: S.current.dynamic_color,
                    onChanged: (e) {
                      cubit.changeDynamicColor(isDynamicColor: e);
                    },
                  ),
                  if (!state.isDynamicColor) ...[
                    AppStyle.divider,
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: SizedBox(
                        height: 50,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: Constants.primaryColorsHex.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final hex = Constants.primaryColorsHex[index];
                            final color = Color(int.parse('0xff$hex'));
                            final isSelected = state.primaryColor == color;
                            return GestureDetector(
                              onTap: () {
                                cubit.changePrimaryColor(
                                    color: color, hexColor: hex);
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey.withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: color.withValues(alpha: 0.4),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                          )
                                        ]
                                      : null,
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 20,
                                      )
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

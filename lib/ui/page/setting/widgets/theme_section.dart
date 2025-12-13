import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toeic_desktop/common/global_blocs/setting/app_setting_cubit.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/app_style.dart';
import 'package:toeic_desktop/ui/page/setting/widgets/setting_card.dart';

class ThemeSection extends StatelessWidget {
  const ThemeSection({super.key});

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
            S.current.display_theme,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: textTheme.bodyMedium?.color?.withValues(alpha: .7),
            ),
          ),
        ),
        BlocSelector<AppSettingCubit, AppSettingState, ThemeMode>(
          selector: (state) => state.themeMode,
          builder: (context, themeMode) {
            return SettingsCard(
              child: Column(
                children: [
                  _buildRadioTile(
                    context,
                    title: S.current.follow_system,
                    value: ThemeMode.system.index,
                    groupValue: themeMode.index,
                    icon: FontAwesomeIcons.mobileScreen,
                    onChanged: (val) =>
                        cubit.changeThemeMode(themeMode: ThemeMode.system),
                  ),
                  AppStyle.divider,
                  _buildRadioTile(
                    context,
                    title: S.current.light_mode,
                    value: ThemeMode.light.index,
                    groupValue: themeMode.index,
                    icon: FontAwesomeIcons.sun,
                    onChanged: (val) =>
                        cubit.changeThemeMode(themeMode: ThemeMode.light),
                  ),
                  AppStyle.divider,
                  _buildRadioTile(
                    context,
                    title: S.current.dark_mode,
                    value: ThemeMode.dark.index,
                    groupValue: themeMode.index,
                    icon: FontAwesomeIcons.moon,
                    onChanged: (val) =>
                        cubit.changeThemeMode(themeMode: ThemeMode.dark),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRadioTile(
    BuildContext context, {
    required String title,
    required int value,
    required int groupValue,
    required IconData icon,
    required ValueChanged<int?> onChanged,
  }) {
    final isSelected = value == groupValue;
    final colorScheme = context.colorScheme;
    return RadioListTile<int>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: colorScheme.primary,
      contentPadding: AppStyle.edgeInsetsH12,
      title: Row(
        children: [
          FaIcon(
            icon,
            size: 18,
            color: isSelected ? colorScheme.primary : Colors.grey,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }
}

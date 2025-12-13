import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/common/global_blocs/setting/app_setting_cubit.dart';
import 'package:toeic_desktop/data/models/enums/language.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/app_style.dart';
import 'package:toeic_desktop/ui/page/setting/widgets/setting_card.dart';

class LanguageSection extends StatelessWidget {
  const LanguageSection({super.key});

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
            S.current.language,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
            ),
          ),
        ),
        BlocSelector<AppSettingCubit, AppSettingState, Language>(
          selector: (state) => state.language,
          builder: (context, language) {
            return SettingsCard(
              child: Column(
                children: [
                  _buildRadioTile(
                    context,
                    title: S.current.english,
                    value: Language.english,
                    groupValue: language,
                    flag: '🇺🇸',
                    onChanged: (val) {
                      if (val != null) cubit.changeLanguage(language: val);
                    },
                  ),
                  AppStyle.divider,
                  _buildRadioTile(
                    context,
                    title: S.current.vietnamese,
                    value: Language.vietnamese,
                    groupValue: language,
                    flag: '🇻🇳',
                    onChanged: (val) {
                      if (val != null) cubit.changeLanguage(language: val);
                    },
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
    required Language value,
    required Language groupValue,
    required String flag,
    required ValueChanged<Language?> onChanged,
  }) {
    final isSelected = value == groupValue;
    final colorScheme = context.colorScheme;
    return RadioListTile<Language>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: colorScheme.primary,
      contentPadding: AppStyle.edgeInsetsH12,
      controlAffinity: ListTileControlAffinity.trailing,
      title: Row(
        children: [
          Text(
            flag,
            style: const TextStyle(fontSize: 20),
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
    );
  }
}

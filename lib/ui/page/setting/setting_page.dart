import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/setting/app_setting_cubit.dart';
import 'package:toeic_desktop/common/utils/constants.dart';
import 'package:toeic_desktop/data/models/enums/language.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_style.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';
import 'package:toeic_desktop/ui/page/setting/widgets/setting_card.dart';
import 'package:toeic_desktop/ui/page/setting/widgets/settting_switch.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late final AppSettingCubit appSettingCubit;

  @override
  void initState() {
    super.initState();
    appSettingCubit = injector<AppSettingCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            S.current.settings,
            style: theme.textTheme.titleMedium,
          ),
          leading: const LeadingBackButton(),
        ),
        body: ListView(
          children: [
            Padding(
              padding: AppStyle.edgeInsetsA12,
              child: Text(S.current.display_theme),
            ),
            BlocSelector<AppSettingCubit, AppSettingState, ThemeMode>(
              selector: (state) {
                return state.themeMode;
              },
              builder: (context, themeMode) {
                return SettingsCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile<int>(
                        title: Text(S.current.follow_system),
                        visualDensity: VisualDensity.compact,
                        value: ThemeMode.system.index,
                        contentPadding: AppStyle.edgeInsetsH12,
                        groupValue: themeMode.index,
                        onChanged: (e) {
                          appSettingCubit.changeThemeMode(
                              themeMode: ThemeMode.system);
                        },
                      ),
                      RadioListTile<int>(
                        title: Text(S.current.light_mode),
                        visualDensity: VisualDensity.compact,
                        value: ThemeMode.light.index,
                        contentPadding: AppStyle.edgeInsetsH12,
                        groupValue: themeMode.index,
                        onChanged: (e) {
                          appSettingCubit.changeThemeMode(
                              themeMode: ThemeMode.light);
                        },
                      ),
                      RadioListTile<int>(
                        title: Text(S.current.dark_mode),
                        visualDensity: VisualDensity.compact,
                        value: ThemeMode.dark.index,
                        contentPadding: AppStyle.edgeInsetsH12,
                        groupValue: themeMode.index,
                        onChanged: (e) {
                          appSettingCubit.changeThemeMode(
                              themeMode: ThemeMode.dark);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            Padding(
              padding: AppStyle.edgeInsetsA12,
              child: Text(S.current.language),
            ),
            BlocSelector<AppSettingCubit, AppSettingState, Language>(
              selector: (state) {
                return state.language;
              },
              builder: (context, language) {
                return SettingsCard(
                  child: Column(
                    children: [
                      RadioListTile<Language>(
                        title: Text(S.current.english),
                        value: Language.english,
                        groupValue: language,
                        onChanged: (e) {
                          appSettingCubit.changeLanguage(language: e!);
                        },
                      ),
                      RadioListTile<Language>(
                        title: Text(S.current.vietnamese),
                        value: Language.vietnamese,
                        groupValue: language,
                        onChanged: (e) {
                          appSettingCubit.changeLanguage(language: e!);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            Padding(
              padding: AppStyle.edgeInsetsA12,
              child: Text(
                S.current.theme_color,
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
                          appSettingCubit.changeDynamicColor(isDynamicColor: e);
                        },
                      ),
                      if (!state.isDynamicColor) AppStyle.divider,
                      if (!state.isDynamicColor)
                        Padding(
                          padding: AppStyle.edgeInsetsA12,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: Constants.primaryColorsHex.map(
                              (e) {
                                final color = Color(int.parse('0xff$e'));
                                return GestureDetector(
                                  onTap: () {
                                    appSettingCubit.changePrimaryColor(
                                        color: color, hexColor: e);
                                  },
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: AppStyle.radius4,
                                      border: Border.all(
                                        color:
                                            Colors.grey.withValues(alpha: 0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.check,
                                        color: state.primaryColor == color
                                            ? Colors.white
                                            : Colors.transparent,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ));
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/setting/app_setting_cubit.dart';
import 'package:toeic_desktop/common/utils/constants.dart';
import 'package:toeic_desktop/common/utils/utils.dart';
import 'package:toeic_desktop/data/models/enums/language.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_style.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';
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
              child: Text(
                S.current.display_theme,
                style: theme.textTheme.bodyMedium,
              ),
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
                        title: Text(
                          S.current.follow_system,
                          style: theme.textTheme.bodyMedium,
                        ),
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
                        title: Text(
                          S.current.light_mode,
                          style: theme.textTheme.bodyMedium,
                        ),
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
                        title: Text(
                          S.current.dark_mode,
                          style: theme.textTheme.bodyMedium,
                        ),
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
              child: Text(
                S.current.language,
                style: theme.textTheme.bodyMedium,
              ),
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
                        title: Text(
                          S.current.english,
                          style: theme.textTheme.bodyMedium,
                        ),
                        value: Language.english,
                        groupValue: language,
                        onChanged: (e) {
                          appSettingCubit.changeLanguage(language: e!);
                        },
                      ),
                      RadioListTile<Language>(
                        title: Text(
                          S.current.vietnamese,
                          style: theme.textTheme.bodyMedium,
                        ),
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
                style: theme.textTheme.bodyMedium,
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
            Padding(
              padding: AppStyle.edgeInsetsA12,
              child: Text(
                S.current.reminder_word_after,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            BlocBuilder<AppSettingCubit, AppSettingState>(
              buildWhen: (previous, current) {
                return previous.isReminderWordAfterTime !=
                        current.isReminderWordAfterTime ||
                    previous.reminderWordAfterTime !=
                        current.reminderWordAfterTime;
              },
              builder: (context, state) {
                return SettingsCard(
                  child: Column(
                    children: [
                      SettingsSwitch(
                        value: state.isReminderWordAfterTime,
                        title: state.reminderWordAfterTime,
                        onChanged: (val) {
                          appSettingCubit.changeIsReminderWordAfterTime(
                              isReminderWordAfterTime: val);
                        },
                      ),
                      if (state.isReminderWordAfterTime) ...[
                        AppStyle.divider,
                        Container(
                          margin: AppStyle.edgeInsetsA12,
                          child: CustomButton(
                            width: double.infinity,
                            onPressed: () => _showReminderWordAfterTimePicker(
                                context, state.reminderWordAfterTime),
                            child: Text(
                              S.current.set_time,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
            Padding(
              padding: AppStyle.edgeInsetsA12,
              child: Text(
                S.current.daily_reminder,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            BlocBuilder<AppSettingCubit, AppSettingState>(
              buildWhen: (previous, current) {
                return previous.isDailyReminder != current.isDailyReminder ||
                    previous.dailyReminderTime != current.dailyReminderTime;
              },
              builder: (context, state) {
                return SettingsCard(
                  child: Column(
                    children: [
                      SettingsSwitch(
                        value: state.isDailyReminder,
                        title: state.dailyReminderTime ??
                            Utils.getTimeHHMm(DateTime.now()),
                        onChanged: (val) {
                          appSettingCubit.changeDailyReminder(
                              isDailyReminder: val);
                        },
                      ),
                      if (state.isDailyReminder) ...[
                        AppStyle.divider,
                        Container(
                          margin: AppStyle.edgeInsetsA12,
                          child: CustomButton(
                            width: double.infinity,
                            onPressed: () => _showTimePicker(
                                context,
                                state.dailyReminderTime ??
                                    Utils.getTimeHHMm(DateTime.now())),
                            child: Text(
                              S.current.set_time,
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                );
              },
            ),
            const SizedBox(
              height: 24,
            )
          ],
        ));
  }

  void _showTimePicker(BuildContext context, String currentTime) {
    final timeParts = currentTime.split(':');
    final initialTime = DateTime(
      0,
      1,
      1,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );
    DateTime selectedTime = initialTime;

    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SizedBox(
          height: 350,
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: true,
                  initialDateTime: initialTime,
                  onDateTimeChanged: (DateTime dateTime) {
                    selectedTime = dateTime;
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      GoRouter.of(ctx).pop();
                    },
                    child: Text(S.current.cancel),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () {
                      final formatted = Utils.getTimeHHMm(selectedTime);
                      appSettingCubit.changeDailyReminderTime(
                        dailyReminderTime: formatted,
                      );
                      GoRouter.of(ctx).pop();
                    },
                    child: Text(S.current.save_button),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showReminderWordAfterTimePicker(
      BuildContext context, String selectedTime) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: 400,
              child: Column(
                children: [
                  SizedBox(
                    height: 350,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      itemCount: Constants.reminderWordAfterTimes.length,
                      itemBuilder: (context, index) {
                        final isSelected = selectedTime ==
                            Constants.reminderWordAfterTimes[index];
                        return ListTile(
                          selected: isSelected,
                          title: Text(
                            Constants.reminderWordAfterTimes[index],
                            style: theme.textTheme.bodyMedium,
                          ),
                          trailing: isSelected ? const Icon(Icons.check) : null,
                          onTap: () {
                            setState(() {
                              selectedTime =
                                  Constants.reminderWordAfterTimes[index];
                            });
                          },
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          GoRouter.of(ctx).pop();
                        },
                        child: Text(S.current.cancel),
                      ),
                      const SizedBox(width: 16),
                      TextButton(
                        onPressed: () {
                          appSettingCubit.changeReminderWordAfterTime(
                            reminderWordAfterTime: selectedTime,
                          );
                          GoRouter.of(ctx).pop();
                        },
                        child: Text(S.current.save_button),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

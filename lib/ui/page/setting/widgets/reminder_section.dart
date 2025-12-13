import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/global_blocs/setting/app_setting_cubit.dart';
import 'package:toeic_desktop/common/utils/constants.dart';
import 'package:toeic_desktop/common/utils/utils.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/app_style.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';
import 'package:toeic_desktop/ui/page/setting/widgets/setting_card.dart';
import 'package:toeic_desktop/ui/page/setting/widgets/settting_switch.dart';

class ReminderSection extends StatelessWidget {
  const ReminderSection({super.key});

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
            S.current.reminder_word_after,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
            ),
          ),
        ),
        BlocBuilder<AppSettingCubit, AppSettingState>(
          buildWhen: (previous, current) {
            return previous.isReminderWordAfterTime !=
                    current.isReminderWordAfterTime ||
                previous.reminderWordAfterTime != current.reminderWordAfterTime;
          },
          builder: (context, state) {
            return SettingsCard(
              child: Column(
                children: [
                  SettingsSwitch(
                    value: state.isReminderWordAfterTime,
                    title: state.reminderWordAfterTime,
                    onChanged: (val) {
                      cubit.changeIsReminderWordAfterTime(
                          isReminderWordAfterTime: val);
                    },
                  ),
                  if (state.isReminderWordAfterTime) ...[
                    AppStyle.divider,
                    Container(
                      margin: AppStyle.edgeInsetsA12,
                      width: double.infinity,
                      child: CustomButton(
                        width: double.infinity,
                        onPressed: () => _showReminderWordAfterTimePicker(
                            context, cubit, state.reminderWordAfterTime),
                        child: Text(S.current.set_time),
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
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
            ),
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
                      cubit.changeDailyReminder(isDailyReminder: val);
                    },
                  ),
                  if (state.isDailyReminder) ...[
                    AppStyle.divider,
                    Container(
                      margin: AppStyle.edgeInsetsA12,
                      width: double.infinity,
                      child: CustomButton(
                        width: double.infinity,
                        onPressed: () => _showTimePicker(
                            context,
                            cubit,
                            state.dailyReminderTime ??
                                Utils.getTimeHHMm(DateTime.now())),
                        child: Text(S.current.set_time),
                      ),
                    ),
                  ]
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _showTimePicker(
      BuildContext context, AppSettingCubit cubit, String currentTime) {
    final timeParts = currentTime.split(':');
    final initialTime = DateTime(
      0,
      1,
      1,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );
    DateTime selectedTime = initialTime;

    Utils.showModalBottomSheetForm(
      context: context,
      title: S.current.set_time,
      child: Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                use24hFormat: true,
                initialDateTime: initialTime,
                onDateTimeChanged: (DateTime dateTime) {
                  selectedTime = dateTime;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomButton(
                width: double.infinity,
                onPressed: () {
                  final formatted = Utils.getTimeHHMm(selectedTime);
                  cubit.changeDailyReminderTime(
                    dailyReminderTime: formatted,
                  );
                  GoRouter.of(context).pop();
                },
                child: Text(S.current.save_button),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReminderWordAfterTimePicker(
      BuildContext context, AppSettingCubit cubit, String selectedTime) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    Utils.showModalBottomSheetForm(
      context: context,
      title: S.current.set_time,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.5),
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shrinkWrap: true,
                    itemCount: Constants.reminderWordAfterTimes.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 16, endIndent: 16),
                    itemBuilder: (context, index) {
                      final time = Constants.reminderWordAfterTimes[index];
                      final isSelected = selectedTime == time;
                      return ListTile(
                        selected: isSelected,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        title: Text(
                          time,
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected ? colorScheme.primary : null,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check, color: colorScheme.primary)
                            : null,
                        onTap: () {
                          setState(() {
                            selectedTime = time;
                          });
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomButton(
                    width: double.infinity,
                    onPressed: () {
                      cubit.changeReminderWordAfterTime(
                        reminderWordAfterTime: selectedTime,
                      );
                      GoRouter.of(context).pop();
                    },
                    child: Text(S.current.save_button),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

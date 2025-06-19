part of 'app_setting_cubit.dart';

class AppSettingState extends Equatable {
  final Language language;
  final ThemeMode themeMode;
  final Color primaryColor;
  final bool isDynamicColor;
  final bool isDailyReminder;
  final String dailyReminderTime;

  const AppSettingState({
    this.language = AppConfigs.defaultLanguage,
    this.themeMode = ThemeMode.system,
    this.primaryColor = const Color(0xff26A69A),
    this.isDynamicColor = false,
    this.isDailyReminder = false,
    this.dailyReminderTime = '10:00',
  });

  @override
  List<Object?> get props => [
        language,
        themeMode,
        primaryColor,
        isDynamicColor,
        isDailyReminder,
        dailyReminderTime,
      ];

  AppSettingState copyWith({
    Language? language,
    ThemeMode? themeMode,
    Color? primaryColor,
    bool? isDynamicColor,
    bool? isDailyReminder,
    String? dailyReminderTime,
  }) {
    return AppSettingState(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      primaryColor: primaryColor ?? this.primaryColor,
      isDynamicColor: isDynamicColor ?? this.isDynamicColor,
      isDailyReminder: isDailyReminder ?? this.isDailyReminder,
      dailyReminderTime: dailyReminderTime ?? this.dailyReminderTime,
    );
  }
}

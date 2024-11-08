part of 'app_setting_cubit.dart';

class AppSettingState extends Equatable {
  final Language language;
  final ThemeMode themeMode;
  final StartWith startWith;
  final bool isUseBiometric;

  const AppSettingState({
    this.language = AppConfigs.defaultLanguage,
    this.themeMode = ThemeMode.system,
    this.startWith = StartWith.home,
    this.isUseBiometric = false,
  });

  @override
  List<Object?> get props => [
        language,
        themeMode,
        startWith,
        isUseBiometric,
      ];

  AppSettingState copyWith({
    Language? language,
    ThemeMode? themeMode,
    StartWith? startWith,
    bool? isUseBiometric,
  }) {
    return AppSettingState(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      startWith: startWith ?? this.startWith,
      isUseBiometric: isUseBiometric ?? this.isUseBiometric,
    );
  }
}

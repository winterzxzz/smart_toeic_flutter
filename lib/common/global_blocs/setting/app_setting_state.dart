part of 'app_setting_cubit.dart';

class AppSettingState extends Equatable {
  final Language language;
  final ThemeMode themeMode;
  final bool isUseBiometric;

  const AppSettingState({
    this.language = AppConfigs.defaultLanguage,
    this.themeMode = ThemeMode.system,
    this.isUseBiometric = false,
  });

  @override
  List<Object?> get props => [
        language,
        themeMode,
        isUseBiometric,
      ];

  AppSettingState copyWith({
    Language? language,
    ThemeMode? themeMode,
    bool? isUseBiometric,
  }) {
    return AppSettingState(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      isUseBiometric: isUseBiometric ?? this.isUseBiometric,
    );
  }
}

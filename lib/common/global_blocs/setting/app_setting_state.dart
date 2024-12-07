part of 'app_setting_cubit.dart';

class AppSettingState extends Equatable {
  final Language language;
  final ThemeMode themeMode;
  final bool isUseBiometric;
  final Size windowSize;
  final List<String> navigationHistory;
  final String currentPath;

  const AppSettingState({
    this.language = AppConfigs.defaultLanguage,
    this.themeMode = ThemeMode.system,
    this.isUseBiometric = false,
    this.windowSize = const Size(1280, 720),
    this.navigationHistory = const [],
    this.currentPath = '',
  });

  @override
  List<Object?> get props => [
        language,
        themeMode,
        isUseBiometric,
        windowSize,
        navigationHistory,
        currentPath,
      ];

  AppSettingState copyWith({
    Language? language,
    ThemeMode? themeMode,
    bool? isUseBiometric,
    Size? windowSize,
    List<String>? navigationHistory,
    String? currentPath,
  }) {
    return AppSettingState(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      isUseBiometric: isUseBiometric ?? this.isUseBiometric,
      windowSize: windowSize ?? this.windowSize,
      navigationHistory: navigationHistory ?? this.navigationHistory,
      currentPath: currentPath ?? this.currentPath,
    );
  }
}

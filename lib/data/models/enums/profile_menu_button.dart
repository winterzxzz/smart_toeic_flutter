import 'package:toeic_desktop/language/generated/l10n.dart';

enum ProfileMenuButton {
  settings('settings'),
  targetScore('targetScore'),
  history('history'),
  analysis('analysis'),
  logout('logout');

  final String value;

  const ProfileMenuButton(this.value);

  String getTitle() {
    switch (this) {
      case ProfileMenuButton.settings:
        return S.current.settings;
      case ProfileMenuButton.targetScore:
        return S.current.target_score;
      case ProfileMenuButton.history:
        return S.current.history;
      case ProfileMenuButton.analysis:
        return S.current.analysis;
      case ProfileMenuButton.logout:
        return S.current.logout;
    }
  }
}

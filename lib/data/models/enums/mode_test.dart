

import 'package:toeic_desktop/language/generated/l10n.dart';

enum ModeTest {
  practice,
  full,
}

extension ModeTestExtension on ModeTest {
  String get name {
    switch (this) {
      case ModeTest.practice:
        return S.current.practice;
      case ModeTest.full:
        return S.current.full;
    }
  }
}




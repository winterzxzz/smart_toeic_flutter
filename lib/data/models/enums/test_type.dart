import 'package:toeic_desktop/language/generated/l10n.dart';

enum TestType {
  all,
  exam,
  miniExam,
}

extension TestTypeExtension on TestType {
  String get name {
    switch (this) {
      case TestType.all:
        return S.current.all;
      case TestType.exam:
        return S.current.exam;
      case TestType.miniExam:
        return S.current.mini_exam;
    }
  }
}

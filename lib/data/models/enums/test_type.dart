enum TestType {
  all,
  exam,
  miniExam,
}

extension TestTypeExtension on TestType {
  String get name {
    switch (this) {
      case TestType.all:
        return 'All';
      case TestType.exam:
        return 'Exam';
      case TestType.miniExam:
        return 'Mini-Exam';
    }
  }
}

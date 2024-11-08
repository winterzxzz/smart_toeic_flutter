// word, excel, file
enum ProcessOcrStatus {
  word,
  excel,
  file,
}
extension ProcessOcrStatusExtension on ProcessOcrStatus {
  String get name {
    switch (this) {
      case ProcessOcrStatus.word:
        return 'word';
      case ProcessOcrStatus.excel:
        return 'excel';
      case ProcessOcrStatus.file:
        return 'file';
      default:
        return 'word';
    }
  }
}

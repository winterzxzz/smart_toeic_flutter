enum OcrReturnType {
  word,
  excel,
  metadata,
  pdfSearchable,
}

extension OcrReturnTypeExtension on OcrReturnType {
  String get name {
    switch (this) {
      case OcrReturnType.word:
        return 'word';
      case OcrReturnType.excel:
        return 'excel';
      case OcrReturnType.metadata:
        return 'metadata';
      case OcrReturnType.pdfSearchable:
        return 'pdf_searchable';
      default:
        return 'pdf_searchable';
    }
  }
}

enum ResourceType { file, folder }

extension ResourceTypeExtension on ResourceType {
  String get name {
    switch (this) {
      case ResourceType.file:
        return 'file';
      case ResourceType.folder:
        return 'folder';
      default:
        return 'file';
    }
  }
}

import 'dart:io';

enum FileType {
  image,
  file,
  folder,
  unknown,
}

class FileModelItem {
  final String name;
  final FileType type;
  final FileSystemEntity file;

  FileModelItem({
    required this.name,
    required this.file,
    required this.type,
  });
}

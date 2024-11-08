import 'package:toeic_desktop/ui/common/app_images.dart';

class FileModalItem {
  final String icon;
  final String title;
  const FileModalItem(this.icon, this.title);
}

List<FileModalItem> fileModalItems = [
  const FileModalItem(AppImages.icShare, 'Share'),
  const FileModalItem(AppImages.icLock, 'Lock'),
  const FileModalItem(AppImages.icAskAi, 'ASk AI'),
  const FileModalItem(AppImages.icConvert, 'Convert'),
  const FileModalItem(AppImages.icRename, 'Rename'),
  // const FileModalItem(AppImages.icCopy, 'Copy'),
  const FileModalItem(AppImages.icDelete, 'Delete'),
];

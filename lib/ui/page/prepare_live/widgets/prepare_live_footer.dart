import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';

class PrepareLiveFooter extends StatefulWidget {
  const PrepareLiveFooter(
      {super.key,
      required this.onSelectImage,
      required this.onEnterTitle,
      required this.onSelectBroadcastTarget,
      required this.onStartLive});

  final Function(ImageSource) onSelectImage;
  final Function(String) onEnterTitle;
  final Function() onSelectBroadcastTarget;
  final Function() onStartLive;

  @override
  State<PrepareLiveFooter> createState() => _PrepareLiveFooterState();
}

class _PrepareLiveFooterState extends State<PrepareLiveFooter> {
  @override
  Widget build(BuildContext context) {
    final width = context.sizze.width;
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: width * 0.7,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildActionButton(
                  icon: Icons.people,
                  label: 'Participants',
                  isRequired: true,
                  onTap: () => widget.onSelectBroadcastTarget(),
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  icon: Icons.edit,
                  label: 'Enter Title',
                  isRequired: false,
                  onTap: () => widget.onEnterTitle(''),
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  icon: Icons.image,
                  label: 'Set Thumbnail',
                  isRequired: true,
                  onTap: () => _setThumbnail(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          CustomButton(
            child: const Text('Start Live'),
            onPressed: () => widget.onStartLive(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool isRequired,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Required',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _setThumbnail() async {
    final textTheme = context.textTheme;
    // allow user to select image from gallery or capture from camera
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: Text('Select Image',
                style: textTheme.bodyMedium?.copyWith(color: Colors.black)),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  widget.onSelectImage(ImageSource.gallery);
                },
                child: Text('Gallery',
                    style: textTheme.bodyMedium?.copyWith(color: Colors.black)),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  widget.onSelectImage(ImageSource.camera);
                },
                child: Text('Camera',
                    style: textTheme.bodyMedium?.copyWith(color: Colors.black)),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                GoRouter.of(context).pop();
              },
              child: Text('Cancel',
                  style: textTheme.bodyMedium?.copyWith(color: Colors.black)),
            ),
          );
        });
  }
}

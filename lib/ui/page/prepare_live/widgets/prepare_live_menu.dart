import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/page/live_stream/live_stream_state.dart';

class PrepareLiveMenu extends StatefulWidget {
  const PrepareLiveMenu({
    super.key,
    required this.isOpenMic,
    required this.isOpenCamera,
    required this.onSwitchCamera,
    required this.onToggleCamera,
    required this.onToggleMic,
    this.showFooter,
    this.isScreenShare,
    this.onToggleScreenShare,
    this.onToggleShowFooter,
    this.onToggleGridRemote,
    this.isShowGridRemote,
  });

  final bool isOpenMic;
  final bool isOpenCamera;
  final bool? isScreenShare;
  final bool? isShowGridRemote;
  final LiveStreamShowFooter? showFooter;
  final Function() onSwitchCamera;
  final Function() onToggleCamera;
  final Function() onToggleMic;
  final Function()? onToggleScreenShare;
  final Function()? onToggleShowFooter;
  final Function()? onToggleGridRemote;

  @override
  State<PrepareLiveMenu> createState() => _PrepareLiveMenuState();
}

class _PrepareLiveMenuState extends State<PrepareLiveMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          IconButton(
              onPressed: () {
                widget.onToggleMic();
              },
              icon: Icon(widget.isOpenMic ? Icons.mic : Icons.mic_off,
                  color: Colors.white)),
          const SizedBox(height: 10),
          IconButton(
              onPressed: () {
                widget.onToggleCamera();
              },
              icon: Icon(
                  widget.isOpenCamera ? Icons.camera : Icons.no_photography,
                  color: Colors.white)),
          const SizedBox(height: 10),
          IconButton(
              onPressed: () {
                widget.onSwitchCamera();
              },
              icon: const Icon(Icons.camera_enhance, color: Colors.white)),
          const SizedBox(height: 10),
          IconButton(
              onPressed: () {
                widget.onToggleScreenShare?.call();
              },
              icon: Icon(
                  widget.isScreenShare ?? false
                      ? Icons.screen_share
                      : Icons.screen_lock_landscape,
                  color: Colors.white)),
          const SizedBox(height: 10),
          IconButton(
              onPressed: () {
                widget.onToggleShowFooter?.call();
              },
              icon: Icon(
                  widget.showFooter == LiveStreamShowFooter.comment
                      ? Icons.comment
                      : Icons.text_snippet,
                  color: Colors.white)),
          const SizedBox(height: 10),
          IconButton(
              onPressed: () {
                widget.onToggleGridRemote?.call();
              },
              icon: Icon(
                  widget.isShowGridRemote ?? false
                      ? Icons.grid_view
                      : Icons.grid_off,
                  color: Colors.white)),
        ],
      ),
    );
  }
}

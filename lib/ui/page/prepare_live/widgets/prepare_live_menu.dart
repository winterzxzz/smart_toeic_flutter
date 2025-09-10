import 'package:flutter/material.dart';

class PrepareLiveMenu extends StatefulWidget {
  const PrepareLiveMenu({
    super.key,
    required this.isOpenMic,
    required this.isOpenCamera,
    required this.onSwitchCamera,
    required this.onToggleCamera,
    required this.onToggleMic,
  });

  final bool isOpenMic;
  final bool isOpenCamera;
  final Function() onSwitchCamera;
  final Function() onToggleCamera;
  final Function() onToggleMic;

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
              onPressed: () {},
              icon: const Icon(Icons.settings, color: Colors.white)),
        ],
      ),
    );
  }
}

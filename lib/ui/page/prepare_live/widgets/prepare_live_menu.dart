import 'package:flutter/material.dart';

class PrepareLiveMenu extends StatefulWidget {
  const PrepareLiveMenu({super.key});

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
              onPressed: () {},
              icon: const Icon(Icons.mic, color: Colors.white)),
          const SizedBox(height: 10),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.camera, color: Colors.white)),
          const SizedBox(height: 10),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings, color: Colors.white)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/page/prepare_live/widgets/prepare_live_footer.dart';
import 'package:toeic_desktop/ui/page/prepare_live/widgets/prepare_live_header.dart';

class PrepareLivePage extends StatefulWidget {
  const PrepareLivePage({super.key});

  @override
  State<PrepareLivePage> createState() => _PrepareLivePageState();
}

class _PrepareLivePageState extends State<PrepareLivePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black,
                alignment: Alignment.center,
                child: const Text('Preview Camera1'),
              ),
              const Positioned(
                  top: 0, left: 0, right: 0, child: PrepareLiveHeader()),
              const Positioned(
                  bottom: 0, left: 0, right: 0, child: PrepareLiveFooter()),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/utils/permission_utils.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/page/prepare_live/prepare_live_cubit.dart';
import 'package:toeic_desktop/ui/page/prepare_live/prepare_live_state.dart';
import 'package:toeic_desktop/ui/page/prepare_live/widgets/prepare_live_footer.dart';
import 'package:toeic_desktop/ui/page/prepare_live/widgets/prepare_live_header.dart';
import 'package:toeic_desktop/ui/page/prepare_live/widgets/prepare_live_menu.dart';

class PrepareLivePage extends StatelessWidget {
  const PrepareLivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<PrepareLiveCubit>(),
      child: const Page(),
    );
  }
}

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  late final PrepareLiveCubit _prepareLiveCubit;

  @override
  void initState() {
    super.initState();
    _prepareLiveCubit = BlocProvider.of<PrepareLiveCubit>(context);
    _requestPermissions();
  }

  void _requestPermissions() async {
    final isCameraGranted =
        await PermissionUtils.requestCameraPermission(context);
    if (!mounted) return;
    final isMicGranted = await PermissionUtils.requestMicPermission(context);
    if (!mounted) return;
    if (isCameraGranted && isMicGranted) {
      _prepareLiveCubit.initialize();
    } else {
      debugPrint('Winter-Camera or Mic permission denied');
    }
  }

  @override
  void dispose() {
    _prepareLiveCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = context.sizze.height;
    return BlocBuilder<PrepareLiveCubit, PrepareLiveState>(
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            body: Stack(
              children: [
                // Full screen video background
                Positioned.fill(
                  child: !state.isInitialized
                      ? Container(
                          color: Colors.black,
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Initializing camera...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : state.isOpenCamera
                          ? FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: _prepareLiveCubit.cameraController.value
                                        .previewSize?.height ??
                                    1,
                                height: _prepareLiveCubit.cameraController.value
                                        .previewSize?.width ??
                                    1,
                                child: CameraPreview(
                                    _prepareLiveCubit.cameraController),
                              ),
                            )
                          : Container(
                              color: Colors.black,
                              child: const Center(
                                child: Text(
                                  'Camera is paused',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                ),
                // Header overlay
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: PrepareLiveHeader(),
                  ),
                ),
                // Footer overlay
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: PrepareLiveFooter(
                      onSelectImage: _prepareLiveCubit.selectImageFrom,
                      onEnterTitle: (title) {},
                      onSelectBroadcastTarget: () {},
                      onStartLive: () {},
                    ),
                  ),
                ),

                Positioned(
                  top: height * 0.15,
                  right: 10,
                  child: SafeArea(
                    child: PrepareLiveMenu(
                      isOpenMic: state.isOpenMic,
                      isOpenCamera: state.isOpenCamera,
                      onSwitchCamera: _prepareLiveCubit.switchCamera,
                      onToggleCamera: _prepareLiveCubit.toggleCamera,
                      onToggleMic: _prepareLiveCubit.toggleMic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

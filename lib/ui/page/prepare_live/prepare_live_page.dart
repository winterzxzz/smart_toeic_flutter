import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/common/utils/permission_utils.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
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

  Color _getCountdownColor(int countdown) {
    switch (countdown) {
      case 5:
      case 4:
        return Colors.green;
      case 3:
      case 2:
        return Colors.orange;
      case 1:
        return Colors.red;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = context.sizze.height;
    return BlocConsumer<PrepareLiveCubit, PrepareLiveState>(
      listenWhen: (previous, current) =>
          previous.loadStatus != current.loadStatus,
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.loading) {
          AppNavigator(context: context)
              .showLoadingOverlay(message: 'Preparing live...');
        } else {
          if (state.loadStatus == LoadStatus.success &&
              state.liveArgs != null) {
            AppNavigator(context: context).pushReplacementNamed(
                AppRouter.liveStream,
                extra: {'liveArgs': state.liveArgs});
          }
          AppNavigator(context: context).hideLoadingOverlay();
        }
      },
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
                const Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: PrepareLiveFooter(),
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

                // Countdown overlay
                if (state.isCountDown)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () {
                        _prepareLiveCubit.cancelCountDownTimer();
                      },
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.8),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedScale(
                                scale: state.countDown > 0 ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 300),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          _getCountdownColor(state.countDown),
                                      width: 6,
                                    ),
                                    color: _getCountdownColor(state.countDown)
                                        .withValues(alpha: 0.1),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            _getCountdownColor(state.countDown)
                                                .withValues(alpha: 0.5),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: TweenAnimationBuilder<double>(
                                      key: ValueKey(state.countDown),
                                      duration:
                                          const Duration(milliseconds: 800),
                                      tween:
                                          Tween<double>(begin: 0.5, end: 1.0),
                                      builder: (context, scale, child) {
                                        return Transform.scale(
                                          scale: scale,
                                          child: Text(
                                            '${state.countDown}',
                                            style: TextStyle(
                                              fontSize: 80,
                                              fontWeight: FontWeight.bold,
                                              color: _getCountdownColor(
                                                  state.countDown),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              AnimatedOpacity(
                                opacity: state.countDown > 0 ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 300),
                                child: const Text(
                                  'Get Ready!',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              AnimatedOpacity(
                                opacity: state.countDown > 0 ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 300),
                                child: const Text(
                                  'Live stream will start soon, tap to cancel',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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

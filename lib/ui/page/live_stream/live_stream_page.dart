import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:toeic_desktop/data/models/ui_models/rooms/live_args.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';
import 'package:toeic_desktop/ui/page/live_stream/live_stream_cubit.dart';
import 'package:toeic_desktop/ui/page/live_stream/live_stream_state.dart';
import 'package:toeic_desktop/ui/page/prepare_live/widgets/prepare_live_header.dart';
import 'package:toeic_desktop/ui/page/prepare_live/widgets/prepare_live_menu.dart';

class LiveStreamPage extends StatelessWidget {
  final LiveArgs liveArgs;
  const LiveStreamPage({super.key, required this.liveArgs});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LiveStreamCubit(liveArgs)..initialize(liveArgs),
      child: Page(liveArgs: liveArgs),
    );
  }
}

class Page extends StatefulWidget {
  final LiveArgs liveArgs;
  const Page({
    super.key,
    required this.liveArgs,
  });

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  late final LiveStreamCubit _liveStreamCubit;

  @override
  void initState() {
    super.initState();
    _liveStreamCubit = BlocProvider.of<LiveStreamCubit>(context);
    _liveStreamCubit.setupListener();
  }

  @override
  Widget build(BuildContext context) {
    final height = context.sizze.height;
    return BlocBuilder<LiveStreamCubit, LiveStreamState>(
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                Positioned.fill(
                  child: state.isOpenCamera
                      ? VideoTrackRenderer(
                          _liveStreamCubit
                              .liveArgs
                              .room
                              .localParticipant
                              ?.videoTrackPublications
                              .firstOrNull
                              ?.track as VideoTrack,
                          fit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                        )
                      : Container(
                          color: Colors.black,
                          child: state.isOpenCamera
                              ? const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      LoadingCircle(),
                                      SizedBox(height: 16),
                                      Text(
                                        'Starting camera...',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const Center(
                                  child: Icon(
                                    Icons.videocam_off,
                                    color: Colors.white54,
                                    size: 64,
                                  ),
                                ),
                        ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: PrepareLiveHeader(
                      onClose: () async {
                        _liveStreamCubit.closeRoom().then((value) {
                          if (context.mounted) {
                            GoRouter.of(context).pop();
                          }
                        });
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Text(
                      state.currentTranscription,
                      style: context.textTheme.bodySmall
                          ?.copyWith(color: Colors.white),
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
                        onToggleMic: _liveStreamCubit.toggleMic,
                        onSwitchCamera: _liveStreamCubit.flipCamera,
                        onToggleCamera: _liveStreamCubit.toggleCamera),
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

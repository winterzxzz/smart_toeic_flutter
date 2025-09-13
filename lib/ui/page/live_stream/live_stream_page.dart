import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/ui_models/rooms/live_args.dart';
import 'package:toeic_desktop/data/network/repositories/room_repository.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';
import 'package:toeic_desktop/ui/page/live_stream/live_stream_cubit.dart';
import 'package:toeic_desktop/ui/page/live_stream/live_stream_state.dart';
import 'package:toeic_desktop/ui/page/live_stream/widgets/grid_remotr_track.dart';
import 'package:toeic_desktop/ui/page/live_stream/widgets/live_stream_footer.dart';
import 'package:toeic_desktop/ui/page/live_stream/widgets/live_stream_transcription_footer.dart';
import 'package:toeic_desktop/ui/page/prepare_live/widgets/prepare_live_header.dart';
import 'package:toeic_desktop/ui/page/prepare_live/widgets/prepare_live_menu.dart';

class LiveStreamPage extends StatelessWidget {
  final LiveArgs liveArgs;
  const LiveStreamPage({super.key, required this.liveArgs});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LiveStreamCubit(injector<RoomRepository>(), liveArgs: liveArgs)
            ..initialize(liveArgs),
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
    return BlocConsumer<LiveStreamCubit, LiveStreamState>(
      listenWhen: (previous, current) =>
          previous.loadStatus != current.loadStatus,
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.loading) {
          AppNavigator(context: context)
              .showLoadingOverlay(message: 'Closing live...');
        } else {
          AppNavigator(context: context).hideLoadingOverlay();
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                Positioned.fill(
                  child: state.isOpenCamera && state.isVideoTrackReady
                      ? VideoTrackRenderer(
                          widget
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
                          child: state.isOpenCamera && !state.isVideoTrackReady
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
                      viewCount: state.numberUser,
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
                    child: state.showFooter == LiveStreamShowFooter.comment
                        ? const LiveStreamFooter()
                        : LiveStreamTranscriptionFooter(
                            transcription: state.currentTranscription),
                  ),
                ),
                // Grid Remote Tracks
                if (state.isShowGridRemoteTracks)
                  Positioned(
                    top: height * 0.15,
                    left: 10,
                    right: 10,
                    bottom: height * 0.2,
                    child: SafeArea(
                      child: GridRemoteTrack(
                        remoteParticipantTracks: state.remoteParticipantTracks,
                        isVisible: state.isShowGridRemoteTracks,
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
                      isScreenShare: state.isScreenShare,
                      onToggleScreenShare: _liveStreamCubit.shareScreen,
                      onSwitchCamera: _liveStreamCubit.flipCamera,
                      onToggleCamera: _liveStreamCubit.toggleCamera,
                      showFooter: state.showFooter,
                      onToggleShowFooter: _liveStreamCubit.toggleShowFooter,
                      onToggleGridRemote:
                          _liveStreamCubit.toggleShowGridRemoteTracks,
                      isShowGridRemote: state.isShowGridRemoteTracks,
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

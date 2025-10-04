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

  Widget _buildLocalVideoRenderer(LiveStreamState state) {
    debugPrint('=== LOCAL VIDEO RENDERER DEBUG ===');
    debugPrint('isOpenCamera: ${state.isOpenCamera}');
    debugPrint('isVideoTrackReady: ${state.isVideoTrackReady}');
    debugPrint(
        'localParticipantTracks count: ${state.localParticipantTracks.length}');

    // If camera is not open, show camera off state
    if (!state.isOpenCamera) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Icon(
            Icons.videocam_off,
            color: Colors.white54,
            size: 64,
          ),
        ),
      );
    }

    // If video track is not ready, show loading state
    if (!state.isVideoTrackReady) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Starting camera...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    // Try to find a video track from local participant tracks
    VideoTrack? videoTrack;

    // First try: Use state-managed tracks
    if (state.localParticipantTracks.isNotEmpty) {
      for (var track in state.localParticipantTracks) {
        if (track.videoTrack != null && track.videoTrack is VideoTrack) {
          videoTrack = track.videoTrack as VideoTrack;
          debugPrint('Using state-managed track: ${videoTrack.runtimeType}');
          break;
        }
      }
    }

    // Fallback: Use direct room access
    if (videoTrack == null) {
      final directVideoTrack = widget
          .liveArgs.room.localParticipant?.videoTrackPublications
          .where((pub) => pub.track is VideoTrack)
          .firstOrNull
          ?.track;

      if (directVideoTrack is VideoTrack) {
        videoTrack = directVideoTrack;
        debugPrint('Using direct room track: ${videoTrack.runtimeType}');
      }
    }

    // If we found a video track, render it
    if (videoTrack != null) {
      return _buildVideoRenderer(videoTrack);
    }

    // No video track found - show error state
    debugPrint('No video track found - showing error state');
    return Container(
      color: Colors.black,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'Camera Error',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Text(
              'Unable to start camera',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoRenderer(VideoTrack videoTrack) {
    debugPrint('Building video renderer for: ${videoTrack.runtimeType}');

    try {
      return VideoTrackRenderer(
        videoTrack,
        fit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
      );
    } catch (e) {
      debugPrint('VideoTrackRenderer failed: $e');
      return Container(
        color: Colors.red,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.white, size: 48),
              const SizedBox(height: 16),
              const Text(
                'Video Render Error',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                'Error: $e',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
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
          GoRouter.of(context).pop();
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                // Video background - always render the video renderer
                Positioned.fill(
                  child: _buildLocalVideoRenderer(state),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: PrepareLiveHeader(
                      viewCount: state.numberUser,
                      onClose: () {
                        _liveStreamCubit.closeRoom();
                      },
                    ),
                  ),
                ),
                // Footer - always show based on state
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: state.showFooter == LiveStreamShowFooter.comment
                        ? const LiveStreamFooter()
                        : state.currentTranscription.isNotEmpty
                            ? LiveStreamTranscriptionFooter(
                                transcription: state.currentTranscription,
                              )
                            : const SizedBox.shrink(),
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
                // Debug overlay - remove this in production
                if (true) // Set to false to hide debug info
                  Positioned(
                    top: 100,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Debug Info:',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Camera: ${state.isOpenCamera}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10),
                          ),
                          Text(
                            'Video Ready: ${state.isVideoTrackReady}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10),
                          ),
                          Text(
                            'Tracks: ${state.localParticipantTracks.length}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10),
                          ),
                          Text(
                            'Footer: ${state.showFooter.name}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10),
                          ),
                        ],
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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:toeic_desktop/common/configs/app_configs.dart';
import 'package:toeic_desktop/data/models/ui_models/rooms/live_args.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';
import 'package:toeic_desktop/ui/page/prepare_live/widgets/prepare_live_header.dart';
import 'package:toeic_desktop/ui/page/prepare_live/widgets/prepare_live_menu.dart';

class LiveStreamPage extends StatefulWidget {
  final LiveArgs liveArgs;
  const LiveStreamPage({
    super.key,
    required this.liveArgs,
  });

  @override
  State<LiveStreamPage> createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage> {
  late VideoTrack? localVideoTrack;
  String _currentTranscription = '';

  @override
  void initState() {
    super.initState();
    _connect();
  }

  Future<void> _connect() async {

    await widget.liveArgs.room.connect(
      AppConfigs.livekitWss,
      widget.liveArgs.token,
    );

    widget.liveArgs.room.addListener(_onChange);
    // used for specific events
    widget.liveArgs.listener
      ..on<RoomDisconnectedEvent>((_) {
        // handle disconnect
      })  
      ..on<RoomDisconnectedEvent>((_) {
        GoRouter.of(context).pop();
        debugPrint('Winter-room disconnected');
      })
      ..on<ParticipantConnectedEvent>((e) {
        debugPrint("Winter-participant joined: ${e.participant.identity}");
      })
      ..on<ParticipantDisconnectedEvent>((e) {
        debugPrint(
            "Winter-participant disconnected: ${e.participant.identity}");
      })
      ..on<TranscriptionEvent>((e) {
        for (final segment in e.segments) {
          if (segment.isFinal) {
            debugPrint("Winter-transcription: ${segment.text}");
            _currentTranscription = segment.text;
            setState(() {});
          }
        }
      });

    await widget.liveArgs.room.localParticipant?.setCameraEnabled(true);
    await widget.liveArgs.room.localParticipant?.setMicrophoneEnabled(true);
    localVideoTrack =
        widget.liveArgs.room.localParticipant?.videoTrackPublications.firstOrNull?.track;

    setState(() {});
  }

  void _closeRoom() {
    widget.liveArgs.room.disconnect();
    GoRouter.of(context).pop();
  }

  void _onChange() {
    // perform computations and then call setState
    // setState will trigger a build
    setState(() {
      // your updates here
    });
  }

  void _toggleMic() async {}

  @override
  void dispose() {
    widget.liveArgs.room.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = context.sizze.height;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child: widget.liveArgs.room.localParticipant?.videoTrackPublications.firstOrNull
                          ?.track !=
                      null
                  ? VideoTrackRenderer(
                      widget.liveArgs.room.localParticipant?.videoTrackPublications.firstOrNull
                          ?.track as VideoTrack,
                      fit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    )
                  : const LoadingCircle(),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: PrepareLiveHeader(
                  onClose: _closeRoom,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Text(
                  _currentTranscription,
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
                    isOpenMic: true,
                    isOpenCamera: true,
                    onToggleMic: _toggleMic,
                    onSwitchCamera: () {},
                    onToggleCamera: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';
import 'package:toeic_desktop/ui/page/prepare_live/widgets/prepare_live_header.dart';
import 'package:toeic_desktop/ui/page/prepare_live/widgets/prepare_live_menu.dart';

class LiveStreamPage extends StatefulWidget {
  const LiveStreamPage({
    super.key,
  });

  @override
  State<LiveStreamPage> createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage> {
  late Room _room;
  late final EventsListener<RoomEvent> _listener;
  late VideoTrack? localVideoTrack;
  String _currentTranscription = '';

  @override
  void initState() {
    super.initState();
    _connect();
  }

  Future<void> _connect() async {
    _room = Room(
      roomOptions: const RoomOptions(
        adaptiveStream: true,
        dynacast: true,
      ),
    );

    _listener = _room.createListener();

    await _room.connect(
      'wss://winterzxzz-tm30hn8t.livekit.cloud',
      'eyJhbGciOiJIUzI1NiJ9.eyJtZXRhZGF0YSI6IntcInVzZXJJZFwiOjEsXCJ1c2VybmFtZVwiOlwiVW5rbm93bjE3NTc0Mjc4ODcxNTZcIixcImF2YXRhclVybFwiOlwiaHR0cHM6Ly9pLnByYXZhdGFyLmNjLzE1MD91PTE3NTc0Mjc4ODcxNTZcIixcImlzTXV0ZVVzZXJcIjpmYWxzZX0iLCJuYW1lIjoiVW5rbm93bjE3NTc0Mjc4ODcxNTYiLCJ2aWRlbyI6eyJyb29tIjoidGVzdGluZy0xIiwicm9vbUpvaW4iOnRydWUsImNhblB1Ymxpc2giOnRydWUsImNhblN1YnNjcmliZSI6dHJ1ZSwiY2FuUHVibGlzaERhdGEiOnRydWV9LCJpc3MiOiJBUEl4MkQ1YUNTRWlldXYiLCJleHAiOjE3NTc0NDk0ODcsIm5iZiI6MCwic3ViIjoiMV91c2VyIn0.mQQDbpM0yzrZnQATNne95M4hd5u5yhMwa6XSY3r66n4',
    );

    _room.addListener(_onChange);
    // used for specific events
    _listener
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

    await _room.localParticipant?.setCameraEnabled(true);
    await _room.localParticipant?.setMicrophoneEnabled(true);
    localVideoTrack =
        _room.localParticipant?.videoTrackPublications.firstOrNull?.track;

    setState(() {});
  }

  void _closeRoom() {
    _room.disconnect();
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
    _room.disconnect();
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
              child: _room.localParticipant?.videoTrackPublications.firstOrNull
                          ?.track !=
                      null
                  ? VideoTrackRenderer(
                      _room.localParticipant?.videoTrackPublications.firstOrNull
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

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:go_router/go_router.dart';
import 'package:livekit_client/livekit_client.dart';

class LiveStreamPage extends StatefulWidget {
  const LiveStreamPage({
    super.key,
  });

  @override
  State<LiveStreamPage> createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage> {
  late Room _room;
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final Map<String, RTCVideoRenderer> _remoteRenderers = {};
  late final EventsListener<RoomEvent> _listener = _room.createListener();

  @override
  void initState() {
    super.initState();
    _initializeRenderers();
    _connect();
  }

  Future<void> _initializeRenderers() async {
    await _localRenderer.initialize();
  }

  Future<void> _connect() async {
    _room = Room(
      roomOptions: const RoomOptions(
        adaptiveStream: true,
        dynacast: true,
      ),
    );

    await _room.connect(
      'wss://winterzxzz-tm30hn8t.livekit.cloud',
      'eyJhbGciOiJIUzI1NiJ9.eyJtZXRhZGF0YSI6IntcInVzZXJJZFwiOjEsXCJ1c2VybmFtZVwiOlwiVW5rbm93bjE3NTcxNzg2MDg4NDRcIixcImF2YXRhclVybFwiOlwiaHR0cHM6Ly9pLnByYXZhdGFyLmNjLzE1MD91PTE3NTcxNzg2MDg4NDRcIixcImlzTXV0ZVVzZXJcIjpmYWxzZX0iLCJuYW1lIjoiVW5rbm93bjE3NTcxNzg2MDg4NDQiLCJ2aWRlbyI6eyJyb29tIjoid2ludGVyLTEyMyIsInJvb21Kb2luIjp0cnVlLCJjYW5QdWJsaXNoIjp0cnVlLCJjYW5TdWJzY3JpYmUiOnRydWUsImNhblB1Ymxpc2hEYXRhIjp0cnVlfSwiaXNzIjoiQVBJeDJENWFDU0VpZXV2IiwiZXhwIjoxNzU3MjAwMjA4LCJuYmYiOjAsInN1YiI6IjFfdXNlciJ9.xyS88EbbHNxbuE06dJqxBNv5a11ZLHV5LVkEJsdhc0k',
    );

    _room.addListener(_onChange);
    // used for specific events
    _listener
      ..on<RoomDisconnectedEvent>((_) {
        // handle disconnect
      })
      ..on<ParticipantConnectedEvent>((e) {
        debugPrint("participant joined: ${e.participant.identity}");
      });

    await _room.localParticipant?.setCameraEnabled(true);
    await _room.localParticipant?.setMicrophoneEnabled(true);

    // Bind local video
    final localVideoTrack =
        _room.localParticipant?.videoTrackPublications.firstOrNull?.track;
    if (localVideoTrack != null) {
      _localRenderer.srcObject = localVideoTrack.mediaStream;
    }

    setState(() {});
  }

  void _onChange() {
    // perform computations and then call setState
    // setState will trigger a build
    setState(() {
      // your updates here
    });
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    for (final renderer in _remoteRenderers.values) {
      renderer.dispose();
    }
    _room.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LiveKit (Manual Integration)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_end),
            onPressed: () async {
              await _room.disconnect();
              if (context.mounted) {
                GoRouter.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: _videoTile(_localRenderer, label: 'You'),
    );
  }

  Widget _videoTile(RTCVideoRenderer renderer, {required String label}) {
    return Stack(
      children: [
        SizedBox.expand(
          child: RTCVideoView(renderer),
        ),
        // Participants list at the top
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.black54,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.people, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Participants (${_room.remoteParticipants.length + 1})',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 80,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      // Local participant video
                      _participantVideoTile(_localRenderer, 'You',
                          isLocal: true),
                      const SizedBox(width: 8),
                      // Remote participants videos
                      ..._room.remoteParticipants.values.map((participant) {
                        final videoTrack = participant
                            .videoTrackPublications.firstOrNull?.track;
                        if (videoTrack != null) {
                          final renderer = RTCVideoRenderer();
                          renderer.initialize().then((_) {
                            renderer.srcObject = videoTrack.mediaStream;
                            setState(() {
                              _remoteRenderers[participant.sid] = renderer;
                            });
                          });
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _participantVideoTile(
                              _remoteRenderers[participant.sid] ??
                                  RTCVideoRenderer(),
                              participant.identity,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Current user label at the bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.black54,
            padding: const EdgeInsets.all(8),
            child: Text(
              label,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _participantVideoTile(RTCVideoRenderer renderer, String label,
      {bool isLocal = false}) {
    return Container(
      width: 60,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isLocal ? Colors.green : Colors.blue,
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Stack(
          children: [
            SizedBox.expand(
              child: RTCVideoView(renderer),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

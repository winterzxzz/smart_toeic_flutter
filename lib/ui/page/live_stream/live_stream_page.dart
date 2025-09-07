import 'package:flutter/material.dart';
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
  late final EventsListener<RoomEvent> _listener = _room.createListener();

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

    await _room.connect(
      'wss://winterzxzz-tm30hn8t.livekit.cloud',
      'eyJhbGciOiJIUzI1NiJ9.eyJtZXRhZGF0YSI6IntcInVzZXJJZFwiOjEsXCJ1c2VybmFtZVwiOlwiVW5rbm93bjE3NTcyNzE0Mzg1ODdcIixcImF2YXRhclVybFwiOlwiaHR0cHM6Ly9pLnByYXZhdGFyLmNjLzE1MD91PTE3NTcyNzE0Mzg1ODdcIixcImlzTXV0ZVVzZXJcIjpmYWxzZX0iLCJuYW1lIjoiVW5rbm93bjE3NTcyNzE0Mzg1ODciLCJ2aWRlbyI6eyJyb29tIjoid2ludGVyLTEyMyIsInJvb21Kb2luIjp0cnVlLCJjYW5QdWJsaXNoIjp0cnVlLCJjYW5TdWJzY3JpYmUiOnRydWUsImNhblB1Ymxpc2hEYXRhIjp0cnVlfSwiaXNzIjoiQVBJeDJENWFDU0VpZXV2IiwiZXhwIjoxNzU3MjkzMDM4LCJuYmYiOjAsInN1YiI6IjFfdXNlciJ9.tokkuO9HO6RXIhJg0otE87QcOC21xL6IKawx6bie1ws',
    );

    _room.addListener(_onChange);
    // used for specific events
    _listener
      ..on<RoomDisconnectedEvent>((_) {
        // handle disconnect
      })
      ..on<ParticipantConnectedEvent>((e) {
        debugPrint("participant joined: ${e.participant.identity}");
      })
      ..on<TranscriptionEvent>((e) {
        for (final segment in e.segments) {
          debugPrint("transcription: ${segment.text}");
        }
      });

    await _room.localParticipant?.setCameraEnabled(true);
    await _room.localParticipant?.setMicrophoneEnabled(true);

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
      body: _videoTile(label: 'You'),
    );
  }

  Widget _videoTile({required String label}) {
    final localVideoTrack =
        _room.localParticipant?.videoTrackPublications.firstOrNull?.track;

    return Stack(
      children: [
        SizedBox.expand(
          child: localVideoTrack != null
              ? VideoTrackRenderer(localVideoTrack)
              : const Center(
                  child: Text(
                    'No video available',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
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
                      _participantVideoTile(
                        _room.localParticipant?.videoTrackPublications
                            .firstOrNull?.track,
                        'You',
                        isLocal: true,
                      ),
                      const SizedBox(width: 8),
                      // Remote participants videos
                      ..._room.remoteParticipants.values.map((participant) {
                        final videoTrack = participant
                            .videoTrackPublications.firstOrNull?.track;
                        if (videoTrack != null) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _participantVideoTile(
                              videoTrack,
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

  Widget _participantVideoTile(VideoTrack? videoTrack, String label,
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
              child: videoTrack != null
                  ? VideoTrackRenderer(videoTrack)
                  : Container(
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
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

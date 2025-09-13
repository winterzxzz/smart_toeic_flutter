import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:livekit_client/livekit_client.dart';

class LiveArgs extends Equatable {
  final int roomId;
  final Room room;
  final EventsListener<RoomEvent> listener;
  final CameraDescription? currentCameraDescription;
  final bool isOpenCamera;
  final bool isOpenMic;
  final String token;

  const LiveArgs({
    required this.roomId,
    required this.room,
    required this.listener,
    required this.currentCameraDescription,
    required this.isOpenCamera,
    required this.isOpenMic,
    required this.token,
  });

  LiveArgs copyWith({
    int? roomId,
    Room? room,
    EventsListener<RoomEvent>? listener,
    CameraDescription? currentCameraDescription,
    bool? isOpenCamera,
    bool? isOpenMic,
    String? token,
  }) {
    return LiveArgs(
      roomId: roomId ?? this.roomId,
      room: room ?? this.room,
      listener: listener ?? this.listener,
      currentCameraDescription:
          currentCameraDescription ?? this.currentCameraDescription,
      isOpenCamera: isOpenCamera ?? this.isOpenCamera,
      isOpenMic: isOpenMic ?? this.isOpenMic,
      token: token ?? this.token,
    );
  }

  @override
  List<Object?> get props => [
        roomId,
        room,
        listener,
        currentCameraDescription,
        isOpenCamera,
        isOpenMic,
        token
      ];
}

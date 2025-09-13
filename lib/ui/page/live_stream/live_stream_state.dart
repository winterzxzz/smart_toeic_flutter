import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/ui_models/participant_track.dart';

class LiveStreamState extends Equatable {
  final LoadStatus loadStatus;
  final String currentTranscription;
  final List<String> transcriptionHistory;
  final bool isOpenCamera;
  final bool isOpenMic;
  final bool isVideoTrackReady;
  final CameraDescription? currentCameraDescription;
  final List<ParticipantTrack> participantTracks;
  final int numberUser;

  const LiveStreamState({
    required this.loadStatus,
    required this.currentTranscription,
    required this.transcriptionHistory,
    required this.isOpenCamera,
    required this.isOpenMic,
    required this.isVideoTrackReady,
    required this.currentCameraDescription,
    required this.participantTracks,
    required this.numberUser,
  });

  // initial state
  factory LiveStreamState.initial() {
    return const LiveStreamState(
      loadStatus: LoadStatus.initial,
      currentTranscription: '',
      transcriptionHistory: [],
      isOpenCamera: true,
      isOpenMic: true,
      isVideoTrackReady: false,
      currentCameraDescription: null,
      participantTracks: [],
      numberUser: 0,
    );
  }

  // copy with
  LiveStreamState copyWith({
    LoadStatus? loadStatus,
    String? currentTranscription,
    List<String>? transcriptionHistory,
    bool? isOpenCamera,
    bool? isOpenMic,
    bool? isVideoTrackReady,
    CameraDescription? currentCameraDescription,
    List<ParticipantTrack>? participantTracks,
    int? numberUser,
  }) {
    return LiveStreamState(
      loadStatus: loadStatus ?? this.loadStatus,
      currentTranscription: currentTranscription ?? this.currentTranscription,
      transcriptionHistory: transcriptionHistory ?? this.transcriptionHistory,
      isOpenCamera: isOpenCamera ?? this.isOpenCamera,
      isOpenMic: isOpenMic ?? this.isOpenMic,
      isVideoTrackReady: isVideoTrackReady ?? this.isVideoTrackReady,
      currentCameraDescription:
          currentCameraDescription ?? this.currentCameraDescription,
      participantTracks: participantTracks ?? this.participantTracks,
      numberUser: numberUser ?? this.numberUser,
    );
  }

  @override
  List<Object?> get props => [
        loadStatus,
        currentTranscription,
        transcriptionHistory,
        isOpenCamera,
        isOpenMic,
        isVideoTrackReady,
        currentCameraDescription,
        participantTracks,
        numberUser,
      ];
}

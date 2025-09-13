import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';

class LiveStreamState extends Equatable {
  final LoadStatus loadStatus;
  final String currentTranscription;
  final List<String> transcriptionHistory;
  final bool isOpenCamera;
  final bool isOpenMic;
  final bool isVideoTrackReady;
  final CameraDescription? currentCameraDescription;

  const LiveStreamState({
    required this.loadStatus,
    required this.currentTranscription,
    required this.transcriptionHistory,
    required this.isOpenCamera,
    required this.isOpenMic,
    required this.isVideoTrackReady,
    required this.currentCameraDescription,
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
        currentCameraDescription
      ];
}

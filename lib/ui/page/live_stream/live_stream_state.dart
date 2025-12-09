// import 'package:camera/camera.dart';
// import 'package:equatable/equatable.dart';
// import 'package:toeic_desktop/data/models/enums/load_status.dart';
// import 'package:toeic_desktop/data/models/ui_models/participant_track.dart';

// enum LiveStreamShowFooter {
//   comment,
//   transcription,
// }

// class LiveStreamState extends Equatable {
//   final LoadStatus loadStatus;
//   final String currentTranscription;
//   final List<String> transcriptionHistory;
//   final bool isOpenCamera;
//   final bool isOpenMic;
//   final bool isScreenShare;
//   final bool isVideoTrackReady;
//   final bool isShowGridRemoteTracks;
//   final CameraDescription? currentCameraDescription;
//   final List<ParticipantTrack> localParticipantTracks;
//   final List<ParticipantTrack> remoteParticipantTracks;
//   final int numberUser;
//   final LiveStreamShowFooter showFooter;

//   const LiveStreamState({
//     required this.loadStatus,
//     required this.currentTranscription,
//     required this.transcriptionHistory,
//     required this.isOpenCamera,
//     required this.isOpenMic,
//     required this.isScreenShare,
//     required this.isVideoTrackReady,
//     required this.isShowGridRemoteTracks,
//     required this.currentCameraDescription,
//     required this.localParticipantTracks,
//     required this.remoteParticipantTracks,
//     required this.numberUser,
//     required this.showFooter,
//   });

//   // initial state
//   factory LiveStreamState.initial() {
//     return const LiveStreamState(
//       loadStatus: LoadStatus.initial,
//       currentTranscription: '',
//       transcriptionHistory: [],
//       isOpenCamera: true,
//       isOpenMic: true,
//       isScreenShare: false,
//       isVideoTrackReady: false,
//       isShowGridRemoteTracks: false,
//       currentCameraDescription: null,
//       localParticipantTracks: [],
//       remoteParticipantTracks: [],
//       numberUser: 0,
//       showFooter: LiveStreamShowFooter.transcription,
//     );
//   }

//   // copy with
//   LiveStreamState copyWith({
//     LoadStatus? loadStatus,
//     String? currentTranscription,
//     List<String>? transcriptionHistory,
//     bool? isOpenCamera,
//     bool? isOpenMic,
//     bool? isScreenShare,
//     bool? isVideoTrackReady,
//     bool? isShowGridRemoteTracks,
//     CameraDescription? currentCameraDescription,
//     List<ParticipantTrack>? localParticipantTracks,
//     List<ParticipantTrack>? remoteParticipantTracks,
//     int? numberUser,
//     LiveStreamShowFooter? showFooter,
//   }) {
//     return LiveStreamState(
//       loadStatus: loadStatus ?? this.loadStatus,
//       currentTranscription: currentTranscription ?? this.currentTranscription,
//       transcriptionHistory: transcriptionHistory ?? this.transcriptionHistory,
//       isOpenCamera: isOpenCamera ?? this.isOpenCamera,
//       isOpenMic: isOpenMic ?? this.isOpenMic,
//       isScreenShare: isScreenShare ?? this.isScreenShare,
//       isVideoTrackReady: isVideoTrackReady ?? this.isVideoTrackReady,
//       isShowGridRemoteTracks: isShowGridRemoteTracks ?? this.isShowGridRemoteTracks,
//       currentCameraDescription:
//           currentCameraDescription ?? this.currentCameraDescription,
//       localParticipantTracks:
//           localParticipantTracks ?? this.localParticipantTracks,
//       remoteParticipantTracks:
//           remoteParticipantTracks ?? this.remoteParticipantTracks,
//       numberUser: numberUser ?? this.numberUser,
//       showFooter: showFooter ?? this.showFooter,
//     );
//   }

//   @override
//   List<Object?> get props => [
//         loadStatus,
//         currentTranscription,
//         transcriptionHistory,
//         isOpenCamera,
//         isOpenMic,
//         isScreenShare,
//         isVideoTrackReady,
//         isShowGridRemoteTracks,
//         currentCameraDescription,
//         localParticipantTracks,
//         remoteParticipantTracks,
//         numberUser,
//         showFooter,
//       ];
// }

// import 'package:camera/camera.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:livekit_client/livekit_client.dart';
// import 'package:toastification/toastification.dart';
// import 'package:toeic_desktop/common/configs/app_configs.dart';
// import 'package:toeic_desktop/data/models/enums/load_status.dart';
// import 'package:toeic_desktop/data/models/ui_models/participant_track.dart';
// import 'package:toeic_desktop/data/models/ui_models/rooms/live_args.dart';
// import 'package:toeic_desktop/data/network/repositories/room_repository.dart';
// import 'package:toeic_desktop/main.dart';
// import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
// import 'package:toeic_desktop/ui/page/live_stream/live_stream_state.dart';

// class LiveStreamCubit extends Cubit<LiveStreamState> {
//   final RoomRepository roomRepository;
//   final LiveArgs liveArgs;
//   LiveStreamCubit(
//     this.roomRepository, {
//     required this.liveArgs,
//   }) : super(LiveStreamState.initial());

//   void initialize(LiveArgs liveArgs) async {
//     emit(state.copyWith(
//       isOpenCamera: liveArgs.isOpenCamera,
//       isOpenMic: liveArgs.isOpenMic,
//       currentCameraDescription: liveArgs.currentCameraDescription,
//     ));

//     try {
//       // Connect to the room first
//       await liveArgs.room.connect(AppConfigs.livekitWss, liveArgs.token);

//       // Enable/disable microphone
//       await liveArgs.room.localParticipant
//           ?.setMicrophoneEnabled(liveArgs.isOpenMic);

//       // Create and publish video track if camera is enabled
//       if (liveArgs.isOpenCamera && liveArgs.currentCameraDescription != null) {
//         debugPrint(
//             'Winter-Enabling camera with position: ${liveArgs.currentCameraDescription!.lensDirection}');

//         try {
//           await liveArgs.room.localParticipant?.setCameraEnabled(true,
//               cameraCaptureOptions: CameraCaptureOptions(
//                   cameraPosition:
//                       liveArgs.currentCameraDescription!.lensDirection ==
//                               CameraLensDirection.front
//                           ? CameraPosition.front
//                           : CameraPosition.back));

//           // Wait a bit for the track to be published
//           await Future.delayed(const Duration(milliseconds: 1000));

//           // Check for video track publication
//           final videoTrackPublications = liveArgs
//               .room.localParticipant?.videoTrackPublications
//               .where((pub) => pub.track is VideoTrack && !pub.isScreenShare)
//               .toList();

//           debugPrint(
//               'Winter-Video track publications count: ${videoTrackPublications?.length ?? 0}');

//           if (videoTrackPublications != null &&
//               videoTrackPublications.isNotEmpty) {
//             final videoTrack = videoTrackPublications.first.track;
//             debugPrint('Winter-Video track found: ${videoTrack.runtimeType}');
//             emit(state.copyWith(isVideoTrackReady: true));
//           } else {
//             debugPrint('Winter-No video track found after enabling camera');
//             emit(state.copyWith(isVideoTrackReady: false));
//           }
//         } catch (e) {
//           debugPrint('Winter-Error enabling camera: $e');
//           emit(state.copyWith(isVideoTrackReady: false));
//         }
//       } else {
//         debugPrint('Winter-Camera disabled or no camera description');
//         await liveArgs.room.localParticipant?.setCameraEnabled(false);
//         emit(state.copyWith(isVideoTrackReady: false));
//       }

//       setupListener();
//     } catch (e) {
//       debugPrint('Winter-Error initializing live stream: $e');
//     }

//     sortParticipants();
//   }

//   void setupListener() {
//     liveArgs.listener
//       ..on<RoomDisconnectedEvent>((_) {
//         debugPrint('Winter-room disconnected');
//       })
//       ..on<ParticipantConnectedEvent>((e) {
//         debugPrint("Winter-participant joined: ${e.participant.identity}");
//         increaseNumberUser();
//         sortParticipants();
//       })
//       ..on<ParticipantDisconnectedEvent>((e) {
//         debugPrint(
//             "Winter-participant disconnected: ${e.participant.identity}");
//         decreaseNumberUser();
//         sortParticipants();
//       })
//       ..on<TrackPublishedEvent>((e) {
//         debugPrint("Winter-track published: ${e.publication.name}");
//         sortParticipants();
//       })
//       ..on<TrackUnpublishedEvent>((e) {
//         debugPrint("Winter-track unpublished: ${e.publication.name}");
//         sortParticipants();
//       })
//       ..on<LocalTrackPublication>((_) => sortParticipants())
//       ..on<LocalTrackUnpublishedEvent>((_) => sortParticipants())
//       ..on<TranscriptionEvent>((e) {
//         for (final segment in e.segments) {
//           if (segment.isFinal) {
//             debugPrint("Winter-transcription: ${segment.text}");
//             updateCurrentTranscription(segment.text);
//           }
//         }
//       });
//   }

//   Future<void> flipCamera() async {
//     final localParticipant = liveArgs.room.localParticipant;
//     final videoTrack =
//         localParticipant?.videoTrackPublications.firstOrNull?.track;

//     if (videoTrack is LocalVideoTrack) {
//       // Get current camera position from state or default to front
//       final CameraDescription newDescription = cameras.firstWhere(
//         (desc) =>
//             desc.lensDirection != state.currentCameraDescription!.lensDirection,
//         orElse: () => state.currentCameraDescription!,
//       );

//       // Restart the video track with the new camera position
//       await videoTrack.restartTrack(
//         CameraCaptureOptions(
//             cameraPosition:
//                 newDescription.lensDirection == CameraLensDirection.front
//                     ? CameraPosition.front
//                     : CameraPosition.back),
//       );
//       emit(state.copyWith(currentCameraDescription: newDescription));
//     }
//   }

//   void toggleMic() {
//     if (state.isOpenMic) {
//       liveArgs.room.localParticipant?.setMicrophoneEnabled(false);
//       emit(state.copyWith(isOpenMic: false));
//     } else {
//       liveArgs.room.localParticipant?.setMicrophoneEnabled(true);
//       emit(state.copyWith(isOpenMic: true));
//     }
//   }

//   void toggleCamera() async {
//     if (state.isOpenCamera) {
//       await liveArgs.room.localParticipant?.setCameraEnabled(false);
//       emit(state.copyWith(isOpenCamera: false, isVideoTrackReady: false));
//     } else {
//       emit(state.copyWith(isOpenCamera: true, isVideoTrackReady: false));

//       try {
//         await liveArgs.room.localParticipant?.setCameraEnabled(true);

//         // Wait for track to be published
//         await Future.delayed(const Duration(milliseconds: 1000));

//         final videoTrackPublications = liveArgs
//             .room.localParticipant?.videoTrackPublications
//             .where((pub) => pub.track is VideoTrack && !pub.isScreenShare)
//             .toList();

//         if (videoTrackPublications != null &&
//             videoTrackPublications.isNotEmpty) {
//           emit(state.copyWith(isVideoTrackReady: true));
//         } else {
//           emit(state.copyWith(isVideoTrackReady: false));
//         }
//       } catch (e) {
//         debugPrint('Winter-Error toggling camera: $e');
//         emit(state.copyWith(isVideoTrackReady: false));
//       }
//     }
//   }

//   void updateCurrentTranscription(String transcription) {
//     emit(state.copyWith(
//         currentTranscription: transcription,
//         transcriptionHistory: [...state.transcriptionHistory, transcription]));
//   }

//   Future<void> closeRoom() async {
//     emit(state.copyWith(loadStatus: LoadStatus.loading));
//     final rs = await roomRepository.closeLive(liveArgs.roomId);
//     rs.fold((l) {
//       emit(state.copyWith(loadStatus: LoadStatus.failure));
//       showToast(title: l.message, type: ToastificationType.error);
//     }, (r) => emit(state.copyWith(loadStatus: LoadStatus.success)));
//   }

//   void sortParticipants() {
//     List<ParticipantTrack> userMediaTracks = [];
//     List<ParticipantTrack> screenTracks = [];
//     List<ParticipantTrack> remoteParticipantTracks = [];

//     final localParticipant = liveArgs.room.localParticipant;
//     final localVideoPublications = localParticipant?.videoTrackPublications;

//     final remoteParticipants = liveArgs.room.remoteParticipants.values;

//     // Local participant tracks
//     if (localVideoPublications != null) {
//       debugPrint(
//           'Winter-Local video publications count: ${localVideoPublications.length}');
//       for (var pub in localVideoPublications) {
//         final track = pub.track;
//         debugPrint(
//             'Winter-Local publication: ${pub.name}, track: ${track.runtimeType}, isScreenShare: ${pub.isScreenShare}');
//         if (track != null) {
//           final targetList = pub.isScreenShare ? screenTracks : userMediaTracks;
//           targetList.add(ParticipantTrack(
//             participant: localParticipant!,
//             videoTrack: track,
//           ));
//         }
//       }
//     } else {
//       debugPrint('Winter-No local video publications found');
//     }

//     // Remote participant tracks
//     for (var remote in remoteParticipants) {
//       final publications = remote.videoTrackPublications;

//       if (publications.isNotEmpty) {
//         bool addedTrack = false;
//         for (var pub in publications) {
//           if (pub.track != null) {
//             remoteParticipantTracks.add(ParticipantTrack(
//               participant: remote,
//               videoTrack: pub.track,
//             ));
//             addedTrack = true;
//           }
//         }

//         // If none of the publications had tracks, add placeholder
//         if (!addedTrack) {
//           remoteParticipantTracks.add(ParticipantTrack(
//             participant: remote,
//             videoTrack: null,
//           ));
//         }
//       } else {
//         // No publications at all
//         remoteParticipantTracks.add(ParticipantTrack(
//           participant: remote,
//           videoTrack: null,
//         ));
//       }
//     }

//     debugPrint('=== SORT PARTICIPANTS DEBUG ===');
//     debugPrint('Screen tracks count: ${screenTracks.length}');
//     debugPrint('User media tracks count: ${userMediaTracks.length}');
//     debugPrint('Remote tracks count: ${remoteParticipantTracks.length}');
//     debugPrint(
//         'Total local tracks: ${screenTracks.length + userMediaTracks.length}');

//     emit(state.copyWith(
//       localParticipantTracks: [...screenTracks, ...userMediaTracks],
//       remoteParticipantTracks: remoteParticipantTracks,
//     ));
//   }

//   void increaseNumberUser() {
//     final currentNumberUser = state.numberUser;
//     emit(state.copyWith(numberUser: currentNumberUser + 1));
//   }

//   void decreaseNumberUser() {
//     final currentNumberUser = state.numberUser;
//     if (currentNumberUser == 0) return;
//     emit(state.copyWith(numberUser: currentNumberUser - 1));
//   }

//   void shareScreen() {
//     if (state.isScreenShare) {
//       liveArgs.room.localParticipant?.setScreenShareEnabled(false);
//       emit(state.copyWith(isScreenShare: false));
//     } else {
//       liveArgs.room.localParticipant?.setScreenShareEnabled(true);
//       emit(state.copyWith(isScreenShare: true));
//     }
//   }

//   void toggleShowFooter() {
//     if (state.showFooter == LiveStreamShowFooter.comment) {
//       emit(state.copyWith(showFooter: LiveStreamShowFooter.transcription));
//     } else {
//       emit(state.copyWith(showFooter: LiveStreamShowFooter.comment));
//     }
//   }

//   void toggleShowGridRemoteTracks() {
//     final newValue = !state.isShowGridRemoteTracks;
//     debugPrint('Toggling grid remote tracks: $newValue');
//     emit(state.copyWith(isShowGridRemoteTracks: newValue));
//   }
// }

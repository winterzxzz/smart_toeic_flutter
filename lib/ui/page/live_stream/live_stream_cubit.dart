import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/common/configs/app_configs.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/ui_models/participant_track.dart';
import 'package:toeic_desktop/data/models/ui_models/rooms/live_args.dart';
import 'package:toeic_desktop/data/network/repositories/room_repository.dart';
import 'package:toeic_desktop/main.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/live_stream/live_stream_state.dart';

class LiveStreamCubit extends Cubit<LiveStreamState> {
  final RoomRepository roomRepository;
  final LiveArgs liveArgs;
  LiveStreamCubit(
    this.roomRepository, {
    required this.liveArgs,
  }) : super(LiveStreamState.initial());

  void initialize(LiveArgs liveArgs) async {
    emit(state.copyWith(
      isOpenCamera: liveArgs.isOpenCamera,
      isOpenMic: liveArgs.isOpenMic,
      currentCameraDescription: liveArgs.currentCameraDescription,
    ));

    try {
      // Connect to the room first
      await liveArgs.room.connect(AppConfigs.livekitWss, liveArgs.token);

      // Enable/disable microphone
      await liveArgs.room.localParticipant
          ?.setMicrophoneEnabled(liveArgs.isOpenMic);

      // Create and publish video track if camera is enabled
      if (liveArgs.isOpenCamera && liveArgs.currentCameraDescription != null) {
        await liveArgs.room.localParticipant?.setCameraEnabled(true,
            cameraCaptureOptions: CameraCaptureOptions(
                cameraPosition:
                    liveArgs.currentCameraDescription!.lensDirection ==
                            CameraLensDirection.front
                        ? CameraPosition.front
                        : CameraPosition.back));
        final videoTrackPublication = liveArgs
            .room.localParticipant?.videoTrackPublications
            .where((pub) => pub.track is VideoTrack)
            .firstOrNull;
        final videoTrack = videoTrackPublication?.track;

        if (videoTrack is VideoTrack) {
          emit(state.copyWith(isVideoTrackReady: true));
        }
      } else {
        await liveArgs.room.localParticipant?.setCameraEnabled(false);
      }

      setupListener();
    } catch (e) {
      debugPrint('Winter-Error initializing live stream: $e');
    }

    sortParticipants();
  }

  void setupListener() {
    liveArgs.listener
      ..on<RoomDisconnectedEvent>((_) {
        debugPrint('Winter-room disconnected');
      })
      ..on<ParticipantConnectedEvent>((e) {
        debugPrint("Winter-participant joined: ${e.participant.identity}");
        increaseNumberUser();
      })
      ..on<ParticipantDisconnectedEvent>((e) {
        debugPrint(
            "Winter-participant disconnected: ${e.participant.identity}");
        decreaseNumberUser();
      })
      ..on<TrackPublishedEvent>((e) {
        debugPrint("Winter-track published: ${e.publication.kind}");
        if (e.publication.track is VideoTrack) {
          emit(state.copyWith(isVideoTrackReady: true));
        }
      })
      ..on<TrackUnpublishedEvent>((e) {
        debugPrint("Winter-track unpublished: ${e.publication.kind}");
        if (e.publication.track is VideoTrack) {
          emit(state.copyWith(isVideoTrackReady: false));
        }
      })
      ..on<LocalTrackPublication>((_) => sortParticipants())
      ..on<LocalTrackUnpublishedEvent>((_) => sortParticipants())
      ..on<TranscriptionEvent>((e) {
        for (final segment in e.segments) {
          if (segment.isFinal) {
            debugPrint("Winter-transcription: ${segment.text}");
            updateCurrentTranscription(segment.text);
          }
        }
      });
  }

  Future<void> flipCamera() async {
    final localParticipant = liveArgs.room.localParticipant;
    final videoTrack =
        localParticipant?.videoTrackPublications.firstOrNull?.track;

    if (videoTrack is LocalVideoTrack) {
      // Get current camera position from state or default to front
      final CameraDescription newDescription = cameras.firstWhere(
        (desc) =>
            desc.lensDirection != state.currentCameraDescription!.lensDirection,
        orElse: () => state.currentCameraDescription!,
      );

      // Restart the video track with the new camera position
      await videoTrack.restartTrack(
        CameraCaptureOptions(
            cameraPosition:
                newDescription.lensDirection == CameraLensDirection.front
                    ? CameraPosition.front
                    : CameraPosition.back),
      );
      emit(state.copyWith(currentCameraDescription: newDescription));
    }
  }

  void toggleMic() {
    if (state.isOpenMic) {
      liveArgs.room.localParticipant?.setMicrophoneEnabled(false);
      emit(state.copyWith(isOpenMic: false));
    } else {
      liveArgs.room.localParticipant?.setMicrophoneEnabled(true);
      emit(state.copyWith(isOpenMic: true));
    }
  }

  void toggleCamera() async {
    if (state.isOpenCamera) {
      await liveArgs.room.localParticipant?.setCameraEnabled(false);
      emit(state.copyWith(isOpenCamera: false, isVideoTrackReady: false));
    } else {
      emit(state.copyWith(isOpenCamera: true, isVideoTrackReady: false));
      await liveArgs.room.localParticipant?.setCameraEnabled(true);
      final videoTrackPublication = liveArgs
          .room.localParticipant?.videoTrackPublications
          .where((pub) => pub.track is VideoTrack)
          .firstOrNull;
      final videoTrack = videoTrackPublication?.track;

      if (videoTrack is VideoTrack) {
        emit(state.copyWith(isVideoTrackReady: true));
      }
    }
  }

  void updateCurrentTranscription(String transcription) {
    emit(state.copyWith(
        currentTranscription: transcription,
        transcriptionHistory: [...state.transcriptionHistory, transcription]));
  }

  Future<void> closeRoom() async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final rs = await roomRepository.closeLive(liveArgs.roomId);
    rs.fold((l) {
      emit(state.copyWith(loadStatus: LoadStatus.failure));
      showToast(title: l.message, type: ToastificationType.error);
    }, (r) => emit(state.copyWith(loadStatus: LoadStatus.success)));
  }

  void sortParticipants() {
    List<ParticipantTrack> userMediaTracks = [];
    List<ParticipantTrack> screenTracks = [];
    final localParticipantTracks =
        liveArgs.room.localParticipant?.videoTrackPublications;
    if (localParticipantTracks != null) {
      for (var t in localParticipantTracks) {
        if (t.isScreenShare) {
          screenTracks.add(ParticipantTrack(
            participant: liveArgs.room.localParticipant!,
            videoTrack: t.track,
          ));
        } else {
          userMediaTracks.add(ParticipantTrack(
            participant: liveArgs.room.localParticipant!,
            videoTrack: t.track,
          ));
        }
      }
    }
    emit(state
        .copyWith(participantTracks: [...screenTracks, ...userMediaTracks]));
  }

  void increaseNumberUser() {
    final currentNumberUser = state.numberUser;
    emit(state.copyWith(numberUser: currentNumberUser + 1));
  }

  void decreaseNumberUser() {
    final currentNumberUser = state.numberUser;
    if (currentNumberUser == 0) return;
    emit(state.copyWith(numberUser: currentNumberUser - 1));
  }
}

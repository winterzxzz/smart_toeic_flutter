import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:toeic_desktop/common/configs/app_configs.dart';
import 'package:toeic_desktop/data/models/ui_models/rooms/live_args.dart';
import 'package:toeic_desktop/main.dart';
import 'package:toeic_desktop/ui/page/live_stream/live_stream_state.dart';

class LiveStreamCubit extends Cubit<LiveStreamState> {
  final LiveArgs liveArgs;
  LiveStreamCubit(this.liveArgs) : super(LiveStreamState.initial());

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
          ?.setMicrophoneEnabled(state.isOpenMic);

      // Create and publish video track if camera is enabled
      if (state.isOpenCamera && state.currentCameraDescription != null) {
        await liveArgs.room.localParticipant?.setCameraEnabled(true,
            cameraCaptureOptions: CameraCaptureOptions(
                cameraPosition: state.currentCameraDescription!.lensDirection ==
                        CameraLensDirection.front
                    ? CameraPosition.front
                    : CameraPosition.back));
      } else {
        await liveArgs.room.localParticipant?.setCameraEnabled(false);
      }

      setupListener();
    } catch (e) {
      debugPrint('Winter-Error initializing live stream: $e');
    }
  }

  void setupListener() {
    liveArgs.listener
      ..on<RoomDisconnectedEvent>((_) {
        // handle disconnect
      })
      ..on<RoomDisconnectedEvent>((_) {
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
      emit(state.copyWith(isOpenCamera: false));
    } else {
      emit(state.copyWith(isOpenCamera: true));
      await liveArgs.room.localParticipant?.setCameraEnabled(true);
    }
  }

  void updateCurrentTranscription(String transcription) {
    emit(state.copyWith(
        currentTranscription: transcription,
        transcriptionHistory: [...state.transcriptionHistory, transcription]));
  }

  Future<void> closeRoom() async {
    await liveArgs.room.disconnect();
  }
}

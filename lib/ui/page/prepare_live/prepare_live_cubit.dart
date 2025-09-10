import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/main.dart';
import 'package:toeic_desktop/ui/page/prepare_live/prepare_live_state.dart';

class PrepareLiveCubit extends Cubit<PrepareLiveState> {
  PrepareLiveCubit() : super(PrepareLiveState.initial());

  late CameraController cameraController;

  void initialize() async {
    if (cameras.length < 2) {
      emit(state.copyWith(
          loadStatus: LoadStatus.failure, message: 'Camera not available'));
      return;
    }
    try {
      if (state.currentCameraDescription == null) {
        emit(state.copyWith(
            loadStatus: LoadStatus.failure, message: 'Camera not available'));
        return;
      }
      cameraController = CameraController(
          state.currentCameraDescription!, state.resolutionPreset,
          enableAudio: state.isOpenMic);
      await cameraController.initialize();
      emit(state.copyWith(loadStatus: LoadStatus.success, isInitialized: true));
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          emit(state.copyWith(
              loadStatus: LoadStatus.failure,
              message: e.description ?? 'Camera access denied'));
          break;
        default:
          emit(state.copyWith(
              loadStatus: LoadStatus.failure,
              message: e.description ?? 'Camera not available'));
          break;
      }
    } catch (e) {
      emit(state.copyWith(
          loadStatus: LoadStatus.failure, message: 'Camera not available'));
    }
  }

  void switchCamera() async {
    if (cameras.length < 2) {
      emit(state.copyWith(
          loadStatus: LoadStatus.failure, message: 'Camera not available'));
      return;
    }
    final CameraDescription newDescription = cameras.firstWhere(
      (desc) =>
          desc.lensDirection != state.currentCameraDescription!.lensDirection,
      orElse: () => state.currentCameraDescription!,
    );

    try {
      if (state.isInitialized && cameraController.value.isInitialized) {
        await cameraController.dispose();
      }
      final CameraController newCameraController = CameraController(
          newDescription, state.resolutionPreset,
          enableAudio: state.isOpenMic);
      await newCameraController.initialize();
      cameraController = newCameraController;
      emit(state.copyWith(
          loadStatus: LoadStatus.success,
          currentCameraDescription: newDescription));
    } catch (e) {
      emit(state.copyWith(
          loadStatus: LoadStatus.failure, message: 'Camera not available'));
    }
  }

  void toggleCamera() async {
    try {
      if (state.isInitialized &&
          cameraController.value.isInitialized &&
          state.isOpenCamera) {
        await cameraController.dispose();
        emit(state.copyWith(isOpenCamera: false));
      } else {
        final CameraController newCameraController = CameraController(
            state.currentCameraDescription!, state.resolutionPreset,
            enableAudio: state.isOpenMic);
        await newCameraController.initialize();
        cameraController = newCameraController;
        emit(state.copyWith(isOpenCamera: true));
      }
    } catch (e) {
      emit(state.copyWith(
          loadStatus: LoadStatus.failure, message: 'Camera not available'));
    }
  }

  void toggleMic() async {
    if (state.isOpenMic) {
      emit(state.copyWith(isOpenMic: false));
    } else {
      emit(state.copyWith(isOpenMic: true));
    }
  }

  @override
  Future<void> close() {
    cameraController.dispose();
    return super.close();
  }
}

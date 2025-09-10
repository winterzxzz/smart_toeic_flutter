import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toeic_desktop/main.dart';
import 'package:toeic_desktop/ui/page/prepare_live/prepare_live_state.dart';

class PrepareLiveCubit extends Cubit<PrepareLiveState> {
  PrepareLiveCubit() : super(PrepareLiveState.initial());

  late CameraController cameraController;

  void initialize() async {
    if (cameras.isEmpty) {
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
    if (cameras.isEmpty) {
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

  void selectImageFrom(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: source);
    if (pickedImage == null) return;

    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedImage.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
      ],
    );

    if (croppedFile == null) return;

    emit(state.copyWith(thumbnail: File(croppedFile.path)));
  }

  @override
  Future<void> close() async {
    await cameraController.dispose();
    return super.close();
  }
}

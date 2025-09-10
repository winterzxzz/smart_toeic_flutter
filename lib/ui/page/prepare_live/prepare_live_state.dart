import 'dart:io';

import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/main.dart';

class PrepareLiveState extends Equatable {
  final LoadStatus loadStatus;
  final String message;
  final bool isInitialized;
  final bool isOpenCamera;
  final bool isOpenMic;
  final CameraDescription? currentCameraDescription;
  final String liveName;
  final File? thumbnail;
  final String? description;
  final ResolutionPreset resolutionPreset;

  const PrepareLiveState({
    required this.loadStatus,
    required this.message,
    required this.isInitialized,
    required this.isOpenCamera,
    required this.isOpenMic,
    this.currentCameraDescription,
    required this.liveName,
    this.thumbnail,
    required this.description,
    required this.resolutionPreset,
  });

  factory PrepareLiveState.initial() {
    return PrepareLiveState(
      loadStatus: LoadStatus.initial,
      message: '',
      isInitialized: false,
      isOpenCamera: true,
      isOpenMic: true,
      currentCameraDescription: cameras.isNotEmpty ? cameras.length > 1 ? cameras[1] : cameras.first : null,
      liveName: '',
      thumbnail: null,
      description: '',
      resolutionPreset: ResolutionPreset.max,
    );
  }

  PrepareLiveState copyWith({
    LoadStatus? loadStatus,
    String? message,
    bool? isInitialized,
    bool? isOpenCamera,
    bool? isOpenMic,
    CameraDescription? currentCameraDescription,
    String? liveName,
    File? thumbnail,
    String? description,
    ResolutionPreset? resolutionPreset,
  }) {
    return PrepareLiveState(
      loadStatus: loadStatus ?? this.loadStatus,
      message: message ?? this.message,
      isInitialized: isInitialized ?? this.isInitialized,
      isOpenCamera: isOpenCamera ?? this.isOpenCamera,
      isOpenMic: isOpenMic ?? this.isOpenMic,
      currentCameraDescription:
          currentCameraDescription ?? this.currentCameraDescription,
      liveName: liveName ?? this.liveName,
      thumbnail: thumbnail ?? this.thumbnail,
      description: description ?? this.description,
      resolutionPreset: resolutionPreset ?? this.resolutionPreset,
    );
  }

  @override
  List<Object?> get props => [
        loadStatus,
        message,
        isInitialized,
        isOpenCamera,
        isOpenMic,
        currentCameraDescription,
        liveName,
        thumbnail,
        description,
        resolutionPreset,
      ];
}

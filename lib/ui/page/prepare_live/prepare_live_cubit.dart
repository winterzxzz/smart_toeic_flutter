// import 'dart:async';
// import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:toastification/toastification.dart';
// import 'package:toeic_desktop/data/models/enums/load_status.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:toeic_desktop/data/models/request/create_room_request.dart';
// import 'package:toeic_desktop/data/network/repositories/room_repository.dart';
// import 'package:toeic_desktop/main.dart';
// import 'package:toeic_desktop/ui/common/app_colors.dart';
// import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
// import 'package:toeic_desktop/ui/page/prepare_live/prepare_live_state.dart';

// class PrepareLiveCubit extends Cubit<PrepareLiveState> {
//   final RoomRepository _roomRepository;
//   PrepareLiveCubit(this._roomRepository) : super(PrepareLiveState.initial());

//   late CameraController cameraController;

//   Timer? _countDownTimer;

//   void initialize() async {
//     if (cameras.isEmpty) {
//       emit(state.copyWith(
//           loadStatus: LoadStatus.failure, message: 'Camera not available'));
//       return;
//     }
//     try {
//       if (state.currentCameraDescription == null) {
//         emit(state.copyWith(
//             loadStatus: LoadStatus.failure, message: 'Camera not available'));
//         return;
//       }
//       cameraController = CameraController(
//           state.currentCameraDescription!, state.resolutionPreset,
//           enableAudio: state.isOpenMic);
//       await cameraController.initialize();
//       emit(state.copyWith(loadStatus: LoadStatus.success, isInitialized: true));
//     } on CameraException catch (e) {
//       switch (e.code) {
//         case 'CameraAccessDenied':
//           emit(state.copyWith(
//               loadStatus: LoadStatus.failure,
//               message: e.description ?? 'Camera access denied'));
//           break;
//         default:
//           emit(state.copyWith(
//               loadStatus: LoadStatus.failure,
//               message: e.description ?? 'Camera not available'));
//           break;
//       }
//     } catch (e) {
//       emit(state.copyWith(
//           loadStatus: LoadStatus.failure, message: 'Camera not available'));
//     }
//   }

//   void switchCamera() async {
//     if (cameras.isEmpty) {
//       emit(state.copyWith(
//           loadStatus: LoadStatus.failure, message: 'Camera not available'));
//       return;
//     }
//     final CameraDescription newDescription = cameras.firstWhere(
//       (desc) =>
//           desc.lensDirection != state.currentCameraDescription!.lensDirection,
//       orElse: () => state.currentCameraDescription!,
//     );

//     try {
//       if (state.isInitialized && cameraController.value.isInitialized) {
//         await cameraController.dispose();
//       }
//       final CameraController newCameraController = CameraController(
//           newDescription, state.resolutionPreset,
//           enableAudio: state.isOpenMic);
//       await newCameraController.initialize();
//       cameraController = newCameraController;
//       emit(state.copyWith(
//           loadStatus: LoadStatus.success,
//           currentCameraDescription: newDescription));
//     } catch (e) {
//       emit(state.copyWith(
//           loadStatus: LoadStatus.failure, message: 'Camera not available'));
//       showToast(title: 'Camera not available', type: ToastificationType.error);
//     }
//   }

//   void toggleCamera() async {
//     try {
//       if (state.isInitialized &&
//           cameraController.value.isInitialized &&
//           state.isOpenCamera) {
//         await cameraController.dispose();
//         emit(state.copyWith(isOpenCamera: false));
//       } else {
//         final CameraController newCameraController = CameraController(
//             state.currentCameraDescription!, state.resolutionPreset,
//             enableAudio: state.isOpenMic);
//         await newCameraController.initialize();
//         cameraController = newCameraController;
//         emit(state.copyWith(isOpenCamera: true));
//       }
//     } catch (e) {
//       emit(state.copyWith(
//           loadStatus: LoadStatus.failure, message: 'Camera not available'));
//       showToast(title: 'Camera not available', type: ToastificationType.error);
//     }
//   }

//   void toggleMic() async {
//     if (state.isOpenMic) {
//       emit(state.copyWith(isOpenMic: false));
//     } else {
//       emit(state.copyWith(isOpenMic: true));
//     }
//   }

//   void selectImageFrom(ImageSource source) async {
//     try {
//       final ImagePicker picker = ImagePicker();
//       final XFile? pickedImage = await picker.pickImage(source: source);
//       if (pickedImage == null) return;

//       final CroppedFile? croppedFile = await ImageCropper().cropImage(
//         sourcePath: pickedImage.path,
//         uiSettings: [
//           AndroidUiSettings(
//             toolbarTitle: 'Crop Image',
//             toolbarColor: AppColors.appBarDark,
//             toolbarWidgetColor: Colors.white,
//             initAspectRatio: CropAspectRatioPreset.original,
//             lockAspectRatio: false,
//             aspectRatioPresets: [
//               CropAspectRatioPreset.square,
//               CropAspectRatioPreset.ratio4x3,
//               CropAspectRatioPreset.ratio16x9,
//             ],
//           ),
//           IOSUiSettings(
//             title: 'Crop Image',
//             aspectRatioPresets: [
//               CropAspectRatioPreset.square,
//               CropAspectRatioPreset.ratio4x3,
//               CropAspectRatioPreset.ratio16x9,
//             ],
//           ),
//         ],
//       );

//       if (croppedFile == null) return;

//       emit(state.copyWith(thumbnail: File(croppedFile.path)));
//     } catch (e) {
//       emit(state.copyWith(
//         loadStatus: LoadStatus.failure,
//         message: 'Failed to crop image: ${e.toString()}',
//       ));
//       showToast(
//           title: 'Failed to crop image: ${e.toString()}',
//           type: ToastificationType.error);
//     }
//   }

//   void updateTitle(String title) {
//     emit(state.copyWith(liveName: title));
//   }

//   void startCountDownTimer() {
//     emit(state.copyWith(isCountDown: true, countDown: 5));
//     _countDownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       emit(state.copyWith(countDown: state.countDown - 1));
//       if (state.countDown <= 0) {
//         _countDownTimer?.cancel();
//         emit(state.copyWith(isCountDown: false));
//         startLive();
//       }
//     });
//   }

//   void cancelCountDownTimer() {
//     _countDownTimer?.cancel();
//     emit(state.copyWith(isCountDown: false));
//   }

//   void startLive() async {
//     emit(state.copyWith(loadStatus: LoadStatus.loading, message: ''));
//     if (state.liveName.isEmpty || state.thumbnail == null) {
//       emit(state.copyWith(
//           loadStatus: LoadStatus.failure,
//           message: 'Please enter title and set thumbnail'));
//       showToast(
//           title: 'Please enter title and set thumbnail',
//           type: ToastificationType.error);
//       return;
//     }
//     final createRoomRequest = CreateRoomRequest(
//       name: state.liveName,
//       description: 'No description',
//       thumbnail: state.thumbnail?.path ?? '',
//     );
//     final rs = await _roomRepository.createRoom(createRoomRequest);
//     rs.fold(
//         (l) => {
//               emit(state.copyWith(
//                   loadStatus: LoadStatus.failure, message: l.message)),
//               showToast(title: l.message, type: ToastificationType.error),
//             }, (r) async {
//       final rs2 = await _roomRepository.startLive(r);
//       rs2.fold(
//           (l) => {
//                 emit(state.copyWith(
//                     loadStatus: LoadStatus.failure, message: l.message)),
//                 showToast(title: l.message, type: ToastificationType.error),
//               }, (r) {
//         emit(state.copyWith(
//             loadStatus: LoadStatus.success,
//             liveArgs: r.copyWith(
//               currentCameraDescription: state.currentCameraDescription,
//               isOpenCamera: state.isOpenCamera,
//               isOpenMic: state.isOpenMic,
//               token: r.token,
//               room: r.room,
//               listener: r.listener,
//               roomId: r.roomId,
//             )));
//       });
//     });
//   }

//   @override
//   Future<void> close() async {
//     _countDownTimer?.cancel();
//     if (state.isInitialized && cameraController.value.isInitialized) {
//       await cameraController.dispose();
//     }
//     return super.close();
//   }
// }

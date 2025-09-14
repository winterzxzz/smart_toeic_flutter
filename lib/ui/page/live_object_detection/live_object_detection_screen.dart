import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toeic_desktop/data/models/detected_object/detected_object_dm.dart';
import 'package:toeic_desktop/data/models/ui_models/screen_params.dart';
import 'package:toeic_desktop/data/services/detector.dart';
import 'package:toeic_desktop/ui/page/live_object_detection/widgets/box_widget.dart';
import 'package:toeic_desktop/ui/page/live_object_detection/widgets/rounded_button.dart';

class LiveObjectDetectionScreen extends StatefulWidget {
  const LiveObjectDetectionScreen({super.key});

  @override
  State<LiveObjectDetectionScreen> createState() =>
      _LiveObjectDetectionScreenState();
}

class _LiveObjectDetectionScreenState extends State<LiveObjectDetectionScreen> {
  final _imagePicker = ImagePicker();

  String? message;

  late final AppLifecycleListener _appLifecycleListener;

  /// List of available cameras
  late List<CameraDescription> cameras;

  int cameraIndex = 0;

  /// Controller
  CameraController? _cameraController;

  /// Object Detector is running on a background [Isolate]. This is nullable
  /// because acquiring a [Detector] is an asynchronous operation. This
  /// value is `null` until the detector is initialized.
  Detector? _detector;

  StreamSubscription? _objectDetectorStream;

  /// Results to draw bounding boxes
  List<DetectedObjectDm>? detectedObjectList;

  @override
  void initState() {
    super.initState();
    _appLifecycleListener = AppLifecycleListener(
      onResume: _init,
      onInactive: () {
        _cameraController?.stopImageStream();
        _objectDetectorStream?.cancel();
        _detector?.stop();
      },
    );
    _init();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _cameraController;
    return Scaffold(
      appBar: AppBar(title: const Text('Live Object Detection')),
      body: controller == null || !controller.value.isInitialized
          ? Center(child: Text(message ?? 'Initializing...'))
          : Column(
              children: [
                AspectRatio(
                  aspectRatio: 1 / controller.value.aspectRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CameraPreview(controller),
                      // Bounding boxes
                      ...?detectedObjectList?.map(
                        (detectedObject) => Positioned.fromRect(
                          rect: detectedObject.renderLocation,
                          child: BoxWidget.fromDetectedObject(detectedObject),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ColoredBox(
                    color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RoundedButton(
                          size: 48,
                          side: BorderSide.none,
                          color: Colors.white.withValues(alpha: 0.3),
                          onTap: _pickImageFromGallery,
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/vectors/gallery.svg',
                              width: 24,
                              height: 24,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        RoundedButton(
                          padding: const EdgeInsets.all(2),
                          onTap: _takePicture,
                        ),
                        const SizedBox(width: 20),
                        RoundedButton(
                          size: 48,
                          side: BorderSide.none,
                          color: Colors.white.withValues(alpha: 0.3),
                          onTap: _flipCamera,
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/vectors/repeate-music.svg',
                              width: 28,
                              height: 28,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _appLifecycleListener.dispose();
    _cameraController?.dispose();
    _objectDetectorStream?.cancel();
    _detector?.stop();
  }

  Future<void> _init() async {
    await _initializeCamera();
    await _initializeDetector();

    /// Listen each frame from calling the image stream
    await _cameraController?.startImageStream(onLatestImageAvailable);

    /// previewSize is size of each image frame captured by controller
    ///
    /// 352x288 on iOS, 240p (320x240) on Android with ResolutionPreset.low
    final size = _cameraController?.value.previewSize;
    if (size != null) ScreenParams.previewSize = size;

    if (mounted) setState(() {});
  }

  /// Initializes the camera by setting [_cameraController]
  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras.isEmpty) {
      message = 'No Camera Available';
      if (mounted) setState(() {});
      log('No Camera Available');
      return;
    }
    // cameras[0] for back-camera
    cameraIndex = 0;
    final camera = cameras[cameraIndex];
    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _cameraController?.initialize();
  }

  Future<void> _initializeDetector() async {
    final detector = await Detector.start();
    setState(() {
      _detector = detector;
      _objectDetectorStream = detector.resultsStream.listen((detectedObjects) {
        if (mounted) setState(() => detectedObjectList = detectedObjects);
      });
    });
  }

  void _flipCamera() {
    if (cameras.length <= 1) return;
    final newIndex = cameraIndex == 1 ? 0 : 1;
    cameraIndex = newIndex;
    _cameraController?.stopImageStream();
    _cameraController = CameraController(
      cameras[newIndex],
      ResolutionPreset.medium,
      enableAudio: false,
    )..initialize().then((_) async {
        await _cameraController?.startImageStream(onLatestImageAvailable);
        if (mounted) setState(() {});

        /// previewSize is size of each image frame captured by controller
        ///
        /// 352x288 on iOS, 240p (320x240) on Android with ResolutionPreset.low
        ScreenParams.previewSize =
            _cameraController?.value.previewSize ?? ScreenParams.previewSize;
      });
  }

  Future<void> _takePicture() async {
    // final capturedImage = await _cameraController?.takePicture();
    // final decodedImage = await capturedImage?.readAsBytes();
    // NavigationService.instance
    //   ..pop()
    //   ..pushNamed(AppRoutes.photoAnalyzedScreen, arguments: decodedImage);
  }

  Future<void> _pickImageFromGallery() async {
    final result = await _imagePicker.pickImage(source: ImageSource.gallery);
    final readAsBytesSync = await result?.readAsBytes();
    if (readAsBytesSync != null) {
      // NavigationService.instance
      //   ..pop()
      //   ..pushNamed(AppRoutes.photoAnalyzedScreen, arguments: readAsBytesSync);
    }
  }

  /// Callback to receive each frame [CameraImage] perform inference on it
  void onLatestImageAvailable(CameraImage cameraImage) {
    _detector?.processFrame(cameraImage);
  }
}

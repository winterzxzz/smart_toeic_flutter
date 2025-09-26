import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'dart:io';
import 'dart:async';
import 'package:toeic_desktop/main.dart';

class ObjectDetectionScreen extends StatefulWidget {
  const ObjectDetectionScreen({
    super.key,
  });

  @override
  State<ObjectDetectionScreen> createState() => _ObjectDetectionScreenState();
}

class _ObjectDetectionScreenState extends State<ObjectDetectionScreen> {
  late CameraController _cameraController;
  bool isCameraReady = false;
  String result = "Tap capture to detect objects";
  late ImageLabeler _imageLabeler;
  bool isDetecting = false;
  bool isCapturing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeMLKit();
  }

  /// Initialize Camera
  Future<void> _initializeCamera() async {
    _cameraController = CameraController(cameras[0], ResolutionPreset.ultraHigh,
        enableAudio: false, fps: 60);

    await _cameraController.initialize();
    if (!mounted) return;

    setState(() {
      isCameraReady = true;
    });
  }

  /// Initialize ML Kit
  void _initializeMLKit() {
    _imageLabeler = ImageLabeler(
      options: ImageLabelerOptions(confidenceThreshold: 0.8),
    );
  }

  /// Capture and Detect Objects
  Future<void> _captureAndDetect() async {
    if (isDetecting || isCapturing) return;

    setState(() {
      isCapturing = true;
      result = "Capturing...";
    });

    try {
      // Take a picture
      final XFile picture = await _cameraController.takePicture();

      setState(() {
        result = "Processing image...";
      });

      // Process the captured image
      await _processImage(picture);
    } catch (e) {
      setState(() {
        result = "Error: $e";
      });
    } finally {
      setState(() {
        isCapturing = false;
      });
    }
  }

  /// Process Captured Image
  Future<void> _processImage(XFile imageFile) async {
    try {
      isDetecting = true;

      final inputImage = InputImage.fromFile(File(imageFile.path));
      final List<ImageLabel> labels =
          await _imageLabeler.processImage(inputImage);

      String detectedObjects = labels.isNotEmpty
          ? labels
              .map(
                (label) =>
                    "${label.label} - ${(label.confidence * 100).toStringAsFixed(2)}%",
              )
              .join("\n")
          : "No object detected";

      if (mounted) {
        setState(() {
          result = detectedObjects;
        });
      }

      // Clean up the temporary file
      await File(imageFile.path).delete();
    } catch (e) {
      if (mounted) {
        setState(() {
          result = "Error processing image: $e";
        });
      }
    } finally {
      isDetecting = false;
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _imageLabeler.close();
    super.dispose();
  }

  MediaQueryData? mqData;
  @override
  Widget build(BuildContext context) {
    mqData = MediaQuery.of(context);
    return Scaffold(
      /// -------------- Appbar --------------------- ///
      appBar: AppBar(
        backgroundColor: const Color(0xff213555),
        title: const Text(
          "Real-time Object Detection",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        leading: Image.asset(
          "assets/icons/object.png",
          color: Colors.blue,
        ),
      ),
      backgroundColor: const Color(0xff3E5879),

      ///----------------- BODY --------------------///
      body: SingleChildScrollView(
        child: Stack(
          children: [
            /// Camera Preview
            Center(
              child: SizedBox(
                width: mqData!.size.width,
                child: isCameraReady
                    ? CameraPreview(_cameraController)
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),

            /// Capture Button
            Positioned(
              bottom: 200,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: isCapturing || isDetecting ? null : _captureAndDetect,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCapturing || isDetecting
                          ? Colors.grey
                          : Colors.white,
                      border: Border.all(
                        color: isCapturing || isDetecting
                            ? Colors.grey
                            : Colors.orange,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: isCapturing || isDetecting
                        ? const Center(
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.orange),
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: Colors.orange,
                          ),
                  ),
                ),
              ),
            ),

            /// Detection Result
            Positioned(
              bottom: 0,
              child: Container(
                width: mqData!.size.width,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0x5af0bb78),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Detected Objects",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          const BoxShadow(color: Colors.black12, blurRadius: 4),
                        ],
                      ),
                      child: Text(
                        result,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'dart:io';
import 'dart:async';
import 'package:toeic_desktop/main.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';

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

  // New state for selection functionality
  List<ImageLabel> detectedObjects = [];
  Set<String> selectedItems = {};

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

      String detectedObjectsText = labels.isNotEmpty
          ? labels
              .map(
                (label) =>
                    "${label.label} - ${(label.confidence * 100).toStringAsFixed(2)}%",
              )
              .join("\n")
          : "No object detected";

      if (mounted) {
        setState(() {
          detectedObjects = labels;
          result = detectedObjectsText;
          selectedItems.clear(); // Clear previous selections
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

  /// Toggle item selection
  void _toggleItemSelection(String itemKey) {
    setState(() {
      if (selectedItems.contains(itemKey)) {
        selectedItems.remove(itemKey);
      } else {
        selectedItems.add(itemKey);
      }
    });
  }

  /// Save selected items
  void _saveSelectedItems() {
    if (selectedItems.isEmpty) return;

    // Get selected labels
    final selectedLabels = detectedObjects
        .where((label) => selectedItems.contains(_getItemKey(label)))
        .toList();

    // Here you can implement your save logic
    // For now, we'll show a snackbar with the selected items
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Saved ${selectedLabels.length} items: ${selectedLabels.map((l) => l.label).join(', ')}',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );

    // Clear selections after saving
    setState(() {
      selectedItems.clear();
    });
  }

  /// Generate unique key for each detected item
  String _getItemKey(ImageLabel label) {
    return '${label.label}_${label.confidence}';
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
    final textTheme = context.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detect Objects",
          style: textTheme.titleLarge,
        ),
        leading: const LeadingBackButton(),
        actions: [
          TextButton(
            onPressed: selectedItems.isNotEmpty ? _saveSelectedItems : null,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Full screen camera preview with tap-to-capture
          Positioned.fill(
            child: isCameraReady
                ? GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap:
                        isCapturing || isDetecting ? null : _captureAndDetect,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CameraPreview(_cameraController),
                        // Guidance overlay (top of screen)
                        Positioned(
                          top: 16,
                          left: 0,
                          right: 0,
                          child: SafeArea(
                            bottom: false,
                            left: false,
                            right: false,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.35),
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.touch_app,
                                      color:
                                          Colors.white.withValues(alpha: 0.95),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      isCapturing || isDetecting
                                          ? 'Processing...'
                                          : 'Tap anywhere to capture',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const Center(child: LoadingCircle()),
          ),
          // Results panel - positioned to not hide capture button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              constraints: BoxConstraints(
                maxHeight:
                    mqData!.size.height * 0.4, // Limit height to 40% of screen
              ),
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0x5af0bb78),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (detectedObjects.isNotEmpty)
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              const BoxShadow(
                                  color: Colors.black12, blurRadius: 4),
                            ],
                          ),
                          child: Column(
                            children: [
                              if (detectedObjects.isNotEmpty)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Select items to save',
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 8),
                              ...detectedObjects.map((label) {
                                final itemKey = _getItemKey(label);
                                final isSelected =
                                    selectedItems.contains(itemKey);

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: InkWell(
                                    onTap: () => _toggleItemSelection(itemKey),
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.orange
                                                .withValues(alpha: 0.1)
                                            : Colors.grey[50],
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.orange
                                              : Colors.grey[300]!,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: isSelected,
                                            onChanged: (_) =>
                                                _toggleItemSelection(itemKey),
                                            activeColor: Colors.orange,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  label.label,
                                                  style: textTheme.bodyLarge
                                                      ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: isSelected
                                                        ? Colors.orange[800]
                                                        : Colors.black87,
                                                  ),
                                                ),
                                                Text(
                                                  'Confidence: ${(label.confidence * 100).toStringAsFixed(1)}%',
                                                  style: textTheme.bodySmall
                                                      ?.copyWith(
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
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
}

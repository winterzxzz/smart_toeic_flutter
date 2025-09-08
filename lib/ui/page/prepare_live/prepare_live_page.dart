import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toeic_desktop/main.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/page/prepare_live/widgets/prepare_live_footer.dart';
import 'package:toeic_desktop/ui/page/prepare_live/widgets/prepare_live_header.dart';
import 'package:toeic_desktop/ui/page/prepare_live/widgets/prepare_live_menu.dart';

class PrepareLivePage extends StatefulWidget {
  const PrepareLivePage({super.key});

  @override
  State<PrepareLivePage> createState() => _PrepareLivePageState();
}

class _PrepareLivePageState extends State<PrepareLivePage> {
  late CameraController _cameraController;
  bool _isCameraActive = false;
  bool _isInitialized = false;
  late CameraDescription _currentDescription;

  @override
  void initState() {
    super.initState();
    _initializeRenderers();
    _requestPermissions();
  }

  void _requestPermissions() async {
    final permissions = await Permission.camera.request();
    if (permissions.isGranted) {
      _initializeRenderers();
    } else {
      debugPrint('Winter-Camera permission denied');
    }
  }

  void _initializeRenderers() async {
    if (cameras.length < 2) return;
    try {
      // Fallback to first camera if second doesn't exist
      _currentDescription = cameras.length > 1 ? cameras[1] : cameras.first;

      _cameraController = CameraController(
        _currentDescription,
        ResolutionPreset.medium,
      );

      await _cameraController.initialize();

      if (!mounted) return;

      setState(() {
        _isCameraActive = true;
        _isInitialized = true;
      });

      debugPrint('Winter-Camera initialized: ${_currentDescription.name}');
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          debugPrint('Winter-CameraAccessDenied');
          break;
        default:
          debugPrint('Winter-CameraException: ${e.code} - ${e.description}');
          break;
      }
    } catch (e) {
      debugPrint('Winter-Unknown camera error: $e');
    }
  }

  void _switchCamera() async {
    if (cameras.length < 2) return;

    final CameraDescription newDescription = cameras.firstWhere(
      (desc) => desc.lensDirection != _currentDescription.lensDirection,
      orElse: () => _currentDescription,
    );

    try {
      if (_cameraController.value.isInitialized) {
        await _cameraController.dispose();
      }
      final CameraController newController =
          CameraController(newDescription, ResolutionPreset.high);
      await newController.initialize();
      if (!mounted) return;
      _cameraController = newController;
      setState(() {
        _currentDescription = newDescription;
        _isCameraActive = true;
        _isInitialized = true;
      });
      debugPrint('Winter-Switched to camera: ${newDescription.name}');
    } catch (e) {
      debugPrint('Winter-Error switching camera: $e');
    }
  }

  void _toggleCamera() async {
    try {
      if (_isCameraActive) {
        if (_cameraController.value.isInitialized) {
          await _cameraController.dispose();
        }
        if (!mounted) return;
        setState(() {
          _isCameraActive = false;
          // Keep _isInitialized true to indicate prior initialization
        });
        debugPrint('Winter-Camera paused (disposed)');
      } else {
        final CameraController newController =
            CameraController(_currentDescription, ResolutionPreset.high);
        await newController.initialize();
        if (!mounted) return;
        _cameraController = newController;
        setState(() {
          _isCameraActive = true;
          _isInitialized = true;
        });
        debugPrint('Winter-Camera resumed (reinitialized)');
      }
    } catch (e) {
      debugPrint('Winter-Error toggling camera (dispose/reinit): $e');
    }
  }

  @override
  void dispose() {
    _cleanupCamera();
    super.dispose();
  }

  void _cleanupCamera() async {
    _cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = context.sizze.height;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(
          children: [
            // Full screen video background
            Positioned.fill(
              child: !_isInitialized
                  ? Container(
                      color: Colors.black,
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Initializing camera...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : _isCameraActive
                      ? FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width:
                                _cameraController.value.previewSize?.height ??
                                    1,
                            height:
                                _cameraController.value.previewSize?.width ?? 1,
                            child: CameraPreview(_cameraController),
                          ),
                        )
                      : Container(
                          color: Colors.black,
                          child: const Center(
                            child: Text(
                              'Camera is paused',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
            ),
            // Header overlay
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: PrepareLiveHeader(),
              ),
            ),
            // Footer overlay
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: PrepareLiveFooter(),
              ),
            ),

            Positioned(
              top: height * 0.15,
              right: 10,
              child: SafeArea(
                child: PrepareLiveMenu(
                    onSwitchCamera: _switchCamera,
                    onToggleCamera: _toggleCamera),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

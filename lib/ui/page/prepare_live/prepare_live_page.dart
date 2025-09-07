import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toeic_desktop/ui/page/prepare_live/widgets/prepare_live_footer.dart';
import 'package:toeic_desktop/ui/page/prepare_live/widgets/prepare_live_header.dart';

class PrepareLivePage extends StatefulWidget {
  const PrepareLivePage({super.key});

  @override
  State<PrepareLivePage> createState() => _PrepareLivePageState();
}

class _PrepareLivePageState extends State<PrepareLivePage> {
  late final RTCVideoRenderer _localRenderer;
  MediaStream? _localStream;
  bool _isCameraActive = false;

  @override
  void initState() {
    super.initState();
    _localRenderer = RTCVideoRenderer();
    _initializeRenderers();
    _requestPermissions();
  }

  void _requestPermissions() async {
    final permissions = await Permission.camera.request();
    if (permissions.isGranted) {
      _bindLocalVideo();
    } else {
      debugPrint('Camera permission denied');
      // Handle permission denied case
    }
  }

  void _initializeRenderers() async {
    await _localRenderer.initialize();
  }

  void _bindLocalVideo() async {
    try {
      final Map<String, dynamic> mediaConstraints = {
        'audio': false,
        'video': {
          'mandatory': {
            'minWidth': '640',
            'minHeight': '480',
            'minFrameRate': '30',
          },
          'facingMode': 'user',
          'optional': [],
        }
      };

      final MediaStream stream =
          await navigator.mediaDevices.getUserMedia(mediaConstraints);
      _localStream = stream;
      _localRenderer.srcObject = stream;

      setState(() {
        _isCameraActive = true;
      });
    } catch (e) {
      debugPrint('Error accessing camera: $e');
      setState(() {
        _isCameraActive = false;
      });
      // Handle error - maybe show a dialog or fallback UI
    }
  }

  @override
  void dispose() {
    _cleanupCamera();
    _localRenderer.dispose();
    super.dispose();
  }

  void _cleanupCamera() async {
    try {
      if (_localStream != null) {
        if (kIsWeb) {
          _localStream!.getTracks().forEach((track) => track.stop());
        }
        await _localStream!.dispose();
        _localStream = null;
      }
      _localRenderer.srcObject = null;
    } catch (e) {
      debugPrint('Error cleaning up camera: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(
          children: [
            // Full screen video background
            Positioned.fill(
              child: _isCameraActive
                  ? RTCVideoView(
                      _localRenderer,
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    )
                  : Container(
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
          ],
        ),
      ),
    );
  }
}

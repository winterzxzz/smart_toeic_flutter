import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/data/database/secure_storage_helper.dart';

class TestAudioSection extends StatefulWidget {
  const TestAudioSection({
    super.key,
    required this.audioUrl,
  });

  final String audioUrl;

  @override
  State<TestAudioSection> createState() => _TestAudioSectionState();
}

class _TestAudioSectionState extends State<TestAudioSection> {
  AudioPlayer? _audioPlayer;
  Duration? _duration;
  Duration? _position;
  bool _initialized = false;
  bool _isPlaying = false;
  bool _isCompleted = false;
  String? _cookie;

  @override
  void initState() {
    super.initState();
    _loadCookieAndInit();
  }

  Future<void> _loadCookieAndInit() async {
    final cookie = await SecureStorageHelper.instance.getCookies();
    setState(() {
      _cookie = cookie;
    });

    _audioPlayer = AudioPlayer();

    _audioPlayer?.durationStream.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    _audioPlayer?.positionStream.listen((position) {
      setState(() {
        _position = position;
      });
    });

    _audioPlayer?.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          _isCompleted = true;
          _isPlaying = false;
        });
      }
    });

    _audioPlayer?.playingStream.listen((playing) {
      setState(() {
        _isPlaying = playing;
      });
    });
  }

  Future<void> _initAudioPlayer() async {
    if (_initialized || _cookie == null) return;
    await _audioPlayer?.setUrl(widget.audioUrl, headers: {
      HttpHeaders.cookieHeader: _cookie!,
    });
    setState(() {
      _initialized = true;
    });
  }

  void _handleSeekStart(double p) {
    _audioPlayer?.pause();
  }

  void _handleSeekUpdate(double p) {
    _audioPlayer?.seek(Duration(seconds: p.toInt()));
  }

  void _handleSeekEnd(double p) {
    _audioPlayer?.seek(Duration(seconds: p.toInt()));
    _audioPlayer?.play();
    setState(() {
      _position = Duration(seconds: p.toInt());
    });
  }

  void _handleTapPlayPause() async {
    await _initAudioPlayer();
    if (_isCompleted) {
      setState(() {
        _position = Duration.zero;
        _isCompleted = false;
        _isPlaying = true;
      });
      await _audioPlayer?.seek(Duration.zero);
      await _audioPlayer?.play();
    } else {
      if (_isPlaying && _audioPlayer?.playing == true) {
        await _audioPlayer?.pause();
      } else {
        await _audioPlayer?.play();
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    return Container(
      height: 44,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: _handleTapPlayPause,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppColors.textWhite,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      formatDuration(_position ?? Duration.zero),
                      style: textTheme.bodyMedium
                          ?.copyWith(fontSize: 10, color: Colors.white),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 4,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 16,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        child: Slider(
                          activeColor: AppColors.textWhite,
                          inactiveColor: AppColors.gray1,
                          min: 0,
                          max: _duration?.inSeconds.toDouble() ?? 0,
                          value: _position?.inSeconds.toDouble() ?? 0,
                          onChangeStart: _handleSeekStart,
                          onChanged: _handleSeekUpdate,
                          onChangeEnd: _handleSeekEnd,
                        ),
                      ),
                    ),
                    Text(
                      formatDuration(_duration ?? Duration.zero),
                      style: textTheme.bodyMedium
                          ?.copyWith(fontSize: 10, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}

String formatDuration(Duration duration) {
  final minutes = duration.inMinutes;
  final seconds = duration.inSeconds % 60;
  final minutesStr = minutes < 10 ? '0$minutes' : '$minutes';
  final secondsStr = seconds < 10 ? '0$seconds' : '$seconds';
  return '$minutesStr:$secondsStr';
}

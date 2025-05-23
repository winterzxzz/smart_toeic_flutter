import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

class AudioSection extends StatefulWidget {
  const AudioSection({
    super.key,
    required this.audioUrl,
  });

  final String audioUrl;

  @override
  State<AudioSection> createState() => _AudioSectionState();
}

class _AudioSectionState extends State<AudioSection> {
  AudioPlayer? _audioPlayer;
  Duration? _duration;
  Duration? _position;
  bool _isPlaying = false;
  bool _isCompleted = false;

  void initAudioPlayer() async {
    if (_audioPlayer == null) {
      _audioPlayer = AudioPlayer();
      await _audioPlayer!.setSourceUrl(widget.audioUrl);
      _duration = await _audioPlayer!.getDuration();
      _audioPlayer!.onPositionChanged.listen((Duration p) {
        if (mounted) {
          if (_isCompleted) {
            setState(() {
              _isCompleted = false;
              _position = p;
            });
          } else {
            setState(() {
              _position = p;
            });
          }
        }
      });

      _audioPlayer!.onPlayerComplete.listen((_) {
        if (mounted) {
          setState(() {
            _isCompleted = true;
            _isPlaying = false;
          });
        }
      });
      setState(() {});
    }
  }

  void _handleSeekStart(double p) {
    _audioPlayer?.pause();
  }

  void _handleSeekUpdate(double p) {
    _audioPlayer?.seek(Duration(seconds: p.toInt()));
  }

  void _handleSeekEnd(double p) {
    _audioPlayer?.resume();
    setState(() {
      _isPlaying = true;
      _position = Duration(seconds: p.toInt());
    });
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 60,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: handleTapPlayPause,
                child: Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? AppColors.backgroundDark
                        : AppColors.backgroundLight,
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
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 8,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 16,
                    ),
                  ),
                  child: Slider(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
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
            ],
          ),
          Positioned(
            top: 10,
            left: 78,
            right: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDuration(_position ?? Duration.zero),
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontSize: 10, color: Colors.white),
                ),
                Text(
                  formatDuration(_duration ?? Duration.zero),
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontSize: 10, color: Colors.white),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void handleTapPlayPause() async {
    initAudioPlayer();
    if (_isCompleted) {
      await _audioPlayer?.seek(Duration.zero).then((value) {
        setState(() {
          _position = Duration.zero;
          _isCompleted = false;
          _isPlaying = true;
        });
      });
    }
    if (_isPlaying) {
      await _audioPlayer?.pause().then((value) {
        setState(() {
          _isPlaying = false;
        });
      });
    } else {
      await _audioPlayer?.resume().then((value) {
        setState(() {
          _isPlaying = true;
        });
      });
    }
  }
}

String formatDuration(Duration duration) {
  final minutes = duration.inMinutes;
  final seconds = duration.inSeconds % 60;

  String minutesStr = minutes.toString();
  String secondsStr = seconds.toString();
  if (minutes < 10) {
    minutesStr = '0$minutes';
  }
  if (seconds < 10) {
    secondsStr = '0$seconds';
  }
  return '$minutesStr:$secondsStr';
}

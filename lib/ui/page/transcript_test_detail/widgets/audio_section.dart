import 'package:just_audio/just_audio.dart';
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
  bool _isPlaying = true;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer()
      ..setUrl(widget.audioUrl)
      ..play()
      ..durationStream.listen((duration) {
        setState(() {
          _duration = duration;
        });
      })
      ..playingStream.listen((playing) {
        setState(() {
          _isPlaying = playing;
        });
      })
      ..positionStream.listen((position) {
        setState(() {
          _position = position;
        });
      })
      ..playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            _isCompleted = true;
            _isPlaying = false;
          });
        }
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
    final theme = Theme.of(context);
    return Container(
      height: 60,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
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
                  height: 56,
                  width: 56,
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
              const SizedBox(width: 8),
            ],
          ),
          Positioned(
            top: 10,
            left: 78,
            right: 16,
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

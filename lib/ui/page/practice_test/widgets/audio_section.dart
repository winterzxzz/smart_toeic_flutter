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

  void initAudioPlayer() async {
    if (_audioPlayer == null) {
      _audioPlayer = AudioPlayer();
      await _audioPlayer!.setSourceUrl(widget.audioUrl);
      _duration = await _audioPlayer!.getDuration();
      _audioPlayer!.onPositionChanged.listen((Duration p) {
        if (mounted) {
          setState(() {
            _position = p;
          });
        }
      });

      _audioPlayer!.onPlayerComplete.listen((_) {
        if (mounted) {
          setState(() {
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.gray3,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    initAudioPlayer();
                    if (_isPlaying) {
                      _audioPlayer?.pause();
                    } else {
                      _audioPlayer?.resume();
                    }
                    setState(() {
                      _isPlaying = !_isPlaying;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.black,
                      size: 28,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    SliderTheme(
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatDuration(_position ?? Duration.zero),
                            style: const TextStyle(
                              color: AppColors.textWhite,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            formatDuration(_duration ?? Duration.zero),
                            style: const TextStyle(
                              color: AppColors.textWhite,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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

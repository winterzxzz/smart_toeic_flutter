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
      margin: EdgeInsets.only(bottom: 16, right: 16),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.gray3,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
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
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: _isPlaying
                  ? Icon(
                      Icons.pause,
                      color: Colors.black,
                    )
                  : Icon(
                      Icons.play_arrow,
                      color: Colors.black,
                    ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
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
                SizedBox(width: 8),
                Text(
                  formatDuration(_position ?? Duration.zero),
                  style: TextStyle(color: AppColors.textWhite),
                ),
                SizedBox(width: 16),
              ],
            ),
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

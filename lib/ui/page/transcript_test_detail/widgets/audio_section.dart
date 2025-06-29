import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_cubit.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_state.dart';

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

  // Stream subscriptions for proper cleanup
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<bool>? _playingSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    _initializeAudioPlayer();
  }

  void _initializeAudioPlayer() {
    _audioPlayer = AudioPlayer();

    _audioPlayer?.setUrl(widget.audioUrl).then((_) {
      if (mounted) {
        _audioPlayer?.play();
      }
    });

    _durationSubscription = _audioPlayer?.durationStream.listen((duration) {
      if (mounted) {
        setState(() {
          _duration = duration;
        });
      }
    });

    _playingSubscription = _audioPlayer?.playingStream.listen((playing) {
      if (mounted) {
        setState(() {
          _isPlaying = playing;
        });
      }
    });

    _positionSubscription = _audioPlayer?.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }
    });

    _playerStateSubscription = _audioPlayer?.playerStateStream.listen((state) {
      if (mounted && state.processingState == ProcessingState.completed) {
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
    if (mounted) {
      setState(() {
        _position = Duration(seconds: p.toInt());
      });
    }
  }

  void _handleTapPlayPause() async {
    if (_isCompleted) {
      if (mounted) {
        setState(() {
          _position = Duration.zero;
          _isCompleted = false;
          _isPlaying = true;
        });
      }
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
    // Cancel all stream subscriptions
    _durationSubscription?.cancel();
    _playingSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();

    // Dispose audio player
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<TranscriptTestDetailCubit, TranscriptTestDetailState>(
      listenWhen: (previous, current) =>
          previous.isShowAiVoice != current.isShowAiVoice,
      listener: (context, state) {
        if (state.isShowAiVoice) {
          _audioPlayer?.pause();
        }
      },
      child: Container(
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

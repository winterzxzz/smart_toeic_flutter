import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/transcript_test.dart';
import 'package:toeic_desktop/data/services/transcript_checker_service.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_state.dart';
import 'package:toeic_desktop/vosk_service.dart';

class TranscriptTestDetailCubit extends Cubit<TranscriptTestDetailState> {
  final TranscriptTestRepository _transcriptTestRepository;
  final TranscriptCheckerService _transcriptCheckerService;
  final SpeechToText speechToText = SpeechToText();
  final VoskService _voskService;

  Timer? _animationTimer;

  Timer? _showAiVoiceTimer;

  TranscriptTestDetailCubit({
    required TranscriptTestRepository transcriptTestRepository,
    required TranscriptCheckerService transcriptCheckerService,
    required VoskService voskService,
  })  : _transcriptTestRepository = transcriptTestRepository,
        _transcriptCheckerService = transcriptCheckerService,
        _voskService = voskService,
        super(TranscriptTestDetailState.initial());

  void safeEmit(TranscriptTestDetailState newState) {
    if (!isClosed) emit(newState);
  }

  void initShowAiVoiceTimer() {
    _showAiVoiceTimer?.cancel();
    _showAiVoiceTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      stopListening();
    });
  }

  void cancelShowAiVoiceTimer() {
    _showAiVoiceTimer?.cancel();
    _showAiVoiceTimer = null;
  }

  Future<void> getTranscriptTestDetail(String transcriptTestId) async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final transcriptTestDetail = await _transcriptTestRepository
        .getTranscriptTestDetail(transcriptTestId);
    transcriptTestDetail.fold(
      (l) => emit(
          state.copyWith(loadStatus: LoadStatus.failure, message: l.message)),
      (r) => emit(
          state.copyWith(loadStatus: LoadStatus.success, transcriptTests: r)),
    );
  }

  void nextTranscriptTest() {
    _animationTimer?.cancel();
    if (state.currentIndex < state.transcriptTests.length - 1) {
      emit(state.copyWith(
        currentIndex: state.currentIndex + 1,
        isCheck: false,
        isCorrect: false,
        userInput: '',
      ));
    }
  }

  void goToTranscriptTest(int index) {
    if (index >= 0 && index < state.transcriptTests.length) {
      emit(state.copyWith(
        currentIndex: index,
        isCheck: false,
        isCorrect: false,
        userInput: '',
      ));
    }
  }

  void handleCheck(String userInput) {
    debugPrint('winter-handleCheck userInput: $userInput');
    final currentTranscriptQuestion = state.transcriptTests[state.currentIndex];
    final result = _transcriptCheckerService.checkTranscription(
      userInput: userInput,
      correctTranscript: currentTranscriptQuestion.transcript!,
    );

    emit(state.copyWith(
      isCheck: true,
      checkResults: result.results,
      isCorrect: result.isAllCorrect,
      userInput: userInput,
      isShowAiVoice: false,
    ));

    if (state.isCorrect) {
      _animationTimer?.cancel();
      _animationTimer = Timer(const Duration(seconds: 3), () {
        nextTranscriptTest();
      });
    }
  }

  void toggleIsCheck() {
    emit(state.copyWith(isCheck: !state.isCheck));
  }

  void toggleIsShowAiVoice() async {
    if (state.isShowAiVoice) {
      await cancelListening();
      cancelShowAiVoiceTimer();
    } else {
      await startListening().then((_) {
        emit(state.copyWith(isShowAiVoice: true));
        initShowAiVoiceTimer();
      });
    }
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize(
      finalTimeout: const Duration(seconds: 30),
      onError: (error) {
        //    stopListening();
      },
    );
    emit(state.copyWith(isInitSpeechToText: true));
  }

  Future<void> cancelListening() async {
    await speechToText.cancel();
    emit(state.copyWith(isShowAiVoice: false));
  }

  Future<void> startListening() async {
    if (!state.isInitSpeechToText) {
      await initSpeechToText();
    }
    await speechToText.listen(
      listenOptions: SpeechListenOptions(
        sampleRate: 44100,
        listenMode: ListenMode.dictation,
        partialResults: false,
        cancelOnError: false,
      ),
      localeId: 'en_US',
      listenFor: const Duration(seconds: 60),
      pauseFor: const Duration(seconds: 10),
      onSoundLevelChange: (level) {
        if (level >= 3 &&
            _showAiVoiceTimer != null &&
            _showAiVoiceTimer!.isActive) {
          debugPrint('winter-onSoundLevelChange: cancelShowAiVoiceTimer');
          cancelShowAiVoiceTimer();
        }
      },
      onResult: (result) {
        emit(state.copyWith(
          userInput: result.recognizedWords,
          isShowAiVoice: false,
        ));
      },
    );
  }

  Future<void> stopListening() async {
    debugPrint('winter-stopListening stopListening');
    await speechToText.stop();
    safeEmit(state.copyWith(isShowAiVoice: false));
  }

  Future<void> startListeningVosk() async {
    safeEmit(state.copyWith(isShowAiVoice: true));
    await _voskService.startListening();
  }

  Future<void> stopListeningVosk() async {
    safeEmit(state.copyWith(isShowAiVoice: false));
    final result = await _voskService.stopListening();
    debugPrint('VoskManager: $result');
    // convert result from json to string
    final resultString = jsonDecode(result);
    safeEmit(state.copyWith(userInput: resultString['text']));
  }

  @override
  Future<void> close() {
    speechToText.cancel();
    _animationTimer?.cancel();
    return super.close();
  }
}

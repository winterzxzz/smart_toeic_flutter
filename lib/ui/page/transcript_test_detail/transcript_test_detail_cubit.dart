import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/transcript_test.dart';
import 'package:toeic_desktop/data/services/stt_service.dart';
import 'package:toeic_desktop/data/services/transcript_checker_service.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_state.dart';

class TranscriptTestDetailCubit extends Cubit<TranscriptTestDetailState> {
  final TranscriptTestRepository _transcriptTestRepository;
  final TranscriptCheckerService _transcriptCheckerService;
  final SpeechService _speechService;

  Timer? _animationTimer;
  StreamSubscription<SpeechStatus>? _statusSubscription;

  TranscriptTestDetailCubit({
    required TranscriptTestRepository transcriptTestRepository,
    required TranscriptCheckerService transcriptCheckerService,
    required SpeechService speechService,
  })  : _transcriptTestRepository = transcriptTestRepository,
        _transcriptCheckerService = transcriptCheckerService,
        _speechService = speechService,
        super(TranscriptTestDetailState.initial()) {
    _statusSubscription = _speechService.statusStream.listen((status) {
      if (status == SpeechStatus.error) {
        onErrorStt(status);
      } else {
        onStatusStt(status);
      }
    });
  }

  Future<void> getTranscriptTestDetail(String transcriptTestId) async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final transcriptTestDetail = await _transcriptTestRepository
        .getTranscriptTestDetail(transcriptTestId);
    transcriptTestDetail.fold(
      (l) {
        emit(
            state.copyWith(loadStatus: LoadStatus.failure, message: l.message));
        showToast(title: l.message, type: ToastificationType.error);
      },
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
    } else {
      await startListening().then((_) {
        emit(state.copyWith(isShowAiVoice: true));
      });
    }
  }

  void onStatusStt(SpeechStatus status) {
    debugPrint('winter-onStatus: $status');
  }

  void onErrorStt(SpeechStatus error) {
    stopListening();
    debugPrint('winter-onError: $error');
  }

  Future<void> cancelListening() async {
    _speechService.cancelListening();
    emit(state.copyWith(isShowAiVoice: false));
  }

  Future<void> startListening() async {
    if (!_speechService.isInitialized) {
      await _speechService.initialize();
    }
    _speechService.startListening(onResult);
  }

  void onResult(String result) {
    debugPrint('winter-onResult: $result');
    emit(state.copyWith(userInput: result, isShowAiVoice: false));
  }

  Future<void> stopListening() async {
    _speechService.stopListening();
    emit(state.copyWith(isShowAiVoice: false));
  }

  @override
  Future<void> close() {
    _statusSubscription?.cancel();
    _speechService.cancelListening();
    _animationTimer?.cancel();
    return super.close();
  }
}

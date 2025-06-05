import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/transcript_test.dart';
import 'package:toeic_desktop/data/services/transcript_checker_service.dart';
import 'package:toeic_desktop/ui/page/transcript_test_detail/transcript_test_detail_state.dart';

class TranscriptTestDetailCubit extends Cubit<TranscriptTestDetailState> {
  final TranscriptTestRepository _transcriptTestRepository;
  final TranscriptCheckerService _transcriptCheckerService;

  Timer? _animationTimer;

  TranscriptTestDetailCubit({
    required TranscriptTestRepository transcriptTestRepository,
    required TranscriptCheckerService transcriptCheckerService,
  })  : _transcriptTestRepository = transcriptTestRepository,
        _transcriptCheckerService = transcriptCheckerService,
        super(TranscriptTestDetailState.initial());

  Future<void> getTranscriptTestDetail(String transcriptTestId) async {
    Future.microtask(() {
      emit(state.copyWith(loadStatus: LoadStatus.loading));
    });
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
          userInput: ''));
    }
  }

  void goToTranscriptTest(int index) {
    if (index >= 0 && index < state.transcriptTests.length) {
      emit(state.copyWith(
          currentIndex: index,
          isCheck: false,
          isCorrect: false,
          userInput: ''));
    }
  }

  void handleCheck(String userInput) {
    final currentTranscriptQuestion = state.transcriptTests[state.currentIndex];
    final result = _transcriptCheckerService.checkTranscription(
        userInput: userInput,
        correctTranscript: currentTranscriptQuestion.transcript!);

    emit(state.copyWith(
      isCheck: true,
      checkResults: result.results,
      isCorrect: result.isAllCorrect,
      userInput: userInput,
    ));

    _animationTimer?.cancel();
    _animationTimer = Timer(const Duration(seconds: 3), () {
      if (state.isCorrect) {
        nextTranscriptTest();
      }
    });
  }

  void toggleIsCheck() {
    emit(state.copyWith(isCheck: !state.isCheck));
  }

  void toggleIsShowAiVoice() {
    emit(state.copyWith(isShowAiVoice: !state.isShowAiVoice));
  }
}

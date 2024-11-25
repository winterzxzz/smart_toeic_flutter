import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/data/models/ui_models/question.dart';
import 'package:toeic_desktop/data/network/repositories/practice_test_repository.dart';
import 'package:toeic_desktop/ui/page/practice_test/practice_test_state.dart';

class PracticeTestCubit extends Cubit<PracticeTestState> {
  final PracticeTestRepository _practiceTestRepository;

  PracticeTestCubit(this._practiceTestRepository)
      : super(PracticeTestState.initial());

  final AudioPlayer _audioPlayer = AudioPlayer();

  void setUrlAudio(String url) async {
    await _audioPlayer.setSourceUrl(url).then((_) async {
      await _audioPlayer.resume();
    });
  }

  Future<void> getPracticeTestDetail() async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final questions = await _practiceTestRepository.getPracticeTestDetail();
    emit(state.copyWith(
      questions: questions,
      loadStatus: LoadStatus.success,
      questionsOfPart: questions
          .where((question) => question.part == state.focusPart.numValue)
          .toList(),
    ));
  }

  void initPracticeTest(List<PartEnum> parts, Duration duration) async {
    emit(state.copyWith(parts: parts, duration: duration));
    await getPracticeTestDetail();
  }

  void setFocusQuestion(Question question) {
    final partOfQuestion = question.part;
    final questionsOfPart = state.questions
        .where((question) => question.part == partOfQuestion)
        .toList();
    if (partOfQuestion == state.focusPart.numValue) {
      emit(state.copyWith(
        focusQuestion: question.id,
        questionsOfPart: questionsOfPart,
      ));
    } else {
      emit(state.copyWith(
        focusQuestion: question.id,
        questionsOfPart: questionsOfPart,
        focusPart: partOfQuestion.partValue,
      ));
    }
  }

  void setFocusPart(PartEnum part) {
    final firstQuestionOfPart = state.questions
        .where((question) => question.part == part.numValue)
        .first;
    final questionsOfPart = state.questions
        .where((question) => question.part == part.numValue)
        .toList();
    emit(state.copyWith(
      focusPart: part,
      focusQuestion: firstQuestionOfPart.id,
      questionsOfPart: questionsOfPart,
    ));
  }

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    return super.close();
  }
}

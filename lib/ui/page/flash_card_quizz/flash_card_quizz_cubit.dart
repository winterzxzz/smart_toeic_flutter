import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/flash_card_respository.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/flash_card_quizz_state.dart';

class FlashCardQuizzCubit extends Cubit<FlashCardQuizzState> {
  final FlashCardRespository _flashCardRepository;
  FlashCardQuizzCubit(this._flashCardRepository)
      : super(FlashCardQuizzState.initial());

  void init(String newLearningSetId) async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final rs =
        await _flashCardRepository.updateFlashCardLearning(newLearningSetId);
    rs.fold(
        (l1) => emit(state.copyWith(
            loadStatus: LoadStatus.failure,
            message: l1.errors?.first.message)), (r1) async {
      final rs2 = await _flashCardRepository.getFlashCardsLearning(r1.id!);
      rs2.fold(
          (l2) => emit(state.copyWith(
              loadStatus: LoadStatus.failure,
              message: l2.errors?.first.message)),
          (r2) => emit(state.copyWith(
              loadStatus: LoadStatus.success, flashCardLearning: r2)));
    });
  }

  void previous() {
    emit(state.copyWith(currentIndex: state.currentIndex - 1));
  }

  void next() {
    if (state.currentIndex < state.flashCardLearning.length - 1) {
      emit(state.copyWith(currentIndex: state.currentIndex + 1));
    } else {
      nextTypeQuizz();
    }
  }

  void previousTypeQuizz() {
    emit(state.copyWith(typeQuizzIndex: state.typeQuizzIndex - 1));
  }

  void nextTypeQuizz() {
    emit(state.copyWith(typeQuizzIndex: state.typeQuizzIndex + 1));
  }
}

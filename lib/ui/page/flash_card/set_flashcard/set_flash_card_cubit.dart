import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/network/repositories/flash_card_respository.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/flash_card/set_flashcard/set_flash_card_state.dart';

class FlashCardCubit extends Cubit<FlashCardState> {
  final FlashCardRespository _flashCardRespository;
  FlashCardCubit(this._flashCardRespository) : super(FlashCardState.initial());

  Future<void> fetchFlashCardSets() async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    final response = await _flashCardRespository.getSetFlashCards();
    response.fold(
      (l) {
        emit(state.copyWith(
          loadStatus: LoadStatus.failure,
          message: l.message,
        ));
        showToast(
          title: l.message,
          type: ToastificationType.error,
        );
      },
      (r) => emit(state.copyWith(
        loadStatus: LoadStatus.success,
        flashCards: r,
      )),
    );
  }

  Future<void> fetchFlashCardSetsLearning() async {
    emit(state.copyWith(loadStatusLearning: LoadStatus.loading));
    final response = await _flashCardRespository.getSetFlashCardsLearning();
    response.fold(
      (l) {
        emit(state.copyWith(
          loadStatusLearning: LoadStatus.failure,
          message: l.message,
        ));
        showToast(
          title: l.message,
          type: ToastificationType.error,
        );
      },
      (r) => emit(state.copyWith(
        loadStatusLearning: LoadStatus.success,
        flashCardsLearning: r,
      )),
    );
  }

  Future<void> createFlashCardSet(String title, String description) async {
    if (title.isEmpty) {
      emit(state.copyWith(
        loadStatus: LoadStatus.failure,
        message: "Vui lòng nhập tiêu đề",
      ));
      showToast(
        title: "Vui lòng nhập tiêu đề",
        type: ToastificationType.error,
      );
      return;
    }
    final response =
        await _flashCardRespository.createFlashCardSet(title, description);
    response.fold(
      (l) {
        emit(state.copyWith(
          loadStatus: LoadStatus.failure,
          message: l.message,
        ));
        showToast(
          title: l.message,
          type: ToastificationType.error,
        );
      },
      (r) => emit(state.copyWith(
        loadStatus: LoadStatus.success,
        flashCards: [r, ...state.flashCards],
      )),
    );
  }

  Future<void> deleteFlashCardSet(String id) async {
    final response = await _flashCardRespository.deleteFlashCardSet(id);
    response.fold(
      (l) {
        emit(state.copyWith(
          loadStatus: LoadStatus.failure,
          message: l.message,
        ));
        showToast(
          title: l.message,
          type: ToastificationType.error,
        );
      },
      (r) {
        emit(state.copyWith(
          loadStatus: LoadStatus.success,
          flashCards: state.flashCards.where((e) => e.id != id).toList(),
        ));
      },
    );
  }

  Future<void> deleteFlashCardLearning(String learningSetId) async {
    final response =
        await _flashCardRespository.deleteFlashCardLearning(learningSetId);
    response.fold(
      (l) {
        emit(state.copyWith(
          loadStatusLearning: LoadStatus.failure,
          message: l.message,
        ));
        showToast(
          title: l.message,
          type: ToastificationType.error,
        );
      },
      (r) {
        emit(state.copyWith(
          loadStatusLearning: LoadStatus.success,
          flashCardsLearning: state.flashCardsLearning
              .where((e) => e.id != learningSetId)
              .toList(),
        ));
      },
    );
  }

  Future<void> updateFlashCardSet(
      String id, String title, String description) async {
    if (title.isEmpty) {
      emit(state.copyWith(
        loadStatus: LoadStatus.failure,
        message: "Vui lòng nhập tiêu đề",
      ));
      showToast(
        title: "Vui lòng nhập tiêu đề",
        type: ToastificationType.error,
      );
      return;
    }
    final response =
        await _flashCardRespository.updateFlashCardSet(id, title, description);
    response.fold(
      (l) {
        emit(state.copyWith(
          loadStatus: LoadStatus.failure,
          message: l.message,
        ));
        showToast(
          title: l.message,
          type: ToastificationType.error,
        );
      },
      (r) {
        emit(state.copyWith(
          loadStatus: LoadStatus.success,
          flashCards: state.flashCards.map((e) => e.id == id ? r : e).toList(),
        ));
      },
    );
  }

  void updateSetFlashCardAfterAddedd({
    required String setFlashCardId,
  }) {
    emit(state.copyWith(
      flashCards: state.flashCards.map((e) {
        if (e.id == setFlashCardId) {
          return e.copyWith(
            numberOfFlashcards: e.numberOfFlashcards + 1,
          );
        }
        return e;
      }).toList(),
    ));
  }

  void updateSetFlashCardAfterRemoved({
    required String setFlashCardId,
  }) {
    emit(state.copyWith(
      flashCards: state.flashCards.map((e) {
        if (e.id == setFlashCardId) {
          if (e.numberOfFlashcards <= 0) {
            return e;
          }
          return e.copyWith(
            numberOfFlashcards: e.numberOfFlashcards - 1,
          );
        }
        return e;
      }).toList(),
    ));
  }
}
